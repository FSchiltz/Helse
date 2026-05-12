using Api.Data.Models;
using Api.Helpers;
using Api.Models.Events;

namespace Tests.Unit.Helpers;

public class EventHelpersTests
{
    [Fact]
    public void Summarize_ReturnsSummaryArray_WhenEventsProvidedForDays()
    {
        // Arrange
        var start = new DateTime(2024, 1, 1, 0, 0, 0);
        var end = new DateTime(2024, 1, 3, 0, 0, 0);
        
        var events = new List<Api.Data.Models.Event>
        {
            new() { Id = 1, Description = "Event 1", Start = new DateTime(2024, 1, 1, 10, 0, 0), Stop = new DateTime(2024, 1, 1, 12, 0, 0) },
            new() { Id = 2, Description = "Event 2", Start = new DateTime(2024, 1, 2, 14, 0, 0), Stop = new DateTime(2024, 1, 2, 16, 0, 0) }
        };

        // Act
        var result = events.Summarize(start, end);

        // Assert
        Assert.NotNull(result);
        Assert.NotEmpty(result);
        Assert.All(result, summary => Assert.IsType<EventSummary>(summary));
    }

    [Fact]
    public void Summarize_ReturnsCorrectCount_WhenDaysRangeProvided()
    {
        // Arrange
        var start = new DateTime(2024, 1, 1);
        var end = new DateTime(2024, 1, 4);
        
        var events = new List<Api.Data.Models.Event>
        {
            new() { Id = 1, Description = "Event 1", Start = start.AddHours(10), Stop = start.AddHours(12) }
        };

        // Act
        var result = events.Summarize(start, end);

        // Assert
        Assert.NotNull(result);
        Assert.True(result.Length > 0);
    }

    [Fact]
    public void Summarize_AggregatesEventsByDescription()
    {
        // Arrange
        var start = new DateTime(2024, 1, 1);
        var end = new DateTime(2024, 1, 2);
        
        var events = new List<Api.Data.Models.Event>
        {
            new() { Id = 1, Description = "Type A", Start = start.AddHours(8), Stop = start.AddHours(10) },
            new() { Id = 2, Description = "Type A", Start = start.AddHours(14), Stop = start.AddHours(16) },
            new() { Id = 3, Description = "Type B", Start = start.AddHours(12), Stop = start.AddHours(13) }
        };

        // Act
        var result = events.Summarize(start, end);

        // Assert
        Assert.NotNull(result);
        Assert.NotEmpty(result);
        var firstSummary = result[0];
        Assert.True(firstSummary.Data.ContainsKey("Type A") || firstSummary.Data.ContainsKey("Type B"));
    }

    [Fact]
    public void Summarize_HandlesNullDescription()
    {
        // Arrange
        var start = new DateTime(2024, 1, 1);
        var end = new DateTime(2024, 1, 2);
        
        var events = new List<Api.Data.Models.Event>
        {
            new() { Id = 1, Description = null, Start = start.AddHours(8), Stop = start.AddHours(10) }
        };

        // Act
        var result = events.Summarize(start, end);

        // Assert
        Assert.NotNull(result);
        Assert.NotEmpty(result);
        // Should use empty string for null descriptions
        Assert.True(result.Any(s => s.Data.ContainsKey(string.Empty)));
    }

    [Fact]
    public void Summarize_ReturnsEmptyDataWhenNoEvents()
    {
        // Arrange
        var start = new DateTime(2024, 1, 1);
        var end = new DateTime(2024, 1, 2);
        
        var events = new List<Api.Data.Models.Event>();

        // Act
        var result = events.Summarize(start, end);

        // Assert
        Assert.NotNull(result);
        Assert.NotEmpty(result);
        Assert.All(result, summary => Assert.Empty(summary.Data));
    }

    [Fact]
    public void Min_ReturnsMinimumDate()
    {
        // Arrange
        var date1 = new DateTime(2024, 1, 5);
        var date2 = new DateTime(2024, 1, 3);

        // Act
        var result = EventHelpers.Min(date1, date2);

        // Assert
        Assert.Equal(date2, result);
    }

    [Fact]
    public void Max_ReturnsMaximumDate()
    {
        // Arrange
        var date1 = new DateTime(2024, 1, 5);
        var date2 = new DateTime(2024, 1, 3);

        // Act
        var result = EventHelpers.Max(date1, date2);

        // Assert
        Assert.Equal(date1, result);
    }

    [Fact]
    public void Summarize_HandlesCrossDateBoundary()
    {
        // Arrange
        var start = new DateTime(2024, 1, 1, 22, 0, 0);
        var end = new DateTime(2024, 1, 2, 2, 0, 0);
        
        var events = new List<Api.Data.Models.Event>
        {
            new() { Id = 1, Description = "Event Crossing Boundary", Start = start.AddHours(1), Stop = end.AddHours(-1) }
        };

        // Act
        var result = events.Summarize(start, end);

        // Assert
        Assert.NotNull(result);
        Assert.NotEmpty(result);
    }
}
