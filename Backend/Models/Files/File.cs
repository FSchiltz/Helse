namespace Helse.Models.Files;

public record FileData(string Type, byte[] Data);

public class File : BaseFile
{
    public long Id { get; set; }

    public DateTime Created { get; set; }
}
