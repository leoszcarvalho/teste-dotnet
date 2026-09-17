USE TesteDotNetExtractta;
GO
    SELECT 
        c.ClienteId,
        c.Nome,
        SUM(p.valor) as ValorTotalPedidos
    FROM Clientes AS c
    INNER JOIN Pedidos AS p 
        ON p.ClienteId = c.ClienteId
    GROUP BY 
        c.ClienteId,
        c.Nome
    HAVING SUM(p.Valor) > 1000
    ORDER BY 
        ValorTotalPedidos DESC;
GO