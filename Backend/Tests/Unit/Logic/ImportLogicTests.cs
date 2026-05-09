using Api.Logic;
using Xunit;

namespace Tests.Unit.Logic;

public class ImportLogicTests
{
    [Fact]
    public void GetImportTypes_ReturnsFileTypes()
    {
        // Act
        var result = ImportLogic.GetImportTypes();

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<IEnumerable<Api.Logic.FileType>>>(result);
        Assert.NotNull(okResult.Value);
        Assert.NotEmpty(okResult.Value);
    }
}