namespace Helse.Models.Common;

public class Pagination
{
    public int Page { get; set; }

    public int PageSize { get; set; }
}

public class Paginated<T>
{
    public int Count { get; set; }

    public required T[] Items { get; set; }
}