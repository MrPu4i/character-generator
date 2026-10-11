using CharGen.Models;
using Microsoft.Data.Sqlite;

namespace CharGen.Data;

public class CatalogRepository
{
    private readonly string _connectionString;

    public CatalogRepository(string connectionString)
    {
        _connectionString = connectionString;
    }

    public List<BlockDto> GetCatalog()
    {
        var blocks = new List<BlockDto>();
        var blocksById = new Dictionary<int, BlockDto>();
        var propsById = new Dictionary<int, PropertyDto>();

        using var connection = new SqliteConnection(_connectionString);
        connection.Open();

        // 1. Блоки
        using (var cmd = connection.CreateCommand())
        {
            cmd.CommandText =
                "SELECT block_id, block_key, title, sort_order, is_root " +
                "FROM blocks ORDER BY sort_order";
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                var block = new BlockDto(
                    reader.GetInt32(0),
                    reader.GetString(1),
                    reader.GetString(2),
                    reader.GetInt32(3),
                    reader.GetInt32(4) == 1,
                    new List<PropertyDto>());

                blocks.Add(block);
                blocksById[block.BlockId] = block;
            }
        }

        // 2. Свойства
        using (var cmd = connection.CreateCommand())
        {
            cmd.CommandText =
                "SELECT prop_id, block_id, prop_key, title, value_type, " +
                "default_value, unit, is_service, sort_order " +
                "FROM properties ORDER BY sort_order";
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                var prop = new PropertyDto(
                    reader.GetInt32(0),
                    reader.GetString(2),
                    reader.GetString(3),
                    reader.GetString(4),
                    reader.IsDBNull(6) ? null : reader.GetString(6),
                    reader.IsDBNull(5) ? null : reader.GetString(5),
                    reader.GetInt32(7) == 1,
                    reader.GetInt32(8),
                    new List<ValueDto>());

                var blockId = reader.GetInt32(1);
                blocksById[blockId].Properties.Add(prop);
                propsById[prop.PropId] = prop;
            }
        }

        // 3. Значения
        using (var cmd = connection.CreateCommand())
        {
            cmd.CommandText =
                "SELECT val_id, prop_id, val_key, text, weight, tags FROM prop_values";
            using var reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                var value = new ValueDto(
                    reader.GetInt32(0),
                    reader.GetString(2),
                    reader.GetString(3),
                    reader.GetDouble(4),
                    reader.IsDBNull(5) ? null : reader.GetString(5));

                var propId = reader.GetInt32(1);
                if (propsById.TryGetValue(propId, out var prop))
                    prop.Values.Add(value);
            }
        }

        return blocks;
    }
}