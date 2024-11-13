-- ****************************************
-- 1.	Prueba sin �ndices
-- ****************************************

-- Activar estad�sticas
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- Realizamos una b�squeda en un rango de fechas desde el 01-01-2024 al 31-12-2026
SELECT *
FROM viaje
WHERE fecha BETWEEN 20240101 AND 20261231;

-- Desactivar estad�sticas
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Resultado: CPU time = 4292 ms,  elapsed time = 5688 ms.

-- ****************************************
-- 2.	�ndice agrupado en columna de fecha
-- ****************************************

-- Eliminar el �ndice de clave primaria que la tabla ya ten�a
ALTER TABLE viaje DROP CONSTRAINT PK_viaje_nueva;

-- Crear el �ndice agrupado en la columna fecha
CREATE CLUSTERED INDEX idx_fecha ON viaje(fecha);

-- Repetir la b�squeda por periodo
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT *
FROM viaje
WHERE fecha BETWEEN 20240101 AND 20261231;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Resultado: CPU time = 893 ms,  elapsed time = 4697 ms.

-- ****************************************************
-- 3.	�ndice agrupado en fecha e inclusi�n de columna
-- ****************************************************

-- Borrar el �ndice creado en fecha
DROP INDEX idx_fecha ON viaje;

-- Crear �ndice agrupado en fecha que incluya otras columnas necesarias en la consulta
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