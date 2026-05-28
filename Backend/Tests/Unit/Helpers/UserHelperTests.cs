using Api.Data;
using Api.Helpers;
using Api.Helpers.Auth;
using Api.Models.Persons;
using NSubstitute;

namespace Tests.Unit.Helpers;

public class UserHelperTests
{
    [Fact]
    public async Task CreateUserAsync_CreatesUserWithTransaction_WhenTypeIsUser()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var transaction = Substitute.For<ITransaction>();
        users.BeginTransactionAsync().Returns(transaction);

        var newUser = new PersonCreation
        {
            Name = "John",
            Surname = "Doe",
            UserName = "johndoe",
            Password = "password123",
            Types = [UserType.User]
        };

        users.InsertPerson(newUser).Returns(1L);
        users.InsertUser(newUser, 1L, Arg.Any<string>()).Returns(1L);

        // Act
        await users.CreateUserAsync(newUser, 1L);

        // Assert
        await transaction.Received(1).CommitAsync();
        await users.Received(1).InsertPerson(newUser);
        await users.Received(1).InsertUser(newUser, 1L, Arg.Any<string>());
    }

    [Fact]
    public async Task CreateUserAsync_CreatesUserWithTransaction_WhenTypeIsAdmin()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var transaction = Substitute.For<ITransaction>();
        users.BeginTransactionAsync().Returns(transaction);

        var newUser = new PersonCreation
        {
            Name = "Admin",
            Surname = "User",
            UserName = "admin",
            Password = "adminpass",
            Types = new HashSet<UserType> { UserType.Admin }
        };

        users.InsertPerson(newUser).Returns(2L);
        users.InsertUser(newUser, 2L, Arg.Any<string>()).Returns(1L);

        // Act
        await users.CreateUserAsync(newUser, 1L);

        // Assert
        await transaction.Received(1).CommitAsync();
        await users.Received(1).InsertPerson(newUser);
        await users.Received(1).InsertUser(newUser, 2L, Arg.Any<string>());
    }

    [Fact]
    public async Task CreateUserAsync_AddsRights_WhenTypeIsNotUserOrAdmin()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var transaction = Substitute.For<ITransaction>();
        users.BeginTransactionAsync().Returns(transaction);

        var newUser = new PersonCreation
        {
            Name = "Caregiver",
            Surname = "User",
            Types = []
        };

        users.InsertPerson(newUser).Returns(3L);
        users.AddRight(Arg.Any<long>(), Arg.Any<long>(), Arg.Any<RightType>()).Returns(Task.CompletedTask);

        // Act
        await users.CreateUserAsync(newUser, 1L);

        // Assert
        await transaction.Received(1).CommitAsync();
        await users.Received(1).InsertPerson(newUser);
        await users.Received(1).AddRight(1L, 3L, RightType.Edit);
        await users.Received(1).AddRight(1L, 3L, RightType.View);
    }

    [Fact]
    public async Task CreateUserAsync_ThrowsArgumentException_WhenUserNameIsNull()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var transaction = Substitute.For<ITransaction>();
        users.BeginTransactionAsync().Returns(transaction);

        var newUser = new PersonCreation
        {
            Name = "John",
            Surname = "Doe",
            UserName = null,
            Password = "password123",
            Types = [UserType.User]
        };

        users.InsertPerson(newUser).Returns(1L);

        // Act & Assert
        await Assert.ThrowsAsync<ArgumentException>(async () => await users.CreateUserAsync(newUser, 1L));
    }

    [Fact]
    public async Task CreateUserAsync_ThrowsArgumentException_WhenPasswordIsNull()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var transaction = Substitute.For<ITransaction>();
        users.BeginTransactionAsync().Returns(transaction);

        var newUser = new PersonCreation
        {
            Name = "John",
            Surname = "Doe",
            UserName = "johndoe",
            Password = null,
            Types = [UserType.User]
        };

        users.InsertPerson(newUser).Returns(1L);

        // Act & Assert
        await Assert.ThrowsAsync<ArgumentException>(async () => await users.CreateUserAsync(newUser, 1L));
    }

    [Fact]
    public async Task CreateUserAsync_DisposesTransaction()
    {
        // Arrange
        var users = Substitute.For<IUserContext>();
        var transaction = Substitute.For<ITransaction>();
        users.BeginTransactionAsync().Returns(transaction);

        var newUser = new PersonCreation
        {
            Name = "John",
            Surname = "Doe",
            UserName = "johndoe",
            Password = "password123",
            Types = new HashSet<UserType> { UserType.User }
        };

        users.InsertPerson(newUser).Returns(1L);

        // Act
        await users.CreateUserAsync(newUser, 1L);

        // Assert
        await transaction.Received(1).DisposeAsync();
    }
}
