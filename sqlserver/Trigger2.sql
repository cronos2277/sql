-- Criando tabelas e restricoes
CREATE TABLE FUNCSAL (ID SMALLINT IDENTITY, SALARIO MONEY NOT NULL)
ALTER TABLE FUNCSAL ADD CONSTRAINT PK_GATILHO PRIMARY KEY (ID)
CREATE TABLE FUNCSAL_LIMITE (ID SMALLINT PRIMARY KEY, PISO MONEY, TETO MONEY)
INSERT INTO FUNCSAL_LIMITE VALUES(1,0,0)
GO

-- Aqui nos colocamos um limite na tabela FUNCSAL_LIMITE, travando a tabela para INSERT e DELETE.
CREATE TRIGGER TRG_FUNCSAL
ON FUNCSAL_LIMITE
FOR INSERT,DELETE
AS
	BEGIN
		RAISERROR('OPERACAO NAO PERMITIDA PARA FUNCSAL_LIMITE',16,1)
		ROLLBACK TRANSACTION
	END
GO

-- Adicionando limites para que o valor esteja acima do piso e abaixo do teto
CREATE TRIGGER TRG_LIMITE_FUNCSAL
ON DBO.FUNCSAL
FOR INSERT, UPDATE
AS
	DECLARE 
		@ID SMALLINT,
		@SALARIO MONEY,
		@PISO MONEY,
		@TETO MONEY

	SELECT @ID = ID, @SALARIO = SALARIO FROM DBO.FUNCSAL
	SELECT @PISO = PISO, @TETO = TETO FROM DBO.FUNCSAL_LIMITE

	IF(@SALARIO > @TETO)
		BEGIN
			RAISERROR('VALOR ACIMA DO TETO',16,1)
			ROLLBACK TRANSACTION
		END
	ELSE IF(@SALARIO < @PISO)
		BEGIN
			RAISERROR('VALOR ABAIXO DO PISO',16,1)
			ROLLBACK TRANSACTION
		END
	ELSE
		BEGIN
			PRINT('QUERY EXECUTADO COM SUCESSO!')
		END
GO

-- Verificando se o teto eh maior que o piso
CREATE TRIGGER TRG_FUNCSAL_LIMITE_ORDEM
ON DBO.FUNCSAL_LIMITE
FOR INSERT,UPDATE
AS
	DECLARE @PISO MONEY
	DECLARE @TETO MONEY
	SELECT @PISO = PISO, @TETO = TETO FROM DBO.FUNCSAL_LIMITE
	IF(@PISO >= @TETO)
		BEGIN
			RAISERROR('PISO ACIMA DO TETO',16,1)
			ROLLBACK TRANSACTION
		END
	ELSE
		BEGIN
			PRINT('QUERY EXECUTADO COM SUCESSO!')
		END
GO


-- definindo o piso e o teto
UPDATE DBO.FUNCSAL_LIMITE SET PISO = 1000 WHERE ID = 1
UPDATE DBO.FUNCSAL_LIMITE SET TETO = 9999 WHERE ID = 1
GO

-- PROJETANDO O TETO E O PISO
SELECT PISO,TETO FROM FUNCSAL_LIMITE
GO
