namespace Api.Models;

/// <summary>
/// Data needed to start a connection
/// </summary>
/// <param name="User"></param>
/// <param name="Password"></param>
public record Connection(string User, string Password, string? Redirect);
