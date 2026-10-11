namespace CharGen.Models;

public record CharacterDto(
    int V,
    Dictionary<string, string> Val,
    Dictionary<string, bool> Show,
    Dictionary<string, string> Fix);

public record GenerateRequest(
    Dictionary<string, bool>? Show,
    Dictionary<string, string>? Fix);

public record RegenerateRequest(
    int? V,
    Dictionary<string, string>? Val,
    Dictionary<string, bool>? Show,
    Dictionary<string, string>? Fix,
    string? Block);   // block_key; пусто/отсутствует => перегенерировать всё