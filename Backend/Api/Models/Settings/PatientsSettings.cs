namespace Api.Models.Settings;

public class PatientsSettings : IJsonSettings
{
    public static string Name => "Patients";

    public PatientSettings Default { get; set; } = new();

    public List<PatientSettings> Patients { get; set; } = [];
}
