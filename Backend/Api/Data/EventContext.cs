using System.Data;
using Helse.Api.Data.Helpers;
using Helse.Api.Data.Models.Health;
using Helse.Models.Common;
using Helse.Models.Persons;
using LinqToDB;
using LinqToDB.Async;
using LinqToDB.Data;

namespace Helse.Api.Data;

internal class EventContext(DataConnection db, SlowQueryLogInterceptor interceptor)
: BaseContext(db, interceptor), IEventContext
{
    /// <inheritdoc/>
    public Task<long> Insert(Helse.Models.Events.CreateEvent e, long person, long user)
    {
        return Db.GetTable<Event>().InsertWithInt64IdentityAsync(() => new Event
        {
            PersonId = person,
            UserId = user,
            Type = e.Type,
            Description = e.Description,
            Stop = e.Stop,
            Start = e.Start,
            Tag = e.Tag,
            NotificationTime = e.NotificationTime,
            Source = (int)e.Source,
            SourceId = e.SourceId,
            Valid = true,
            NotificationSent = false,
            Created = DateTime.UtcNow,
        });
    }

    /// <inheritdoc/>
    public Task DeleteEvent(long id) => Db.GetTable<Event>().DeleteAsync(x => x.Id == id);

    /// <inheritdoc/>
    public Task<int> DeleteEventType(long id) => Db.GetTable<EventType>().DeleteAsync(x => x.Id == id && x.UserEditable);
    /// <inheritdoc/>
    public Task<Event?> GetEvent(long id) => Db.GetTable<Event>().FirstOrDefaultAsync(x => x.Id == id);

    /// <inheritdoc/>
    public Task<Event[]> GetEvents(long id, int type, DateTime start, DateTime end)
    {
        return Db.GetTable<Event>()
            .Where(x => x.PersonId == id
                && x.Type == type
                && x.Start <= end && start <= x.Stop)
            .ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task<Event[]> GetEvents(long user, RightType right, DateTime start, DateTime end)
    {
        return (from e in Db.GetTable<Event>()
                join r in Db.GetTable<Models.Persons.Right>() on e.PersonId equals r.PersonId
                where e.Start <= end && start <= e.Stop
                where r.UserId == user && r.Type == (int)right
                select e)
            .ToArrayAsync();
    }

    public Task<Event[]> GetEventToPublish(DateTime start, DateTime end)
    {
        return Db.GetTable<Event>()
            .Where(x => x.NotificationTime != null && x.NotificationTime > start && x.NotificationTime <= end && !x.NotificationSent)
            .ToArrayAsync();
    }

    public Task MarkEventNotificationSent(long id)
    {
        return Db.GetTable<Event>().Where(
                x => x.Id == id)
            .Set(x => x.NotificationSent, true)
            .UpdateAsync();
    }

    /// <inheritdoc/>
    public Task<EventType[]> GetEventTypes(bool? all, bool standalone = false)
    {
        IQueryable<EventType> query = Db.GetTable<EventType>().Where(x => x.StandAlone);

        if (all == false)
            query = query.Where(x => x.Visible);

        return query.OrderBy(x => x.Id).ToArrayAsync();
    }

    /// <inheritdoc/>
    public Task Insert(Helse.Models.Events.CreateEventType eventType)
    {
        return Db.GetTable<EventType>().InsertAsync(() => new EventType
        {
            Name = eventType.Name,
            Description = eventType.Description,
            StandAlone = eventType.StandAlone,
            UserEditable = true,
            Visible = eventType.Visible,
            TimeDifference = eventType.TimeDifference,
            GroupId = eventType.GroupId,
        });
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task Update(Helse.Models.Events.UpdateEventType type)
    {
        return Db.GetTable<EventType>()
            .Where(x => x.Id == type.Id)
            .Set(x => x.Name, type.Name)
            .Set(x => x.Description, type.Description)
            .Set(x => x.Visible, type.Visible)
            .Set(x => x.TimeDifference, type.TimeDifference)
            .Set(x => x.GroupId, type.GroupId)
            .UpdateAsync();
    }

    public Task Update(Helse.Models.Events.UpdateEvent e)
    {
        return Db.GetTable<Event>()
        .Where(x => x.Id == e.Id)
        .Set(x => x.Start, e.Start)
        .Set(x => x.Stop, e.Stop)
        .Set(x => x.Description, e.Description)
        .Set(x => x.Tag, e.Tag)
        .Set(x => x.NotificationTime, e.NotificationTime)
        .Set(x => x.Source, (int)e.Source)
        .Set(x => x.SourceId, e.SourceId)
        .UpdateAsync();
    }

    /// <summary>
    /// <inheritdoc/>
    /// </summary>
    public Task<Event?> ExistingEvent(long person, int type, int source, string sourceId)
    => Db.GetTable<Event>().FirstOrDefaultAsync(x => x.PersonId == person && x.Source == source && x.SourceId == sourceId && x.Type == type);
    public Task<Event[]> SearchEventsAsync(long person, Helse.Models.Events.SearchEvent search, Pagination pagination)
    {
        var query = Db.GetTable<Event>()
        .Where(x => x.Type == search.Type && x.PersonId == person)
        .ApplyFilter(search)
        .Skip(pagination.Page * pagination.PageSize).Take(pagination.PageSize);

        return query.ToArrayAsync();
    }

    public Task<long> CountEventsAsync(long person, Helse.Models.Events.SearchEvent search)
    {
        var query = Db.GetTable<Event>()
        .Where(x => x.Type == search.Type && x.PersonId == person)
        .ApplyFilter(search);

        return query.LongCountAsync();
    }

    public Task DeleteEvents(long[] ids, long person)
    {
        return Db.GetTable<Event>().DeleteAsync(x => ids.Contains(x.Id) && x.PersonId == person);
    }

    public Task UpdateBulk(Helse.Models.Events.PatchEvent e, long person)
    {
        var query = Db.GetTable<Event>()
        .Where(x => e.Ids.Contains(x.Id))
        .Where(x => x.PersonId == person).AsUpdatable();

        if (e.UpdateStart)
        {
            query = query.Set(x => x.Start, e.Start);
        }
        if (e.UpdateStop)
        {
            query = query.Set(x => x.Stop, e.Stop);
        }
        if (e.UpdateDescription)
        {
            query = query.Set(x => x.Description, e.Description);
        }
        if (e.UpdateTag)
        {
            query = query.Set(x => x.Tag, e.Tag);
        }

        return query.UpdateAsync();
    }

}
