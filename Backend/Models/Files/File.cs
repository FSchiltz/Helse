namespace Helse.Models.Files;

public class File
{
    public long Id { get; set; }

    public DateTime Created { get; set; }

    public required byte[] Data { get; set; }

    public required string DataType { get; set; }

    public FileType Type { get; set; }

    public long PersonId { get; set; }

    public DateTime Start { get; set; }

    public DateTime? Stop { get; set; }

    public required string Name { get; set; }

    public required string Description { get; set; }
}
