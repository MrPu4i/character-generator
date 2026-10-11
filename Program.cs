using CharGen.Data;
using CharGen.Generation;
using Microsoft.Data.Sqlite;

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

builder.Services.AddSingleton(repository);
builder.Services.AddSingleton(new GenerationEngine(repository.GetCatalog()));

var app = builder.Build();

app.UseDefaultFiles();
app.UseStaticFiles();

app.MapGet("/api/catalog", (CatalogRepository repo) => repo.GetCatalog());

// временная ссылка для ручной проверки движка (потом заменим на /api/generate)
app.MapGet("/api/debug/generate", (GenerationEngine engine, int? seed) =>
    engine.Generate(seed: seed ?? 42));

app.Run();