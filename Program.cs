using CharGen.Data;
using CharGen.Generation;
using Microsoft.Data.Sqlite;
using CharGen.Models;

var builder = WebApplication.CreateBuilder(args);

var rootPath = builder.Environment.ContentRootPath;
var dbPath = Path.Combine(rootPath, "catalog.db");
var connectionString = $"Data Source={dbPath}";

if (!File.Exists(dbPath))
{
    var schema = File.ReadAllText(Path.Combine(rootPath, "schema.sql"));
    var seed = File.ReadAllText(Path.Combine(rootPath, "seed.sql"));

    using var connection = new SqliteConnection(connectionString);
    connection.Open();

    using (var cmd = connection.CreateCommand())
    {
        cmd.CommandText = schema;
        cmd.ExecuteNonQuery();
    }
    using (var cmd = connection.CreateCommand())
    {
        cmd.CommandText = seed;
        cmd.ExecuteNonQuery();
    }
    Console.WriteLine($"База создана: {dbPath}");
}

var repository = new CatalogRepository(connectionString);
var catalogData = repository.GetCatalog();

var catalogWarnings = CatalogValidator.Validate(catalogData);
foreach (var warning in catalogWarnings)
    Console.WriteLine("Справочник: " + warning);
if (catalogWarnings.Count > 0)
    Console.WriteLine($"Всего предупреждений справочника: {catalogWarnings.Count}");

builder.Services.AddSingleton(repository);
builder.Services.AddSingleton(new GenerationEngine(catalogData));

var app = builder.Build();

app.UseDefaultFiles();
app.UseStaticFiles();

// Показать все свойства (пока нет экрана выбора)
static Dictionary<string, bool> AllShown(GenerationEngine engine)
    => engine.PropertyKeys.ToDictionary(k => k, _ => true);

app.MapGet("/api/catalog", (CatalogRepository repo) => repo.GetCatalog());

app.MapPost("/api/generate", (GenerateRequest req, GenerationEngine engine) =>
{
    var fix = req.Fix ?? new Dictionary<string, string>();
    var result = engine.Generate(fix, req.Preset);
    return new CharacterDto(1, result.Val, req.Show ?? AllShown(engine), result.Fix, null);
});

app.MapPost("/api/regenerate", (RegenerateRequest req, GenerationEngine engine) =>
{
    var fix = req.Fix ?? new Dictionary<string, string>();
    var result = engine.Regenerate(req.Val ?? new Dictionary<string, string>(), fix, req.Block);
    return new CharacterDto(req.V ?? 1, result.Val, req.Show ?? AllShown(engine), result.Fix, req.Id);
});

app.Run();