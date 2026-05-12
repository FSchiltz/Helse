using System.Net;
using System.Net.Mail;
using Api.Data;
using Api.Data.Models;
using Api.Models.Settings.Admin;
using Microsoft.IdentityModel.Tokens;

namespace Api.Helpers;

public class EventNotificationService(IServiceProvider serviceProvider, ILogger<EventNotificationService> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken token)
    {
        logger.LogInformation("Event notification service started.");

        while (!token.IsCancellationRequested)
        {
            try
            {
                await CheckEventsAsync(token);
                await Task.Delay(TimeSpan.FromSeconds(60), token);
            }
            catch (OperationCanceledException)
            {
                break;
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Error while checking events for notifications.");
            }
        }
    }

    private async Task CheckEventsAsync(CancellationToken cancellationToken)
    {
        var now = DateTime.UtcNow;
        var start = now.AddMinutes(-1);
        var end = now.AddMinutes(1);

        using var scope = serviceProvider.CreateScope();
        var health = scope.ServiceProvider.GetRequiredService<IHealthContext>();
        var settings = scope.ServiceProvider.GetRequiredService<ISettingsContext>();

        var smtpSettings = await settings.GetSettings<Smtp>(Smtp.Name);
        var gotifySettings = await settings.GetSettings<Gotify>(Gotify.Name);

        var events = await health.GetEventToPublish(start, end);

        foreach (var e in events)
        {
            if (cancellationToken.IsCancellationRequested)
            {
                break;
            }

            try
            {
                if (e.NotificationSent)
                {
                    continue;
                }

                if (e.NotificationTime is null)
                {
                    continue;
                }

                if (e.NotificationTime > start && e.NotificationTime < end)
                {
                    var message = new EventMessage(BuildBody(e), $"Upcoming event starting at {e.Start:yyyy-MM-dd HH:mm}", 1);
                    if (smtpSettings.Enabled)
                    {
                        if (string.IsNullOrWhiteSpace(e.User?.Email))
                        {
                            logger.LogInformation("Skipping event notification for event {EventId} because the associated user has no email.", e.Id);
                        }
                        else
                        {
                            await SendEmailAsync(smtpSettings, message, e.User.Email);
                        }
                    }

                    if (gotifySettings.Enabled)
                    {
                        var httpBuilder = serviceProvider.GetRequiredService<IHttpClientFactory>();
                        await SendGotifyAsync(httpBuilder, gotifySettings, message);
                    }

                    await health.MarkEventNotificationSent(e.Id);
                }
                logger.LogInformation("Sent event notification for event {EventId} to {Email}.", e.Id, e.User?.Email);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Failed to send event notification for event {EventId} to {Email}.", e.Id, e.User?.Email);
            }
        }
    }

    private record EventMessage(string Message, string Title, int Priority);

    private static Task SendGotifyAsync(IHttpClientFactory builder, Gotify gotifySettings, EventMessage message)
    {
        using var client = builder.CreateClient();
        client.BaseAddress = new Uri(gotifySettings.Url ?? throw new InvalidOperationException());

        return client.PostAsJsonAsync($"/message?token={gotifySettings.Token}", message);
    }

    private static string BuildBody(Event e)
    {
        return $@"An event is about to start:

Event Id: {e.Id}
Person Id: {e.PersonId}
Start: {e.Start:yyyy-MM-dd HH:mm}
Stop: {e.Stop:yyyy-MM-dd HH:mm}
Type: {e.Type}
Description: {e.Description ?? "(no description)"}

Please open the application to review the event details.";
    }

    private static async Task SendEmailAsync(Smtp smtpSettings, EventMessage message, string recipient)
    {
        using var email = new MailMessage(smtpSettings.FromEmail, recipient, message.Title, message.Message)
        {
            IsBodyHtml = false,
            BodyEncoding = System.Text.Encoding.UTF8,
            SubjectEncoding = System.Text.Encoding.UTF8
        };

        using var client = new SmtpClient(smtpSettings.SmtpHost, smtpSettings.SmtpPort)
        {
            EnableSsl = smtpSettings.EnableSsl,
            DeliveryMethod = SmtpDeliveryMethod.Network,
            UseDefaultCredentials = false
        };

        if (!string.IsNullOrWhiteSpace(smtpSettings.UserName))
        {
            client.Credentials = new NetworkCredential(smtpSettings.UserName, smtpSettings.Password ?? string.Empty);
        }

        await client.SendMailAsync(email);
    }
}
