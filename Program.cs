using Microsoft.Data.Sqlite;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.UseDefaultFiles();
app.UseStaticFiles();

// --- создание базы при старте ---
var rootPath = app.Environment.ContentRootPath;          // папка проекта
var dbPath = Path.Combine(rootPath, "catalog.db");

if (!File.Exists(dbPath))
{
    var schema = File.ReadAllText(Path.Combine(rootPath, "schema.sql"));
    var seed = File.ReadAllText(Path.Combine(rootPath, "seed.sql"));

    using var connection = new SqliteConnection($"Data Source={dbPath}");
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
else
{
    Console.WriteLine($"База уже есть: {dbPath}");
}

app.Run();
