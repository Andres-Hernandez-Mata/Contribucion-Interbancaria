USE ContribucionInterbancaria;
CREATE DATABASE ContribucionInterbancaria;
DROP TABLE DolarBancos;
SELECT * FROM DolarBancos;

CREATE TABLE DolarBancos(
	idDolar INT IDENTITY(1,1) NOT NULL,
	idBanco INT NOT NULL,
	idTipo	INT NOT NULL,
	compraActual FLOAT NOT NULL,
	ventaActual	 FLOAT NOT NULL,
	compra24h FLOAT,
	venta24h FLOAT,
	compra48h FLOAT,
	venta48h FLOAT,
	fechaHora DATETIME NOT NULL,
	estatus INT DEFAULT(0) NOT NULL,
	CONSTRAINT FkidBanco FOREIGN KEY (idBanco) REFERENCES Bancos(idBanco),
	CONSTRAINT FkidTipo FOREIGN KEY (idTipo) REFERENCES TipoDolares(idTipo)
)

INSERT INTO Bancos (nombreBanco, fechaAlta) VALUES ('BBVA Bancomer', GETDATE()), ('Santander', GETDATE()), ('Banamex', GETDATE());
SELECT * FROM Bancos;

CREATE TABLE Bancos(
	idBanco INT IDENTITY(1,1) NOT NULL,
	nombreBanco VARCHAR(50) NOT NULL,
	fechaAlta DATE NOT NULL,
	CONSTRAINT idBanco PRIMARY KEY (idBanco)
);

INSERT INTO TipoDolares (tipoDolar, fechaRegistro) VALUES ('Ventanilla', GETDATE()), ('Interbancario', GETDATE());
SELECT * FROM TipoDolares;

CREATE TABLE TipoDolares(
	idTipo INT IDENTITY(1,1) NOT NULL,
	tipoDolar VARCHAR(50) NOT NULL,
	fechaRegistro DATE NOT NULL,
	CONSTRAINT idTipo PRIMARY KEY (idTipo)
);

ALTER PROCEDURE crudDolarBancos(
	@IdDolar	     INT,
	@IdBanco		 INT,
	@IdTipo			 INT,
	@CompraActual	 FLOAT,
	@VentaActual	 FLOAT,
	@Compra24h		 FLOAT = NULL,
	@Venta24h		 FLOAT = NULL,
	@Compra48h		 FLOAT = NULL,
	@Venta48h		 FLOAT = NULL,
	@FechaHora		 DATETIME,
	@Estatus		 INT,
	@Accion			 VARCHAR(10)
)
AS
BEGIN
	IF @Accion='SELECT'
		BEGIN
			SELECT b.nombreBanco, d.compraActual, d.ventaActual, d.compra24h, d.venta24h, d.compra48h, d.venta48h, t.tipoDolar, 
			format(d.fechaHora, 'dd-MM-yyyy HH:mm') as fechaHora
			FROM DolarBancos d
			INNER JOIN Bancos b
			ON d.idBanco = b.idBanco
			INNER JOIN TipoDolares t
			ON t.idTipo = d.idTipo
			WHERE d.fechaHora = @FechaHora AND
			d.idBanco = @IdBanco AND d.estatus = 0


		END
	ELSE IF @Accion='INSERT'
		BEGIN
			INSERT INTO DolarBancos
			VALUES(				
				@IdBanco,
				@IdTipo,
				@CompraActual,
				@VentaActual,
				@Compra24h,
				@Venta24h,
				@Compra48h,
				@Venta48h,
				@FechaHora,
				@Estatus			
			)									
			SELECT TOP 1 * FROM DolarBancos ORDER BY idDolar DESC			
		END
	ELSE IF @Accion='DELETE'
		BEGIN
			DELETE FROM DolarBancos
			WHERE idDolar = @idDolar
		END	
END

SELECT * FROM DolarBancos

EXEC crudDolarBancos 1, 1, 1, 18.80, 20.20, NULL, NULL, NULL, NULL, '2021-09-09 00:00:00.000', 0, 'SELECT';

EXEC crudDolarBancos 0, 3, 2, 16.20, 18.20, NULL, NULL, NULL, NULL, '2021-09-09 00:00:00.000', 0, 'INSERT';
EXEC crudDolarBancos 1, 1, 1, 18.80, 20.20, NULL, NULL, NULL, NULL, '2021-09-08 00:00:00.000', 0, 'DELETE';


DECLARE @Dolar INT
SELECT TOP 1 @Dolar = idDolar FROM DolarBancos ORDER BY idDolar DESC
UPDATE DolarBancos SET estatus = 1 WHERE idDolar = @Dolar