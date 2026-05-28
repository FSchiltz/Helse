namespace Api.Models.Settings;

public class PatientsSettings : IJsonSettings
{
    public static string Name => "Patients";

    public PatientSettings? Default { get; set; }

    public List<PatientSettings> Patients { get; set; } = [];
}
