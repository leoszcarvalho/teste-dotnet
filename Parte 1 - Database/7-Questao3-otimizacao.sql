/*O índice usa o Preco como chave porque essa coluna participa
do predicado de faixa, dependendo da selectividade de Preco > 100,
o otimizador pode escolher um Index Seek, Nome foi incluído para cobrir
a consulta e evitar key lookup no índice clusterizado ou RID Lookup caso a tabela seja heap, 
mas não faz parte da ordenação do índice após uma faixa de Preco,
por isso o ORDER BY Nome ainda pode exigir um operador Sort, 
o índice consome armazenamento e aumenta o custo do INSERT, UPDATE E DELETE,
a escolha definitiva deve ser validada com o plano de execução real
e as estatísticas abaixo quando grande parte da tabela satisfaz o filtro um scan
pode ser mais barato que seek.
*/
GO

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.indexes
        WHERE object_id = OBJECT_ID(N'dbo.Produtos')
        AND name = N'IX_Produtos_Preco'
    )
    BEGIN
        CREATE NONCLUSTERED INDEX IX_Produtos_Preco
            ON dbo.Produtos (Preco)
            INCLUDE (Nome);
    END;
GO

    SET STATISTICS IO ON;
    SET STATISTICS TIME ON;

    SELECT Nome
    FROM dbo.Produtos
    WHERE Preco > 100
    ORDER BY Nome;

    SET STATISTICS IO OFF;
    SET STATISTICS TIME OFF;
GO