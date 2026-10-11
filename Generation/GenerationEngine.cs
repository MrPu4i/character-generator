using CharGen.Models;

namespace CharGen.Generation;

public class GenerationEngine
{
    private const double TagBoost = 5.0;

    // Зависимости вычисляемых свойств (в коде, раз формулы в коде)
    private static readonly Dictionary<string, string[]> ComputedDeps = new()
    {
        ["weight"] = new[] { "height", "build" }
    };

    private readonly Dictionary<string, PropertyDto> _byKey;
    private readonly Dictionary<string, List<string>> _parents;
    private readonly List<PropertyDto> _ordered;

    public GenerationEngine(List<BlockDto> catalog)
    {
        _byKey = catalog
            .SelectMany(b => b.Properties)
            .ToDictionary(p => p.PropKey);

        _parents = new Dictionary<string, List<string>>();
        foreach (var prop in _byKey.Values)
            _parents[prop.PropKey] = GetParents(prop);

        _ordered = SortTopologically();
    }

    public GenerationResult Generate(Dictionary<string, string>? fix = null, int? seed = null)
    {
        fix ??= new Dictionary<string, string>();
        var rng = seed.HasValue ? new Random(seed.Value) : new Random();
        var mode = fix.Count > 0 ? "free" : "linked";
        var val = new Dictionary<string, string>();

        foreach (var prop in _ordered)
        {
            // Зафиксированное значение берём как есть
            if (fix.TryGetValue(prop.PropKey, out var fixedValue))
            {
                val[prop.PropKey] = fixedValue;
                continue;
            }

            val[prop.PropKey] = prop.ValueType switch
            {
                "list" => prop.Values.Count == 0
                                ? ""
                                : PickWeighted(prop, val, rng, boost: mode == "linked").ValKey,
                "computed" => Compute(prop, val),
                _ => ""   // template реализуем позже
            };
        }

        return new GenerationResult(val, fix, mode);
    }

    // ---- родители и порядок ----

    private List<string> GetParents(PropertyDto prop)
    {
        var parents = new HashSet<string>();

        if (prop.ValueType == "computed" && ComputedDeps.TryGetValue(prop.PropKey, out var deps))
            foreach (var d in deps)
                if (_byKey.ContainsKey(d))
                    parents.Add(d);

        foreach (var value in prop.Values)
        {
            if (string.IsNullOrWhiteSpace(value.Tags)) continue;
            foreach (var tag in value.Tags.Split(',', StringSplitOptions.RemoveEmptyEntries))
            {
                var parts = tag.Split('=');
                if (parts.Length == 2)
                {
                    var parentKey = parts[0].Trim();
                    if (_byKey.ContainsKey(parentKey))
                        parents.Add(parentKey);
                }
            }
        }

        parents.Remove(prop.PropKey);
        return parents.ToList();
    }

    private List<PropertyDto> SortTopologically()
    {
        var result = new List<PropertyDto>();
        var done = new HashSet<string>();
        var remaining = _byKey.Values.ToList();
        bool progress = true;

        while (remaining.Count > 0 && progress)
        {
            progress = false;
            foreach (var prop in remaining.ToList())
            {
                if (_parents[prop.PropKey].All(done.Contains))
                {
                    result.Add(prop);
                    done.Add(prop.PropKey);
                    remaining.Remove(prop);
                    progress = true;
                }
            }
        }

        if (remaining.Count > 0)
            throw new InvalidOperationException(
                "Цикл в связях справочника: " +
                string.Join(", ", remaining.Select(p => p.PropKey)));

        return result;
    }

    // ---- выбор и вычисление ----

    private static ValueDto PickWeighted(
        PropertyDto prop,
        Dictionary<string, string> val,
        Random rng,
        bool boost)
    {
        var weights = new double[prop.Values.Count];
        double total = 0;

        for (int i = 0; i < prop.Values.Count; i++)
        {
            var v = prop.Values[i];
            double w = v.Weight <= 0 ? 1 : v.Weight;
            if (boost) w *= BoostMultiplier(v, val);
            weights[i] = w;
            total += w;
        }

        double r = rng.NextDouble() * total;
        double acc = 0;
        for (int i = 0; i < prop.Values.Count; i++)
        {
            acc += weights[i];
            if (r <= acc) return prop.Values[i];
        }
        return prop.Values[^1];
    }

    private static double BoostMultiplier(ValueDto value, Dictionary<string, string> val)
    {
        if (string.IsNullOrWhiteSpace(value.Tags)) return 1.0;

        double mult = 1.0;
        foreach (var tag in value.Tags.Split(',', StringSplitOptions.RemoveEmptyEntries))
        {
            var parts = tag.Split('=');
            if (parts.Length != 2) continue;

            var parentKey = parts[0].Trim();
            var parentValue = parts[1].Trim();

            if (val.TryGetValue(parentKey, out var actual) && actual == parentValue)
                mult *= TagBoost;
        }
        return mult;
    }

    private string Compute(PropertyDto prop, Dictionary<string, string> val)
    {
        switch (prop.PropKey)
        {
            case "weight":
                {
                    int height = GetNumeric(val, "height");
                    double coeff = val.GetValueOrDefault("build") switch
                    {
                        "slim" => 0.85,
                        "stocky" => 1.25,
                        _ => 1.0
                    };
                    return Math.Round(height * 0.45 * coeff).ToString();
                }
            default:
                return "";
        }
    }

    private int GetNumeric(Dictionary<string, string> val, string propKey)
    {
        if (!val.TryGetValue(propKey, out var rawValue)) return 0;
        if (!_byKey.TryGetValue(propKey, out var prop)) return 0;

        var found = prop.Values.FirstOrDefault(v => v.ValKey == rawValue);
        var text = found?.Text ?? rawValue;

        return int.TryParse(text, out var n) ? n : 0;
    }
}