using Microsoft.Data.SqlClient;

public class PedidoRepository
{
    private readonly string _connectionString;
    public PedidoRepository(string connectionString) 
    { 
        if(string.IsNullOrEmpty(connectionString)) 
            throw new ArgumentNullException("A string de conexão do SQL Server não pode estar vazia", nameof(connectionString));
        _connectionString = connectionString;
    }

    public async Task<int> IncluirPedidoAsync(int clienteId, decimal valor, CancellationToken cancellationToken = default)
    {
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand("dbo.sp_IncluirPedido", connection)
        {
            CommandType = System.Data.CommandType.StoredProcedure
        };
        command.Parameters.AddWithValue("@ClienteId", clienteId);
        command.Parameters.AddWithValue("@Valor", valor);
        var pedidoIdParameter = new SqlParameter("@PedidoId", System.Data.SqlDbType.Int)
        {
            Direction = System.Data.ParameterDirection.Output
        };
        command.Parameters.Add(pedidoIdParameter);
        await connection.OpenAsync(cancellationToken);
        await command.ExecuteNonQueryAsync(cancellationToken);
        return pedidoIdParameter.Value is int pedidoId ?
            pedidoId : throw new InvalidOperationException("A procedure não retornou um ID de pedido válido");
    }
}