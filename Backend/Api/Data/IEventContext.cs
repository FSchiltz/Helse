using Helse.Api.Data.Models.Health;
using Helse.Models.Persons;

namespace Helse.Api.Data;

internal interface IEventContext : IContext
{
    /// <summary>
    /// Insert a new event into the database
    /// </summary>
    /// <param name="e">The event</param>
    /// <param name="person">The person to which add the event to</param>
    /// <param name="user">The user making the addition</param>
    Task Insert(Helse.Models.Events.CreateEvent e, long person, long user);

    /// <summary>
    /// Get a single event by id
    /// </summary>
    /// <param name="id">The event id</param>
    /// <returns>The event if found, null otherwise</returns>
    Task<Event?> GetEvent(long id);

    /// <summary>
    /// Get events for a person in a given time frame
    /// </summary>
    /// <param name="id">The person id</param>
    /// <param name="start">The start of the time frame</param>
    /// <param name="end">The end of the time frame</param>
    /// <returns>The events matching the criteria</returns>
    Task<Event[]> GetEvents(long id, int type, DateTime start, DateTime end);

    /// <summary>
    /// Get the events to notify
    /// </summary>
    /// <param name="start">The start of the time frame</param>
    /// <param name="end">The end of the time frame</param>
    Task<Event[]> GetEventToPublish(DateTime start, DateTime end);

    /// <summary>
    /// Mark an event as having had its notification sent
    /// </summary>
    /// <param name="id">The event id</param>
    Task MarkEventNotificationSent(long id);

    /// <summary>
    /// Delete an event by id
    /// </summary>
    /// <param name="id">The event id</param>
    Task DeleteEvent(long id);

    /// <summary>
    /// Update an event
    /// </summary>
    /// <param name="e">The event to update</param>
    Task Update(Helse.Models.Events.UpdateEvent e);

    Task<EventType[]> GetEventTypes(bool? all, bool standalone = false);

    Task Insert(Helse.Models.Events.CreateEventType metric);

    Task Update(Helse.Models.Events.UpdateEventType type);

    Task<int> DeleteEventType(long id);

    Task<Event[]> GetEvents(long id, RightType view, DateTime start, DateTime end);

    Task<bool> ExistsEvent(long person, int type, int source, string sourceId);
}
