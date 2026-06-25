using Helse.Api.Data.Models.Health;
namespace Helse.Api.Data.Helpers;

internal static class EventHelper
{
    public static IQueryable<Event> ApplyFilter(this IQueryable<Event> query, Helse.Models.Events.SearchEvent search)
    {
        if (search.From is not null)
        {
            query = query.Where(x => x.Start >= search.From);
        }

        if (search.To is not null)
        {
            query = query.Where(x => x.Stop <= search.To);
        }

        if (search.Value is not null)
        {
            query = query.Where(x => x.Description.StartsWith(search.Value, StringComparison.CurrentCultureIgnoreCase));
        }

        if (search.FilterSource)
        {
            query = query.Where(x => x.Source == (int)search.Source);
        }

        return query;
    }
}
