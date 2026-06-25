namespace Helse.Api.Logic.Import.Redmi;

internal class SleepTime
{
    public int End_time { get; set; }
    public int State { get; set; }
    public int Start_time { get; set; }

    public string GetKey => Start_time + "_" + End_time;

    public string StringState => State switch
    {
        2 => "Deep",
        3 => "Light",
        4 => "Rem",
        5 => "Awake",
        _ => State.ToString(),
    };
}
