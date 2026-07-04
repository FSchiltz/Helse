namespace Helse.Models.Files;

public abstract class BaseFile
{
    public FileType Type { get; set; }

    public DateTime Start { get; set; }

    public DateTime? Stop { get; set; }

    public required string Name { get; set; }

    public required string Description { get; set; }
}
