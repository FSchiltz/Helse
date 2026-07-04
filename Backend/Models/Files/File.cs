namespace Helse.Models.Files;

public class File : BaseFile
{    
    public long Id { get; set; }

    public DateTime Created { get; set; }

    public long PersonId { get; set; }
}
