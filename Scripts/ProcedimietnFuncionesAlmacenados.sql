use caso_camiones;
GO
-- Crear la funci�n almacenada
-- Crear la funci�n almacenada
CREATE FUNCTION dbo.calcular_kilometros_recorridos
(
    @id_camion INT,
    @fecha_inicio DATE,
    @fecha_fin DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @total_km INT;
    
    -- Convertir las fechas a formato INT (YYYYMMDD)
    DECLARE @fecha_inicio_int INT = CONVERT(INT, FORMAT(@fecha_inicio, 'yyyyMMdd'));
    DECLARE @fecha_fin_int INT = CONVERT(INT, FORMAT(@fecha_fin, 'yyyyMMdd'));
    
    -- Calcular la suma de la distancia
    SELECT @total_km = ISNULL(SUM(distancia), 0)
    FROM viaje
    WHERE id_camion = @id_camion
      AND fecha BETWEEN @fecha_inicio_int AND @fecha_fin_int;
    
    RETURN @total_km;
END;
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE dbo.registrar_viaje
(
    @fecha DATE,
    @duracion INT,
    @distancia INT,
    @peso_transportado INT,
    @id_producto INT,
    @id_camion INT,
    @id_sucursal_origen INT,
    @id_sucursal_destino INT,
    @id_chofer INT
)
AS
BEGIN
    -- Verificar que la sucursal de origen y destino no sean iguales
    IF @id_sucursal_origen = @id_sucursal_destino
    BEGIN
        RAISERROR('La sucursal de origen y destino no pueden ser las mismas.', 16, 1);
        RETURN;
    END

    -- Insertar el viaje con generaci�n de id_viaje autom�tico
    INSERT INTO viaje (fecha, id_viaje, duracion, distancia, peso_transportado, id_producto, id_camion, id_sucursal_origen, id_sucursal_destino, id_chofer)
    VALUES (
        @fecha,
        (SELECT ISNULL(MAX(id_viaje) + 1, 1) FROM viaje),  -- Generaci�n del id_viaje
        @duracion,
        @distancia,
        @peso_transportado,
        @id_producto,
        @id_camion,
        @id_sucursal_origen,
        @id_sucursal_destino,
        @id_chofer
    );
END;
GO
