USE TesteDotNetExtractta;
GO
    CREATE OR ALTER PROCEDURE dbo.sp_IncluirPedido
        @ClienteId INT,
        @Valor DECIMAL(18,2),
        @PedidoId INT OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;
        SET XACT_ABORT ON;

        IF @Valor IS NULL OR @Valor <= 0
            THROW 50003, N'O valor do pedido deve ser maior que zero.', 1;

        DECLARE @ClienteExiste BIT = 0;
        DECLARE @ClientePossuiPedido CHAR(1);
        DECLARE @ValorFinal DECIMAL(18,2) = @Valor;

        BEGIN TRY
            BEGIN TRANSACTION;

            --O bloqueio na linha do cliente serializa inclusões feitas por
            --esta procedure para o mesmo cliente, assim duas sessões concorrentes
            --não tratam ambas o respectivo pedido como o primeiro e deixam aplicar
            --o desconto devido.
            SELECT @ClienteExiste = 1
            FROM Clientes WITH (UPDLOCK, HOLDLOCK)
            WHERE ClienteId = @ClienteId;

            IF @ClienteExiste = 0
                THROW 50004, N'Cliente não encontrado.', 1;
            
            SET @ClientePossuiPedido = dbo.fn_ClientePossuiPedido(@ClienteId);

            IF @ClientePossuiPedido = 'S'
                SET @ValorFinal = CONVERT(DECIMAL(18,2), ROUND(@Valor * CAST(0.95 AS DECIMAL(3,2)), 2));
            
            INSERT INTO Pedidos (ClienteId, Valor)
            VALUES (@ClienteId, @ValorFinal);

            SET @PedidoId = CONVERT(INT, SCOPE_IDENTITY());

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            IF XACT_STATE() <> 0
                ROLLBACK TRANSACTION;

            THROW;
        END CATCH;
    END;
GO            
