
----- Implementacion de Manejo de Permisos a nivel usuarios de bases de datos



--Se crean los usuarios a nivel servidor, sin roles asignados.

create login manuel with password='Password123';
create login juan with password='Password123';



--Se crea los usuarios con los login anteriores para una base de datos ESPECIFICA

USE caso_camiones; ----- <-Verificar en que base de datos crear la instancia de estos usuarios.
GO

CREATE USER manuel FOR LOGIN manuel;
CREATE USER juan FOR LOGIN juan;



--- Se asignan distintos permisos a los usuarios creados para esta base de datos (caso_camiones)

-- Por ejemplo, manuel solo puede leer las tablas, es decir esta restringido a usar solo la sentencia SELECT
EXEC sp_addrolemember 'db_datareader', 'manuel';
go


--Probamos si los permisos funcionan. 
EXECUTE AS USER = 'manuel'; --EXECUTE permite presentarse como el usuario mencionado, para ello, asegurarse de estar en una estancia de base de datso.

SELECT * FROM pais --Debe ver las tablas.

INSERT INTO pais(id_pais, nombre) VALUES (4, 'Venezuela')  ---No deberia poder insertar.

REVERT  ---Regresas al estado inicial, sin el user manuel activo.




--- Para el usuario Juan, se le otorga permisos de escritura, es decir, puedo usar unicamente sentencias INSERT 
EXEC sp_addrolemember 'db_datawriter', 'juan';


--- Probamos...
EXECUTE AS USER = 'juan';
SELECT * FROM pais --No deberia poder ver las tablas.
INSERT INTO pais(id_pais, nombre) VALUES (4, 'Venezuela')  ---Deberia poder insertar.

REVERT --- Recuerda salir del usuario activo.


-- Ahora tambien le otorgamos permisos de administrador a juan.
EXEC sp_addrolemember 'db_ddladmin','juan';
go


---- Creamos una funcion almacenada.
create procedure insertarCamion
@id_camion int,
@patente varchar(10),
@capacidad_max int,
@id_modelo int,
@id_marca int
as
begin
	insert into camion(id_camion,patente,capacidad_max,id_modelo,id_marca)
	values (@id_camion,@patente,@capacidad_max,@id_modelo,@id_marca);
end


grant execute on insertarCamion to manuel ---Le damos permiso al usuario de lectura de usar el procedimiento creado.



--- Prueba a insertar con AMBOS usuarios. 
INSERT into camion(id_camion,patente,capacidad_max,id_modelo,id_marca) values (99998, 'RU89VB', '80', '2', '1')


--- Atajo..
EXECUTE AS USER = 'manuel'; --- No deberia poder
REVERT

EXECUTE AS USER = 'juan'; --- Deberia poder
REVERT
---


---Ahora prueba la funcion almacenada con manuel activo, deberia insertar.
exec insertarCamion '99999','AGH895','100','1','1'

