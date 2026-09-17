USE TesteDotNetExtractta;
GO 
    BEGIN
        CREATE TABLE Clientes
        (
            ClienteId INT IDENTITY(1,1) NOT NULL
                CONSTRAINT PK_Clientes PRIMARY KEY,
            Nome NVARCHAR(150) NOT NULL,
            Cidade NVARCHAR(100) NOT NULL
        );
    END;
GO
    BEGIN 
        CREATE TABLE Pedidos
        (
            PedidoId INT IDENTITY(1,1) NOT NULL
                CONSTRAINT PK_Pedidos PRIMARY KEY,
            ClienteId INT NOT NULL,
            Valor DECIMAL(18,2) NOT NULL,
            CONSTRAINT FK_Pedidos_Clientes
                FOREIGN KEY (ClienteId) 
                    REFERENCES Clientes (ClienteId),
            CONSTRAINT CK_Pedidos_Valor_NaoNegativo
                CHECK (Valor >= 0)
        );
    END;
GO
    BEGIN
        CREATE TABLE Produtos
        (
            ProdutosId INT IDENTITY(1,1) NOT NULL
                CONSTRAINT PK_Produtos PRIMARY KEY,
            Nome NVARCHAR(200) NOT NULL,
            Preco DECIMAL(18,2) NOT NULL,
            CONSTRAINT CK_Produtos_Preco_NaoNegativo 
                CHECK (Preco >= 0)
        );
    END;
GO