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
    /// A min and max value (2 numbers separated by a ';')
    /// </summary>
    MinMax = 3
}
