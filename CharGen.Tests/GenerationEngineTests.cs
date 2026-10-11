using System.Collections.Generic;
using System.Linq;
using CharGen.Generation;
using CharGen.Models;
using Xunit;

namespace CharGen.Tests;

public class GenerationEngineTests
{
    private static ValueDto V(int id, string key, string text, double weight = 1, string? tags = null)
        => new(id, key, text, weight, tags);

    private static PropertyDto P(int id, string key, string type, params ValueDto[] values)
        => new(id, key, key, type, null, null, false, id, values.ToList());

    private static GenerationEngine BuildEngine()
    {
        var core = new BlockDto(1, "core", "Основное", 1, true, new List<PropertyDto>
        {
            P(1, "race", "list", V(1, "human", "Человек"), V(2, "elf", "Эльф"), V(3, "dwarf", "Дварф")),
            P(2, "gender", "list", V(4, "male", "Мужской"), V(5, "female", "Женский")),
            P(3, "age", "list",
                V(6, "age_20", "20", tags: "race=human"),
                V(7, "age_140", "140", tags: "race=elf")),
            P(4, "origin", "list",
                V(8, "noble", "Знатный род"),
                V(9, "commoner", "Простолюдин")),
        });

        var appearance = new BlockDto(2, "appearance", "Внешний вид", 2, false, new List<PropertyDto>
        {
            P(5, "height", "list",
                V(10, "h_100", "100", tags: "race=dwarf,gender=female"),
                V(11, "h_170", "170", tags: "race=human,race=elf"),
                V(12, "h_185", "185", tags: "race=human,gender=male")),
            P(6, "build", "list",
                V(13, "slim", "Худощавое"),
                V(14, "normal", "Обычное"),
                V(15, "stocky", "Крепкое")),
            P(7, "weight", "computed"),
            P(8, "hair_color", "list",
                V(16, "silver", "Серебристый", tags: "race=elf,origin=noble"),
                V(17, "black", "Чёрный", tags: "race=human,race=dwarf")),
        });

        return new GenerationEngine(new List<BlockDto> { core, appearance });
    }

    private static string Signature(GenerationResult r)
        => string.Join(";", r.Val.OrderBy(kv => kv.Key).Select(kv => $"{kv.Key}={kv.Value}"));

    [Fact]
    public void Одинаковый_seed_даёт_одинаковый_результат()
    {
        var engine = BuildEngine();
        Assert.Equal(Signature(engine.Generate(seed: 42)),
                     Signature(engine.Generate(seed: 42)));
    }

    [Fact]
    public void Режим_linked_без_правок_и_free_с_правкой()
    {
        var engine = BuildEngine();
        Assert.Equal("linked", engine.Generate(seed: 1).Mode);
        Assert.Equal("free", engine.Generate(fix: new() { ["race"] = "elf" }, seed: 1).Mode);
    }

    [Fact]
    public void Зафиксированное_значение_сохраняется()
    {
        var engine = BuildEngine();
        var result = engine.Generate(fix: new() { ["race"] = "elf" }, seed: 7);
        Assert.Equal("elf", result.Val["race"]);
    }

    [Fact]
    public void Вес_считается_от_роста_и_телосложения()
    {
        var engine = BuildEngine();
        var result = engine.Generate(
            fix: new() { ["height"] = "h_185", ["build"] = "normal" }, seed: 3);
        // 185 * 0.45 * 1.0 = 83.25 -> 83
        Assert.Equal("83", result.Val["weight"]);
    }

    [Fact]
    public void У_эльфов_волосы_в_основном_эльфийские()
    {
        var engine = BuildEngine();
        int elves = 0, elfHair = 0;

        for (int seed = 0; seed < 500; seed++)
        {
            var r = engine.Generate(seed: seed);
            if (r.Val["race"] != "elf") continue;

            elves++;
            if (r.Val["hair_color"] is "silver" or "blond") elfHair++;
        }

        Assert.True(elves > 50, "должно сгенерироваться достаточно эльфов");
        Assert.True(elfHair > elves * 0.6,
            $"эльфийских волос должно быть большинство, а вышло {elfHair}/{elves}");
    }
}