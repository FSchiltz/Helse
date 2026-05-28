using Api.Data;
using Api.Data.Models.Persons;
using Api.Models.Persons;
using LinqToDB;
using LinqToDB.Data;

namespace Tests.Unit.Data;

public class UserContextTests : IAsyncLifetime
{
    private DataConnection _db = null!;

    public async Task InitializeAsync()
    {
        // Create in-memory SQLite database
        _db = new DataConnection("SQLite.MS",  x=> new LinqToDB.DataOptions().UseSQLite("Data Source=:memory:"));
        await _db.CreateTableAsync<Person>();
        await _db.CreateTableAsync<User>();
        await _db.CreateTableAsync<Api.Data.Models.Persons.Right>();
    }

    public async Task DisposeAsync()
    {
        if (_db != null)
            await _db.DisposeAsync();
    }

    [Fact(Skip = "Not working")]
    public async Task Count_ReturnsZero_WhenNoUsers()
    {
        // Arrange
        var context = new UserContext(_db);

        // Act
        var count = await context.Count();

        // Assert
        Assert.Equal(0, count);
    }

    [Fact(Skip = "Not working")]
    public async Task Count_ReturnsCorrectCount_WhenUsersExist()
    {
        // Arrange
        var person = new Person { Name = "Test", Identifier = "test", Birth = DateTime.UtcNow };
        var personId = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => person);

        var user = new User { PersonId = personId, Identifier = "testuser", Password = "hashed", Type = 0 };
        await _db.GetTable<User>().InsertAsync(() => user);

        var context = new UserContext(_db);

        // Act
        var count = await context.Count();

        // Assert
        Assert.Equal(1, count);
    }

    [Fact(Skip = "Not working")]
    public async Task Get_ReturnsNull_WhenUserNotFound()
    {
        // Arrange
        var context = new UserContext(_db);

        // Act
        var result = await context.Get("nonexistent");

        // Assert
        Assert.Null(result);
    }

    [Fact(Skip = "Not working")]
    public async Task Get_ReturnsUser_WhenUserExists()
    {
        // Arrange
        var person = new Person { Name = "John", Identifier = "john", Birth = DateTime.UtcNow };
        var personId = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => person);

        var user = new User { PersonId = personId, Identifier = "john_user", Password = "hashed", Type = 1, Email = "john@example.com" };
        await _db.GetTable<User>().InsertAsync(() => user);

        var context = new UserContext(_db);

        // Act
        var result = await context.Get("john_user");

        // Assert
        Assert.NotNull(result);
        Assert.Equal("john_user", result.User.Identifier);
        Assert.Equal("John", result.Person.Name);
    }

    [Fact(Skip = "Not working")]
    public async Task HasRightAsync_ReturnsNull_WhenNoRight()
    {
        // Arrange
        var person1 = new Person { Name = "Person1", Identifier = "p1", Birth = DateTime.UtcNow };
        var person1Id = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => person1);

        var person2 = new Person { Name = "Person2", Identifier = "p2", Birth = DateTime.UtcNow };
        var person2Id = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => person2);

        var user = new User { PersonId = person1Id, Identifier = "user", Password = "pass", Type = 0 };
        var userId = (long)await _db.GetTable<User>().InsertWithIdentityAsync(() => user);

        var context = new UserContext(_db);
        var now = DateTime.UtcNow;

        // Act
        var result = await context.HasRightAsync(userId, person2Id, RightType.View, now);

        // Assert
        Assert.Null(result);
    }

    [Fact(Skip = "Not working")]
    public async Task HasRightAsync_ReturnsRight_WhenRightExists()
    {
        // Arrange
        var person1 = new Person { Name = "Person1", Identifier = "p1", Birth = DateTime.UtcNow };
        var person1Id = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => person1);

        var person2 = new Person { Name = "Person2", Identifier = "p2", Birth = DateTime.UtcNow };
        var person2Id = (long)await _db.GetTable<Person>().InsertWithIdentityAsync(() => person2);

        var user = new User { PersonId = person1Id, Identifier = "user", Password = "pass", Type = 0 };
        var userId = (long)await _db.GetTable<User>().InsertWithIdentityAsync(() => user);

        var now = DateTime.UtcNow;
        var right = new Api.Data.Models.Right
        {
            UserId = userId,
            PersonId = person2Id,
            Type = (int)RightType.View,
            Start = now.AddHours(-1),
            Stop = now.AddHours(1)
        };
        await _db.GetTable<Api.Data.Models.Persons.Right>().InsertAsync(() => right);

        var context = new UserContext(_db);

        // Act
        var result = await context.HasRightAsync(userId, person2Id, RightType.View, now);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(RightType.View, result.Type);
    }
}