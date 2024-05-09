
using System.ComponentModel;

namespace Api.Models;

/// <summary>
/// Import file type supported by the app
/// </summary>
public enum FileTypes
{
    None = 0,

    [Description("Redmi watch fitness file")]
    RedmiWatch,

    [Description("Data from health connect on android")]
    GoogleHealthConnect,
}
