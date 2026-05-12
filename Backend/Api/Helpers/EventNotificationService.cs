using System.Net;
using System.Net.Mail;
using Api.Data;
using Api.Data.Models;

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
                var wait = await CheckEventsAsync(token);
                await Task.Delay(TimeSpan.FromSeconds(wait), token);
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

    private async Task<SmtpSettings> LoadSmtpSettingsAsync()
    {
        using var scope = serviceProvider.CreateScope();
        var settings = scope.ServiceProvider.GetRequiredService<ISettingsContext>();
        return await settings.GetSettings<SmtpSettings>("smtp");
    }

    private async Task<int> CheckEventsAsync(CancellationToken cancellationToken)
    {
        var now = DateTime.UtcNow;

        // Load SMTP settings from database
        var smtpSettings = await LoadSmtpSettingsAsync();

        if (string.IsNullOrWhiteSpace(smtpSettings.SmtpHost) || string.IsNullOrWhiteSpace(smtpSettings.FromEmail))
        {
            logger.LogWarning("Event notification service is disabled because SMTP configuration is missing.");
            return 60;
        }

        var end = now.Add(TimeSpan.FromMinutes(smtpSettings.StartingWindowMinutes));

        using var scope = serviceProvider.CreateScope();
        var health = scope.ServiceProvider.GetRequiredService<IHealthContext>();

        var events = await health.GetEventsStartingSoon(now, end);

        foreach (var e in events)
        {
            if (cancellationToken.IsCancellationRequested)
            {
                break;
            }

            if (string.IsNullOrWhiteSpace(e.User?.Email))
            {
                logger.LogInformation("Skipping event notification for event {EventId} because the associated user has no email.", e.Id);
                await health.MarkEventNotificationSent(e.Id);
                continue;
            }

            try
            {
                await SendEmailAsync(smtpSettings, e.User.Email, $"Upcoming event starting at {e.Start:yyyy-MM-dd HH:mm}", BuildBody(e));
                await health.MarkEventNotificationSent(e.Id);
                logger.LogInformation("Sent event notification for event {EventId} to {Email}.", e.Id, e.User.Email);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Failed to send event notification for event {EventId} to {Email}.", e.Id, e.User.Email);
            }
        }

        return smtpSettings.PollingSeconds;
    }


    private static string BuildBody(Event @event)
    {
        return $@"An event is about to start:

Event Id: {@event.Id}
Person Id: {@event.PersonId}
Start: {@event.Start:yyyy-MM-dd HH:mm}
Stop: {@event.Stop:yyyy-MM-dd HH:mm}
Type: {@event.Type}
Description: {@event.Description ?? "(no description)"}

Please open the application to review the event details.";
    }

    private static async Task SendEmailAsync(SmtpSettings smtpSettings, string recipient, string subject, string body)
    {
        using var message = new MailMessage(smtpSettings.FromEmail, recipient, subject, body)
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

        await client.SendMailAsync(message);
    }
}
