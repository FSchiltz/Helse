using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Api.Data;
using Api.Data.Models;
using Api.Helpers;
using LinqToDB;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace Api.Controllers;

[ApiController]
[Route("[controller]")]
public class AuthController : ControllerBase
{
    private readonly ILogger<AuthController> _logger;
    private readonly AppDataConnection _repository;
    private readonly IConfiguration _configuration;

    public AuthController(AppDataConnection repository, IConfiguration configuration, ILogger<AuthController> logger)
    {
        _logger = logger;
        _repository = repository;
        _configuration = configuration;
    }

    /// <summary>
    /// Connect and get a token
    /// </summary>
    /// <returns></returns>
    [HttpPost]
    [AllowAnonymous]
    public async Task<ActionResult> Post([FromBody] (string user, string password) user, CancellationToken token)
    {
        // auth
        var fromDb = await _repository.GetTable<User>().Where(x => x.Identifier == user.user).FirstOrDefaultAsync(token);

        if (fromDb is null)
            return Unauthorized();

        // hash the password
        var hash = JwtHelper.Hash(user.password);

        // generate the token
        if (hash == fromDb.Password)
        {
            return Ok(GetToken(fromDb));
        }
        else
        {
            _logger.LogWarning("Unauthorized access to getToken");
            return Unauthorized();
        }
    }

    protected string GetToken(Api.Data.Models.User user)
    {
        var issuer = _configuration["Jwt:Issuer"];
        var audience = _configuration["Jwt:Audience"];
        var key = Encoding.ASCII.GetBytes(_configuration["Jwt:Key"]);

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Identifier),
                new Claim(JwtRegisteredClaimNames.Email, user.Email)
             }),
            Expires = DateTime.UtcNow.AddMinutes(5),
            Issuer = issuer,
            Audience = audience,
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha512Signature)
        };
        var tokenHandler = new JwtSecurityTokenHandler();
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}
