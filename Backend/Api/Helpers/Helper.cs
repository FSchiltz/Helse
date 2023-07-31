using System.ComponentModel;

namespace Api.Helpers;

public static class Helper
{
    public static string? DescriptionAttr<T>(this T source)
    {
        var fi = source?.GetType().GetField(source.ToString());

        var attributes = (DescriptionAttribute[]?)fi?.GetCustomAttributes(
            typeof(DescriptionAttribute), false);

        if (attributes != null && attributes.Length > 0) return attributes[0].Description;
        else return source?.ToString();
    }
}