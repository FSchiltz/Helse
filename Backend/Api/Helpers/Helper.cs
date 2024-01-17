using System.ComponentModel;

namespace Api.Helpers;

public static class Helper
{
    public static string? DescriptionAttr<T>(this T source)
    {
        if (source is null)
            return null;

        var sourceText = source.ToString();

        if (sourceText is null)
            return sourceText;

        var fi = source.GetType().GetField(sourceText);

        var attributes = (DescriptionAttribute[]?)fi?.GetCustomAttributes(typeof(DescriptionAttribute), false);

        if (attributes != null && attributes.Length > 0) return attributes[0].Description;
        else return sourceText;
    }
}