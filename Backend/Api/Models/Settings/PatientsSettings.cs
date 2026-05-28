namespace Api.Models.Settings;

public class PatientsSettings : IJsonSettings
{
    public static string Name => "Patients";

    public List<PatientSettings> Patients { get; set; } = [];
}
