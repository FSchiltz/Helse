using Helse.Api.Data;
using Helse.Api.Data.Models.Persons;
using LinqToDB;
using LinqToDB.Data;
using Microsoft.Extensions.Logging;
using NSubstitute;

namespace Tests.Unit.Data;

[Collection("Database collection")]
public class UserContextTests(DatabaseFixture fixture) : IAsyncLifetime
{
    private DataConnection _db = null!;

    private readonly SlowQueryLogInterceptor _interceptor = new(
        Substitute.For<ILogger<SlowQueryLogInterceptor>>());

    public async ValueTask InitializeAsync()
    {
        var temp = await fixture.GetTempDB();
        _db = new DataConnection(x => new DataOptions().UsePostgreSQL(temp));
        await DatabaseFixture.InitForUnit(_db);
    }

    public async ValueTask DisposeAsync()
    {
        if (_db != null)
            await _db.DisposeAsync();
    }

    [Fact]
    public async Task Count_ReturnsZero_WhenNoUsers()
    {
        // Arrange
        var context = new UserContext(_db, _interceptor);

        // Act
        var count = await context.Count();

        // Assert
        Assert.Equal(0, count);
    }

    [Fact]
    public async Task Count_ReturnsCorrectCount_WhenUsersExist()
    {
        // Arrange
        var personId = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Name = "Test",
            Identifier = "test",
            Birth = DateTime.UtcNow,
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        await _db.GetTable<User>().InsertAsync(() => new User
        {
            PersonId = personId,
            Identifier = "testuser",
            Password = "hashed",
            Type = 0,
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        var context = new UserContext(_db, _interceptor);

        // Act
        var count = await context.Count();

        // Assert
        Assert.Equal(1, count);
    }

    [Fact]
    public async Task Get_ReturnsNull_WhenUserNotFound()
    {
        // Arrange
        var context = new UserContext(_db, _interceptor);

        // Act
        var result = await context.Get("nonexistent");

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task Get_ReturnsUser_WhenUserExists()
    {
        // Arrange
        var personId = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Name = "John",
            Identifier = "john",
            Birth = DateTime.UtcNow,
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        await _db.GetTable<User>().InsertAsync(() => new User
        {
            PersonId = personId,
            Identifier = "john_user",
            Password = "hashed",
            Type = 1,
            Email = "john@example.com",
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        var context = new UserContext(_db, _interceptor);

        // Act
        var result = await context.Get("john_user");

        // Assert
        Assert.NotNull(result);
        Assert.Equal("john_user", result.Identifier);
    }

    [Fact]
    public async Task HasRightAsync_ReturnsNull_WhenNoRight()
    {
        // Arrange
        var person1Id = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Name = "Person1",
            Identifier = "p1",
            Birth = DateTime.UtcNow,
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        var person2Id = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Name = "Person2",
            Identifier = "p2",
            Birth = DateTime.UtcNow,
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        var userId = (long)await _db.GetTable<User>().InsertWithIdentityAsync(() => new User
        {
            PersonId = person1Id,
            Identifier = "user",
            Password = "pass",
            Type = 0,
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        var context = new UserContext(_db, _interceptor);
        var now = DateTime.UtcNow;

        // Act
        var result = await context.HasRightAsync(userId, person2Id, Helse.Models.Persons.RightType.View, now);

        // Assert
        Assert.Null(result);
    }

    [Fact]
    public async Task HasRightAsync_ReturnsRight_WhenRightExists()
    {
        // Arrange
        var person1Id = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Name = "Person1",
            Identifier = "p1",
            Birth = DateTime.UtcNow,
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        var person2Id = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => new Person
        {
            Name = "Person2",
            Identifier = "p2",
            Birth = DateTime.UtcNow,
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        var userId = (long)await _db.GetTable<User>().InsertWithIdentityAsync(() => new User
        {
            PersonId = person1Id,
            Identifier = "user",
            Password = "pass",
            Type = 0,
            Created = DateTime.Now
        }, token: TestContext.Current.CancellationToken);

        var now = DateTime.UtcNow;
        await _db.GetTable<Right>().InsertAsync(() => new Right
        {
            UserId = userId,
            PersonId = person2Id,
            Type = (int)Helse.Models.Persons.RightType.View,
            Start = now.AddHours(-1),
            Stop = now.AddHours(1),
            Created = DateTime.Now,
        }, token: TestContext.Current.CancellationToken);

        var context = new UserContext(_db, _interceptor);

        // Act
        var result = await context.HasRightAsync(userId, person2Id, Helse.Models.Persons.RightType.View, now);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(Helse.Models.Persons.RightType.View, result.Type);
    }
}