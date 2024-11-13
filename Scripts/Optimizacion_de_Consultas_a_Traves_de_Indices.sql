-- ****************************************
-- 1.	Prueba sin índices
-- ****************************************

-- Activar estadísticas
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- Realizamos una búsqueda en un rango de fechas desde el 01-01-2024 al 31-12-2026
SELECT *
FROM viaje
WHERE fecha BETWEEN 20240101 AND 20261231;

-- Desactivar estadísticas
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Resultado: CPU time = 4292 ms,  elapsed time = 5688 ms.

-- ****************************************
-- 2.	Índice agrupado en columna de fecha
-- ****************************************

-- Eliminar el índice de clave primaria que la tabla ya tenía
ALTER TABLE viaje DROP CONSTRAINT PK_viaje_nueva;

-- Crear el índice agrupado en la columna fecha
CREATE CLUSTERED INDEX idx_fecha ON viaje(fecha);

-- Repetir la búsqueda por periodo
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT *
FROM viaje
WHERE fecha BETWEEN 20240101 AND 20261231;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Resultado: CPU time = 893 ms,  elapsed time = 4697 ms.

-- ****************************************************
-- 3.	Índice agrupado en fecha e inclusión de columna
-- ****************************************************

-- Borrar el índice creado en fecha
DROP INDEX idx_fecha ON viaje;

-- Crear índice agrupado en fecha que incluya otras columnas necesarias en la consulta
CREATE CLUSTERED INDEX idx_fecha_incluye ON viaje(fecha, duracion, distancia, peso_transportado);

-- Ejecutar la consulta en el rango de fechas
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT fecha, duracion, distancia, peso_transportado
FROM viaje
WHERE fecha BETWEEN 20240101 AND 20261231;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Resultado: CPU time = 530 ms,  elapsed time = 737 ms.