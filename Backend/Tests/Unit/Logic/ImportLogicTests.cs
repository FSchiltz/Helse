using Helse.Api.Logic;
using Helse.Models.Imports;

namespace Tests.Unit.Logic;

public class ImportLogicTests : LogicTests
{
    [Fact]
    public void GetImportTypes_ReturnsFileTypes()
    {
        // Act
        var result = ImportLogic.GetImportTypes();

        // Assert
        var okResult = Assert.IsType<Microsoft.AspNetCore.Http.HttpResults.Ok<IEnumerable<ImportType>>>(result);
        Assert.NotNull(okResult.Value);
        Assert.NotEmpty(okResult.Value);
    }
}