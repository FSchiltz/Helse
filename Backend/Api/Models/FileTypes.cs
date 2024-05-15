
using System.ComponentModel;

namespace Api.Models;

/// <summary>
/// Import file type supported by the app
/// </summary>
public enum FileTypes
{
    /// <summary>
    /// Manually added data
    /// </summary>
    None = 0,

    [Description("Redmi watch fitness file")]
    RedmiWatch,

    [Description("Data from health connect on android")]
    GoogleHealthConnect,

    [Description("Data from the Clue application")]
    Clue,
}
