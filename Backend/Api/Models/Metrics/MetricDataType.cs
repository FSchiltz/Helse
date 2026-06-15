namespace Api.Models.Metrics;

public enum MetricDataType
{
    Text = 0,
    Number = 1,
    /// <summary>
    /// True or false
    /// </summary>
    Bool = 2,
    /// <summary>
    /// A min and max value (Numbers separated by a ';')
    /// </summary>
    NumberRange = 3,
}
