namespace Tests;

public static class TestHelpers
{
    /// <summary>
    /// Postgres store only up to the microseconds so we have to truncate the value when asserting
    /// </summary>
    /// <param name="dateTime"></param>
    /// <returns></returns>
    public static DateTime Truncate(this DateTime dateTime)
    {
        if (dateTime == DateTime.MinValue || dateTime == DateTime.MaxValue) return dateTime; // do not modify "guard" values

        return dateTime.AddTicks(-(dateTime.Ticks % TimeSpan.FromMicroseconds(1).Ticks));
    }
}
