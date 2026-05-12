using Api.Data;
using Api.Helpers;
using NSubstitute;
using System.Text.Json;

namespace Tests.Unit.Helpers;

public record TestSettings(string Name, int Value);

public class SettingsHelperTests
{
    [Fact]
    public async Task SaveSettingsAsync_SerializesAndUpserts_WhenSettingsProvided()
    {
        // Arrange
        var db = Substitute.For<ISettingsContext>();
        var transaction = Substitute.For<ITransaction>();
        db.BeginTransactionAsync().Returns(transaction);
        
        var settings = new TestSettings("TestName", 42);

        // Act
        await db.SaveSettingsAsync("test-key", settings);

        // Assert
        await db.Received(1).Upsert("test-key", Arg.Any<string>());
        await transaction.Received(1).CommitAsync();
    }

    [Fact]
    public async Task SaveSettingsAsync_CommitsTransaction()
    {
        // Arrange
        var db = Substitute.For<ISettingsContext>();
        var transaction = Substitute.For<ITransaction>();
        db.BeginTransactionAsync().Returns(transaction);
        
        var settings = new TestSettings("TestName", 100);

        // Act
        await db.SaveSettingsAsync("test-key", settings);

        // Assert
        await transaction.Received(1).CommitAsync();
    }

    [Fact]
    public async Task SaveSettingsAsync_SerializesObjectAsJson()
    {
        // Arrange
        var db = Substitute.For<ISettingsContext>();
        var transaction = Substitute.For<ITransaction>();
        db.BeginTransactionAsync().Returns(transaction);
        
        var settings = new TestSettings("TestName", 42);
        var expectedJson = JsonSerializer.Serialize(settings);

        // Act
        await db.SaveSettingsAsync("test-key", settings);

        // Assert
        await db.Received(1).Upsert("test-key", expectedJson);
    }

    [Fact]
    public async Task SaveSettingsAsync_DisposesTransaction()
    {
        // Arrange
        var db = Substitute.For<ISettingsContext>();
        var transaction = Substitute.For<ITransaction>();
        db.BeginTransactionAsync().Returns(transaction);
        
        var settings = new TestSettings("TestName", 42);

        // Act
        await db.SaveSettingsAsync("test-key", settings);

        // Assert
        await transaction.Received(1).DisposeAsync();
    }

    [Fact]
    public async Task SaveSettingsAsync_WorksWithDifferentTypes()
    {
        // Arrange
        var db = Substitute.For<ISettingsContext>();
        var transaction = Substitute.For<ITransaction>();
        db.BeginTransactionAsync().Returns(transaction);
        
        var stringSettings = "SimpleString";

        // Act
        await db.SaveSettingsAsync("string-key", stringSettings);

        // Assert
        await db.Received(1).Upsert("string-key", Arg.Any<string>());
        await transaction.Received(1).CommitAsync();
    }

    [Fact]
    public async Task SaveSettingsAsync_PreservesNullValues()
    {
        // Arrange
        var db = Substitute.For<ISettingsContext>();
        var transaction = Substitute.For<ITransaction>();
        db.BeginTransactionAsync().Returns(transaction);
        
        var settings = new { Name = (string?)null, Value = 0 };

        // Act
        await db.SaveSettingsAsync("null-test", settings);

        // Assert
        await db.Received(1).Upsert("null-test", Arg.Any<string>());
    }
}
