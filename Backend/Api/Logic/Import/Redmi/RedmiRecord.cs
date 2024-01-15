namespace Api.Logic.Import.Redmi;

internal class RedmiRecord
{
    public string? Uid { get; set; }
    public string? Sid { get; set; }
    public string? Key { get; set; }
    public int Time { get; set; }
    public string? Value { get; set; }

    public string GetKey()
    {
        return $"{Key}_{Time}";
    }
}
