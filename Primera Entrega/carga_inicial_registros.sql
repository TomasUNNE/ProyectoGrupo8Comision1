USE caso_camiones;

INSERT INTO marca (id_marca, descripcio) VALUES
(1, 'Mercedes-Benz'),
(2, 'Volvo'),
(3, 'Scania'),
(4, 'MAN'),
(5, 'Freightliner');

INSERT INTO modelo (id_modelo, descripcion, id_marca) VALUES
(1, 'Actros', 1),  -- Mercedes-Benz
(2, 'Atego', 1),   -- Mercedes-Benz
(3, 'FH', 2),      -- Volvo
(4, 'FM', 2),      -- Volvo
(5, 'R 450', 3),   -- Scania
(6, 'G 410', 3),   -- Scania
(7, 'TGX', 4),     -- MAN
(8, 'TGS', 4),     -- MAN
(9, 'Cascadia', 5), -- Freightliner
(10, 'M2', 5);     -- Freightliner

INSERT INTO pais (id_pais, nombre) VALUES
(1, 'Argentina'),
(2, 'Brasil'),
(3, 'Chile');

INSERT INTO categoria_licencia (id_categoria_lic, nombre) VALUES
(1, 'C1'),  -- Licencia para camiones ligeros
(2, 'C2'),  -- Licencia para camiones pesados
(3, 'C3'),  -- Licencia para transporte de carga
(4, 'C4'),  -- Licencia para vehículos de carga especial
(5, 'D1');  -- Licencia para vehículos de transporte de pasajeros con remolque

-- Provincias 
INSERT INTO provincia (id_provincia, nombre, id_pais) VALUES
(1, 'Buenos Aires', 1),
(2, 'Córdoba', 1),
(3, 'Santa Fe', 1),
(4, 'São Paulo', 2),
(5, 'Rio de Janeiro', 2),
(6, 'Minas Gerais', 2),
(7, 'Santiago', 3),
(8, 'Valparaíso', 3),
(9, 'Biobío', 3);

INSERT INTO ciudad (id_ciudad, nombre, id_provincia) VALUES
(1, 'Buenos Aires', 1),
(2, 'La Plata', 1),
(3, 'Córdoba', 2),
(4, 'Rosario', 3),
(5, 'Santa Fe', 3),
(6, 'São Paulo', 4),
(7, 'Rio de Janeiro', 5),
(8, 'Belo Horizonte', 6),
(9, 'Salvador', 4),
(10, 'Brasilia', 5),
(11, 'Santiago', 7),
(12, 'Valparaíso', 8),
(13, 'Concepción', 9),
(14, 'La Serena', 7),
(15, 'Antofagasta', 9);

-- inserta 50 CAMIONES por cada marca (250 en total)
DECLARE @marca INT;
DECLARE @modelo INT;
DECLARE @i INT;
DECLARE @nuevoIdCamion INT;

-- Iterar sobre cada marca (1 a 5)
SET @marca = 1;

WHILE @marca <= 5
BEGIN
    SET @i = 1; -- Reiniciar el contador para cada marca

    WHILE @i <= 50
    BEGIN
        -- Asignar modelo basado en la marca
        IF @marca = 1 SET @modelo = 1 + (RAND() * 1);  -- Modelos 1 y 2
        IF @marca = 2 SET @modelo = 3 + (RAND() * 1);  -- Modelos 3 y 4
        IF @marca = 3 SET @modelo = 5 + (RAND() * 1);  -- Modelos 5 y 6
        IF @marca = 4 SET @modelo = 7 + (RAND() * 1);  -- Modelos 7 y 8
        IF @marca = 5 SET @modelo = 9 + (RAND() * 1);  -- Modelos 9 y 10

        -- Calcular el nuevo id_camion
        SET @nuevoIdCamion = (@marca - 1) * 50 + @i;

        INSERT INTO camion (id_camion, patente, capacidad_max, id_modelo, id_marca)
        VALUES (
            @nuevoIdCamion,  -- ID de camión
            CONCAT('PAT', RIGHT('000' + CAST(@nuevoIdCamion AS VARCHAR(3)), 3)),  -- Generar patente única
            CAST((RAND() * (30000 - 10000) + 10000) AS INT),  -- Capacidad aleatoria entre 10000 y 30000
            @modelo,  -- ID de modelo específico
            @marca    -- ID de marca
        );

        SET @i = @i + 1;
    END

    SET @marca = @marca + 1; -- Pasar a la siguiente marca
END

-- asignar 3 PRODUCTOS a cada amión
DECLARE @camionId INT;
DECLARE @productoId INT;
DECLARE @i INT;

-- Obtener el número total de camiones
DECLARE @totalCamiones INT;
SELECT @totalCamiones = COUNT(*) FROM camion;

SET @camionId = 1;

WHILE @camionId <= @totalCamiones
BEGIN
    SET @i = 1; -- Reiniciar el contador para productos

    WHILE @i <= 3
    BEGIN
        -- Asignar producto secuencial
        SET @productoId = (@camionId - 1) * 3 + @i;  -- Producto ID secuencial

        INSERT INTO camion_producto (id_producto, id_camion)
        VALUES (
            @productoId,  -- ID del producto
            @camionId     -- ID del camión
        );

        SET @i = @i + 1;
    END

    SET @camionId = @camionId + 1; -- Pasar al siguiente camión
END


--insertar SUCURSALES
DECLARE @ciudadId INT;
DECLARE @domicilio VARCHAR(200);
DECLARE @i INT = 1;

-- Obtener el número total de ciudades
DECLARE @totalCiudades INT;
SELECT @totalCiudades = COUNT(*) FROM ciudad;

-- Iterar sobre cada ciudad
WHILE @i <= @totalCiudades
BEGIN
    -- Obtener el ID de la ciudad actual
    SELECT @ciudadId = id_ciudad FROM ciudad WHERE id_ciudad = @i;

    -- Generar un domicilio ficticio para la sucursal
    SET @domicilio = CONCAT('Domicilio de Sucursal ', @ciudadId);

    -- Insertar la sucursal
    INSERT INTO sucursal (id_sucursal, domicilio, id_ciudad)
    VALUES (
        @i,  -- ID de sucursal secuencial
        @domicilio,  -- Domicilio generado
        @ciudadId    -- ID de la ciudad correspondiente
    );

    SET @i = @i + 1; -- Pasar a la siguiente ciudad
END

--distribuye equitativamente los 250 camiones
DECLARE @sucursalId INT;
DECLARE @camionesPorSucursal INT;
DECLARE @remanente INT;
DECLARE @camionId INT;

SET @sucursalId = 1;
SET @camionesPorSucursal = 16; -- Camiones asignados por sucursal
SET @remanente = 10; -- Remanente para distribuir

-- Iterar sobre cada sucursal
WHILE @sucursalId <= 15
BEGIN
    DECLARE @camionesAsignados INT = 0;

    -- Asignar camiones a la sucursal
    WHILE @camionesAsignados < @camionesPorSucursal
    BEGIN
        -- Calcular el ID del camión basado en la cantidad de sucursales y el camión que estamos asignando
        SET @camionId = ((@sucursalId - 1) * @camionesPorSucursal) + @camionesAsignados + 1;

        -- Insertar el camión en la sucursal
        INSERT INTO camion_sucursal (id_camion, id_sucursal)
        VALUES (
            @camionId,    -- ID del camión
            @sucursalId   -- ID de la sucursal
        );

        SET @camionesAsignados = @camionesAsignados + 1;
    END

    -- Distribuir el remanente (1 camión adicional para las primeras 10 sucursales)
    IF @sucursalId <= @remanente
    BEGIN
        -- Calcular el ID del camión adicional
        SET @camionId = (15 * @camionesPorSucursal) + @sucursalId; -- Camiones adicionales para las primeras 10 sucursales

        INSERT INTO camion_sucursal (id_camion, id_sucursal)
        VALUES (
            @camionId,    -- ID del camión
            @sucursalId   -- ID de la sucursal
        );
    END

    SET @sucursalId = @sucursalId + 1; -- Pasar a la siguiente sucursal
END

--inserta 250 choferes y se asigna a cada camion
DECLARE @i INT = 1;
DECLARE @nombre VARCHAR(100);
DECLARE @apellido VARCHAR(100);
DECLARE @dni INT;
DECLARE @sucursalId INT;
DECLARE @categoriaLicenciaId INT;
DECLARE @camionId INT;
DECLARE @totalCamiones INT;

-- Obtener el total de camiones
SELECT @totalCamiones = COUNT(*) FROM camion;

-- Suponiendo que ya tienes algunas sucursales y categorías de licencia
DECLARE @totalSucursales INT;
SELECT @totalSucursales = COUNT(*) FROM sucursal;

DECLARE @totalCategoriasLicencia INT;
SELECT @totalCategoriasLicencia = COUNT(*) FROM categoria_licencia;

-- Insertar 250 choferes
WHILE @i <= 250
BEGIN
    -- Generar nombre y apellido aleatorios
    SET @nombre = CONCAT('Nombre', @i);
    SET @apellido = CONCAT('Apellido', @i);
    
    -- Generar DNI aleatorio (aquí suponemos que son números de 8 dígitos)
    SET @dni = 10000000 + @i;  -- Cambia esto si necesitas un rango específico

    -- Seleccionar una sucursal y categoría de licencia al azar
    SET @sucursalId = (RAND() * @totalSucursales) + 1;
    SET @categoriaLicenciaId = (RAND() * @totalCategoriasLicencia) + 1;

    -- Insertar el chofer
    INSERT INTO chofer (id_chofer, nombre, apellido, dni, id_sucursal, id_categoria_lic)
    VALUES (
        @i,  -- ID secuencial
        @nombre,
        @apellido,
        @dni,
        @sucursalId,
        @categoriaLicenciaId
    );

    SET @i = @i + 1; -- Incrementar el contador
END

-- Asignar los choferes a cada camión
DECLARE @j INT = 1;

WHILE @j <= @totalCamiones
BEGIN
    -- Asumimos que el chofer correspondiente tiene un ID secuencial
    SET @camionId = @j;

    -- Insertar en la tabla camion_chofer
    INSERT INTO camion_chofer (fecha_asignacion, id_camion, id_chofer)
    VALUES (
        GETDATE(),   -- Fecha de asignación actual
        @camionId,   -- ID del camión
        @j            -- ID del chofer (1 a 250)
    );

    SET @j = @j + 1; -- Pasar al siguiente camión
END

--inserta 10000 viajes
DECLARE @i INT = 1;
DECLARE @fecha INT;
DECLARE @duracion INT;
DECLARE @distancia INT;
DECLARE @peso_transportado INT;
DECLARE @id_producto INT;
DECLARE @id_camion INT;
DECLARE @id_sucursal_origen INT;
DECLARE @id_sucursal_destino INT;
DECLARE @id_chofer INT;
DECLARE @totalCamiones INT;
DECLARE @totalProductos INT;
DECLARE @totalSucursales INT;
DECLARE @totalChoferes INT;

-- Obtener totales de los registros necesarios
SELECT @totalCamiones = COUNT(*) FROM camion;
SELECT @totalProductos = COUNT(*) FROM camion_producto; -- Total de productos
SELECT @totalSucursales = COUNT(*) FROM sucursal;
SELECT @totalChoferes = COUNT(*) FROM chofer; -- Total de choferes

WHILE @i <= 1000000
BEGIN
    -- Generar datos aleatorios
    SET @fecha = CONVERT(INT, FORMAT(DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365), GETDATE()), 'yyyyMMdd')); -- Fecha aleatoria en formato YYYYMMDD
    SET @duracion = ABS(CHECKSUM(NEWID()) % 120) + 1; -- Duración entre 1 y 120 minutos
    SET @distancia = ABS(CHECKSUM(NEWID()) % 1000) + 1; -- Distancia entre 1 y 1000 km
    SET @peso_transportado = ABS(CHECKSUM(NEWID()) % 20000) + 1; -- Peso entre 1 y 20,000 kg

    -- Seleccionar un camión al azar
    SET @id_camion = (ABS(CHECKSUM(NEWID()) % @totalCamiones) + 1);

    -- Generar el id_producto basado en el id_camion
    SET @id_producto = (@id_camion - 1) * 3 + (ABS(CHECKSUM(NEWID()) % 3) + 1);

    -- Asegurarse de que el producto exista para el camión seleccionado
    IF EXISTS (SELECT 1 FROM camion_producto WHERE id_producto = @id_producto AND id_camion = @id_camion)
    BEGIN
        -- Seleccionar sucursales
        SET @id_sucursal_origen = (ABS(CHECKSUM(NEWID()) % @totalSucursales) + 1);
        SET @id_sucursal_destino = (ABS(CHECKSUM(NEWID()) % @totalSucursales) + 1);

        -- Asegurarse de que la sucursal de origen y destino sean diferentes
        WHILE @id_sucursal_origen = @id_sucursal_destino
        BEGIN
            SET @id_sucursal_destino = (ABS(CHECKSUM(NEWID()) % @totalSucursales) + 1);
        END

        -- Asumimos que el chofer correspondiente tiene un ID secuencial y es válido
        SET @id_chofer = @id_camion;  -- El chofer del camión correspondiente

        -- Insertar en la tabla viaje
        INSERT INTO viaje (fecha, id_viaje, duracion, distancia, peso_transportado, id_producto, id_camion, id_sucursal_origen, id_sucursal_destino, id_chofer)
        VALUES (
            @fecha,
            @i,
            @duracion,
            @distancia,
            @peso_transportado,
            @id_producto,
            @id_camion,
            @id_sucursal_origen,
            @id_sucursal_destino,
            @id_chofer
        );

        SET @i = @i + 1; -- Pasar al siguiente viaje
    END
END