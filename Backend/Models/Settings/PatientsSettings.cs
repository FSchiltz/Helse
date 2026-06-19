namespace Helse.Models.Settings;

public class PatientsSettings : IJsonSettings
{
    public int Version { get; set; } = 1;

    public static string Name => "Patients";

    public PatientSettings Default { get; set; } = new();

    public List<PatientSettings> Patients { get; set; } = [];
}
