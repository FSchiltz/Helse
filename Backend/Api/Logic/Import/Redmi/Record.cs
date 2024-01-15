namespace Api.Logic.Import.Redmi;

internal class Record
{
    public int? Date_time { get; set; }
    public int? Time { get; set; }
    public int Timezone { get; set; }
}


internal class SpoRecord : Record
{
    public string? Spo2 { get; set; }
}

internal class HeartRecord : Record
{
    public string? Bpm { get; set; }
}

internal class StepRecord : Record
{
    public string? Steps { get; set; }
    public string? Distance { get; set; }
}

internal class CalorieRecord : Record
{
    public string? Calories { get; set; }
}

internal class WeightRecord : Record
{
    public string? Weight { get; set; }
}
