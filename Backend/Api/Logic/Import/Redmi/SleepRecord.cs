namespace Api.Logic.Import.Redmi;

public class SleepRecord
{
    public int Avg_hr { get; set; }
    public int Bpmedtime { get; set; }
    public int Sleep_deep_duration { get; set; }
    public int Device_bedtime { get; set; }
    public int Device_wake_up_time { get; set; }
    public int Sleep_light_duration { get; set; }
    public int Max_hr { get; set; }
    public int Min_hr { get; set; }
    public int ProtoTime { get; set; }
    public int Sleep_rem_duration { get; set; }
    public int Duration { get; set; }
    public List<SleepTime>? Items { get; set; }
    public int Timezone { get; set; }
    public int Version { get; set; }
    public int Awake_count { get; set; }
    public int Sleep_awake_duration { get; set; }
    public int Wake_up_time { get; set; }
}
