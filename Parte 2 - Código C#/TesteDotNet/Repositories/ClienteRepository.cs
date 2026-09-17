using Microsoft.Data.SqlClient;

public class ClienteRepository
{ 
    private readonly string _connectionString;

    public ClienteRepository(string connectionString)
    {
        if(string.IsNullOrWhiteSpace(connectionString)) { 
            throw new ArgumentException("A string de conexão do SQL Server não pode estar vazia", nameof(connectionString));
        }

        _connectionString = connectionString;
    }

    public async Task<int> IncluirClienteAsync(string nome, string cidade, CancellationToken cancellationToken = default)
    {
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand("dbo.sp_IncluirCliente", connection)
        {
            CommandType = System.Data.CommandType.StoredProcedure
        };
        command.Parameters.AddWithValue("@Nome", nome);
        command.Parameters.AddWithValue("@Cidade", cidade);
        
        var clienteIdParameter = new SqlParameter("@ClienteId", System.Data.SqlDbType.Int)
        {
            Direction = System.Data.ParameterDirection.Output
        };
        command.Parameters.Add(clienteIdParameter);

        await connection.OpenAsync(cancellationToken);
        await command.ExecuteNonQueryAsync(cancellationToken);

        return clienteIdParameter.Value is int clienteId ? 
            clienteId : throw new InvalidOperationException("A procedure não retornou um ID de cliente válido");
    }
}