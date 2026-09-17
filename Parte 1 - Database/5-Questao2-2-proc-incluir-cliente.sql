USE TesteDotNetExtractta;
GO
    CREATE OR ALTER PROCEDURE dbo.sp_IncluirCliente
        @Nome NVARCHAR(150),
        @Cidade NVARCHAR(100),
        @ClienteId INT OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;
        SET XACT_ABORT ON;

        IF TRIM(ISNULL(@Nome, N'')) = N''
            THROW 50001, N'O nome do cliente é obrigatório.', 1;  
        
        IF TRIM(ISNULL(@Cidade, N'')) = N''
            THROW 50001, N'A cidade do cliente é obrigatória.', 1;  

        INSERT INTO Clientes (Nome, Cidade)
        VALUES (@Nome, @Cidade);

        SET @ClienteId = CONVERT(INT, SCOPE_IDENTITY());
    END
GO