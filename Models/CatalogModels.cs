namespace CharGen.Models;

public record ValueDto(
    int ValId,
    string ValKey,
    string Text,
    double Weight,
    string? Tags);

public record PropertyDto(
    int PropId,
    string PropKey,
    string Title,
    string ValueType,
    string? Unit,
    string? DefaultValue,
    bool IsService,
    int SortOrder,
    List<ValueDto> Values);

public record BlockDto(
    int BlockId,
    string BlockKey,
    string Title,
    int SortOrder,
    bool IsRoot,
    List<PropertyDto> Properties);