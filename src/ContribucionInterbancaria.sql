CREATE DATABASE ContribucionInterbancaria


CREATE TABLE DolarBancos(
	idDolar INT NOT NULL IDENTITY(1,1),
	idBanco INT NOT NULL,
	idTipo	INT NOT NULL,
	compraActual FLOAT NOT NULL,
	ventaActual	 FLOAT NOT NULL,
	compra24h FLOAT,
	venta24h FLOAT,
	compra48h FLOAT,
	venta48h FLOAT,
	fechaHora DATETIME NOT NULL,
	estatus INT NOT NULL
)


CREATE TABLE Bancos(
	idBanco INT NOT NULL,
	nombreBanco VARCHAR(50) NOT NULL,
	fechaAlta DATE NOT NULL,
)

CREATE TABLE TipoDolares(
	idTipo INT NOT NULL IDENTITY(1,1),
	tipoDolar VARCHAR(50) NOT NULL,
	fechaRegistro DATE NOT NULL
)


CREATE PROCEDURE crudDolarBancos
	@idDolar	     INT,
	@idBanco		 INT,
	@idTipo			 INT,
	@compraActual	 FLOAT,
	@ventaActual	 FLOAT,
	@compra24h		 FLOAT,
	@venta24h		 FLOAT,
	@compra48h		 FLOAT,
	@venta48h		 FLOAT,
	@fechaHora		 DATETIME,
	@estatus		 INT,
	@ACCION			 VARCHAR(10)

AS
BEGIN
	IF @ACCION='SELECT'
		BEGIN
			SELECT *
			FROM DolarBancos
		END
	ELSE IF @ACCION='INSERT'
		BEGIN
			INSERT INTO DolarBancos
			VALUES(
				@idDolar,
				@idBanco,
				@idTipo,
				@compraActual,
				@ventaActual,
				@compra24h,
				@venta24h,
				@compra48h,
				@venta48h,
				@fechaHora,
				@estatus)
			SELECT * FROM DolarBancos
			WHERE idDolar = @idDolar
		END
	ELSE IF @ACCION='DELETE'
		BEGIN
			DELETE FROM DolarBancos
			WHERE idDolar=@idDolar
		END
END

SELECT *
FROM DolarBancos