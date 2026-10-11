namespace CharGen.Models;

public record GenerationResult(
    Dictionary<string, string> Val,
    Dictionary<string, string> Fix,
    string Mode);