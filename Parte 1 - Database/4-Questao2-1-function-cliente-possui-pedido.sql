USE TesteDotNetExtractta;

GO
    CREATE OR ALTER FUNCTION dbo.fn_ClientePossuiPedido
    (
        @ClienteId INT
    )
    RETURNS CHAR(1)
    AS
    BEGIN
        RETURN
        (
            CASE 
                WHEN EXISTS 
                (
                    SELECT 1
                    FROM Pedidos AS p 
                    WHERE ClienteId = @ClienteId
                ) THEN 'S'
                ELSE 'N'
            END
        );
    END;
GO