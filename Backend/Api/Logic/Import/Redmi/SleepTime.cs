namespace Api.Logic.Import.Redmi;

public class SleepTime
{
    public int End_time { get; set; }
    public int State { get; set; }
    public int Start_time { get; set; }

    public string GetKey() => Start_time + "_" + End_time;
}
