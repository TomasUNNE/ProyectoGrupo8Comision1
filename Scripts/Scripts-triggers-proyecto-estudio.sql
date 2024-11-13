

CREATE TABLE AuditLogInmueble (
    AuditID INT IDENTITY PRIMARY KEY,
    TableName NVARCHAR(100),
    Operation NVARCHAR(10),
    PrimaryKeyValue INT,
    nro_piso NVARCHAR(MAX),
    dpto NVARCHAR(MAX),
    sup_Cubierta NVARCHAR(MAX),
    frente NVARCHAR(MAX),
    balcon NVARCHAR(MAX),
    idprovincia NVARCHAR(MAX),
    idlocalidad NVARCHAR(MAX),
    idconsorcio NVARCHAR(MAX),
    ModifiedBy NVARCHAR(100),
    ModifiedDate DATETIME
);


CREATE TRIGGER trg_Audit_Update_Inmueble
ON dbo.inmueble
AFTER UPDATE
AS
BEGIN
    DECLARE @userName NVARCHAR(100) = SYSTEM_USER;

    INSERT INTO AuditLogInmueble (
        TableName, Operation, PrimaryKeyValue, nro_piso, dpto, sup_Cubierta,
        frente, balcon, idprovincia, idlocalidad, idconsorcio, ModifiedBy, ModifiedDate
    )
    SELECT
        'inmueble' AS TableName,
        'UPDATE' AS Operation,
        d.idinmueble AS PrimaryKeyValue,
        CONVERT(NVARCHAR(MAX), d.nro_piso),
        CONVERT(NVARCHAR(MAX), d.dpto),
        CONVERT(NVARCHAR(MAX), d.sup_Cubierta),
        CONVERT(NVARCHAR(MAX), d.frente),
        CONVERT(NVARCHAR(MAX), d.balcon),
        CONVERT(NVARCHAR(MAX), d.idprovincia),
        CONVERT(NVARCHAR(MAX), d.idlocalidad),
        CONVERT(NVARCHAR(MAX), d.idconsorcio),
        @userName AS ModifiedBy,
        GETDATE() AS ModifiedDate
    FROM
        deleted d;
END;
GO


CREATE TRIGGER trg_Audit_Delete_Inmueble
ON dbo.inmueble
AFTER DELETE
AS
BEGIN
    DECLARE @userName NVARCHAR(100) = SYSTEM_USER;

    INSERT INTO AuditLogInmueble (
        TableName, Operation, PrimaryKeyValue, nro_piso, dpto, sup_Cubierta,
        frente, balcon, idprovincia, idlocalidad, idconsorcio, ModifiedBy, ModifiedDate
    )
    SELECT
        'inmueble' AS TableName,
        'DELETE' AS Operation,
        d.idinmueble AS PrimaryKeyValue,
        CONVERT(NVARCHAR(MAX), d.nro_piso),
        CONVERT(NVARCHAR(MAX), d.dpto),
        CONVERT(NVARCHAR(MAX), d.sup_Cubierta),
        CONVERT(NVARCHAR(MAX), d.frente),
        CONVERT(NVARCHAR(MAX), d.balcon),
        CONVERT(NVARCHAR(MAX), d.idprovincia),
        CONVERT(NVARCHAR(MAX), d.idlocalidad),
        CONVERT(NVARCHAR(MAX), d.idconsorcio),
        @userName AS ModifiedBy,
        GETDATE() AS ModifiedDate
    FROM
        deleted d;
END;
GO

SELECT *
FROM AuditLogInmueble;

/**
idinmueble	nro_piso	dpto	sup_Cubierta	frente	balcon	idprovincia	idlocalidad	idconsorcio
1	0	A	85.00	0	0	1	1	1
*/

SELECT *
FROM dbo.inmueble  i
WHERE i.idinmueble = 1;

update dbo.inmueble
SET sup_Cubierta = 110
WHERE idinmueble = 1;

delete from dbo.inmueble WHERE idinmueble = 1;


/*
idinmueble	nro_piso	dpto	sup_Cubierta	frente	balcon	idprovincia	idlocalidad	idconsorcio
1	0	A	95.00	0	0	1	1	1
*/

CREATE TRIGGER trg_Prevent_Delete_Inmueble
ON dbo.inmueble
INSTEAD OF DELETE
AS
BEGIN
    -- Emitir un mensaje de error personalizado
    RAISERROR ('La eliminación de registros en la tabla "inmueble" no está permitida.', 16, 1);

    -- Evitar que la operación DELETE se ejecute
    ROLLBACK TRANSACTION;
END;
GO


DELETE FROM inmueble WHERE idinmueble = 1;