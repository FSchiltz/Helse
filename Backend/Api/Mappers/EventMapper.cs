using Helse.Api.Data.Models.Health;
using Helse.Models.Imports;

namespace Helse.Api.Mappers;

internal static class EventMapper
{
    internal static Helse.Models.Events.EventType Map(EventType x)
    {
        return new Helse.Models.Events.EventType
        {
            Name = x.Name,
            Description = x.Description,
            Id = x.Id,
            StandAlone = x.StandAlone,
            Visible = x.Visible,
            UserEditable = x.UserEditable,
            TimeDifference = x.TimeDifference,
            GroupId = x.GroupId,
        };
    }

    internal static object Map(Event x)
    {
        return new Models.Events.Event
        {
            Id = x.Id,
            Type = x.Type,
            Description = x.Description,
            Stop = x.Stop,
            File = x.FileId,
            Start = x.Start,
            Valid = x.Valid,
            NotificationTime = x.NotificationTime,
            Source = (FileTypes)x.Source,
            SourceId = x.SourceId,
            Tag = x.Tag,
        };
    }
}
