using System.ComponentModel;
using Api.Helpers;

namespace Tests.Unit.Helpers;

public class HelperTests
{
    private enum TestEnum
    {
        [Description("First Value")]
        FirstValue = 1,
        
        [Description("Second Value")]
        SecondValue = 2,
        
        NoDescriptionValue = 3
    }

    [Fact]
    public void DescriptionAttr_ReturnsDescription_WhenEnumHasDescriptionAttribute()
    {
        // Arrange
        var value = TestEnum.FirstValue;

        // Act
        var result = value.DescriptionAttr();

        // Assert
        Assert.Equal("First Value", result);
    }

    [Fact]
    public void DescriptionAttr_ReturnsDescription_WhenEnumHasSecondDescription()
    {
        // Arrange
        var value = TestEnum.SecondValue;

        // Act
        var result = value.DescriptionAttr();

        // Assert
        Assert.Equal("Second Value", result);
    }

    [Fact]
    public void DescriptionAttr_ReturnsEnumName_WhenNoDescriptionAttribute()
    {
        // Arrange
        var value = TestEnum.NoDescriptionValue;

        // Act
        var result = value.DescriptionAttr();

        // Assert
        Assert.Equal("NoDescriptionValue", result);
    }

    [Fact]
    public void DescriptionAttr_ReturnsNull_WhenSourceIsNull()
    {
        // Arrange
        TestEnum? value = null;

        // Act
        var result = value.DescriptionAttr();

        // Assert
        Assert.Null(result);
    }
}
