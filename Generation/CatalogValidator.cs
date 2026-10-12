using CharGen.Models;

namespace CharGen.Generation;

public static class CatalogValidator
{
    public static List<string> Validate(List<BlockDto> catalog)
    {
        var warnings = new List<string>();
        var byKey = catalog.SelectMany(b => b.Properties).ToDictionary(p => p.PropKey);

        if (!catalog.Any(b => b.IsRoot))
            warnings.Add("нет ни одного корневого блока (is_root = 1)");

        foreach (var block in catalog)
        {
            var visible = block.Properties.Where(p => !p.IsService).ToList();
            if (visible.Count == 0)
                warnings.Add($"блок «{block.Title}» ({block.BlockKey}) без свойств");
        }

        foreach (var prop in byKey.Values)
        {
            if (prop.ValueType == "list" && prop.Values.Count == 0)
                warnings.Add($"свойство «{prop.Title}» ({prop.PropKey}) типа list без значений");

            if (prop.ValueType is not ("list" or "computed" or "template"))
                warnings.Add($"свойство «{prop.Title}» ({prop.PropKey}) с неизвестным типом «{prop.ValueType}»");
        }

        foreach (var prop in byKey.Values)
        {
            foreach (var value in prop.Values)
            {
                if (string.IsNullOrWhiteSpace(value.Tags)) continue;

                foreach (var rawTag in value.Tags.Split(',', StringSplitOptions.RemoveEmptyEntries))
                {
                    var tag = rawTag.Trim();
                    var parts = tag.Split('=');

                    if (parts.Length != 2)
                    {
                        warnings.Add($"значение «{value.Text}» свойства «{prop.PropKey}»: неправильный тег «{tag}»");
                        continue;
                    }

                    var parentKey = parts[0].Trim();
                    var parentValue = parts[1].Trim();

                    if (!byKey.TryGetValue(parentKey, out var parent))
                    {
                        warnings.Add($"значение «{value.Text}» свойства «{prop.PropKey}»: тег ссылается на несуществующее свойство «{parentKey}»");
                        continue;
                    }

                    if (!parent.Values.Any(v => v.ValKey == parentValue))
                        warnings.Add($"значение «{value.Text}» свойства «{prop.PropKey}»: у свойства «{parentKey}» нет значения «{parentValue}»");
                }
            }
        }

        return warnings;
    }
}