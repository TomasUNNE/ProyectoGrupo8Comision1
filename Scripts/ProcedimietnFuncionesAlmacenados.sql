use caso_camiones;
GO

-- Crear la función almacenada
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

    -- Insertar el viaje con generación de id_viaje automático
    INSERT INTO viaje (fecha, id_viaje, duracion, distancia, peso_transportado, id_producto, id_camion, id_sucursal_origen, id_sucursal_destino, id_chofer)
    VALUES (
        @fecha,
        (SELECT ISNULL(MAX(id_viaje) + 1, 1) FROM viaje),  -- Generación del id_viaje
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

-----ejemplos de ejecución

--funcion
DECLARE @kilometros INT;
SET @kilometros = dbo.calcular_kilometros_recorridos(1, '2024-01-01', '2024-12-31');
SELECT @kilometros AS KilometrosRecorridos;

--procedimiento
EXEC dbo.registrar_viaje
    @fecha = '2024-11-12',
    @duracion = 120,
    @distancia = 300,
    @peso_transportado = 5000,
    @id_producto = 1,
    @id_camion = 1,
    @id_sucursal_origen = 2,
    @id_sucursal_destino = 3,
    @id_chofer = 1;
