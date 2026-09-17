using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Protocols.Configuration;
using System.Runtime.InteropServices;
using TesteDotNet.Helpers;

StringHelper stringHelper = new StringHelper();
string textoOriginal = "Teste de programação";
string textoInvertido = stringHelper.InverterPalavras(textoOriginal);

Console.WriteLine("O texto original é:");
Console.WriteLine(textoOriginal);
Console.WriteLine("O texto com palavras invertidas fica:");
Console.WriteLine(textoInvertido);

IConfiguration configuration = new ConfigurationBuilder()
    .SetBasePath(AppContext.BaseDirectory)
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: false)
    .Build();

string? connectionString = Environment.GetEnvironmentVariable("SQLSERVER_CONNECTION_STRING") ?? configuration.GetConnectionString("ConnectionStrings__SqlServer");

if(string.IsNullOrWhiteSpace(connectionString))
{
    connectionString = configuration["ConnectionStrings:SqlServer"];
}

if (string.IsNullOrEmpty(connectionString))
{
    Console.Error.WriteLine("Connection não configurada.");
    Environment.ExitCode = 2;
    return;
}

try
{
    var clienteRepository = new ClienteRepository(connectionString);
    var pedidoRepository = new PedidoRepository(connectionString);
    int clienteId = await clienteRepository.IncluirClienteAsync("João da Silva", "São Paulo");
    int primeiroPedidoId = await pedidoRepository.IncluirPedidoAsync(clienteId, 100.00m);
    int segundoPedidoId = await pedidoRepository.IncluirPedidoAsync(clienteId, 200.00m);
    Console.WriteLine("Cliente incluido com ID {0}", clienteId);
    Console.WriteLine("Primeiro pedido incluido com ID {0}", primeiroPedidoId);
    Console.WriteLine("Segundo pedido incluido com ID {0}", segundoPedidoId);
}
catch (Exception ex)
{
    Console.Error.WriteLine("Ocorreu um erro ao incluir os dados: {0}", ex.Message);
    Environment.ExitCode = 1;
}