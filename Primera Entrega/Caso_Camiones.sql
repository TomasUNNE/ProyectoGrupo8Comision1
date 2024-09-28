
-- Crear la base de datos
CREATE DATABASE caso_camiones;

-- Ubicarse en la BD a trabajar
USE caso_camiones;


-- Tabla marca
CREATE TABLE marca
(
  id_marca INT NOT NULL,
  descripcio VARCHAR(200) NOT NULL,
  CONSTRAINT PK_marca PRIMARY KEY (id_marca)
);

-- Tabla modelo
CREATE TABLE modelo
(
  id_modelo INT NOT NULL,
  descripcion VARCHAR(100) NOT NULL,
  id_marca INT NOT NULL,
  CONSTRAINT PK_modelo PRIMARY KEY (id_modelo, id_marca),
  CONSTRAINT FK_modelo_marca FOREIGN KEY (id_marca) REFERENCES marca(id_marca)
);

-- Tabla pais
CREATE TABLE pais
(
  id_pais INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  CONSTRAINT PK_pais PRIMARY KEY (id_pais)
);

-- Tabla categoria_licencia
CREATE TABLE categoria_licencia
(
  id_categoria_lic INT NOT NULL,
  nombre VARCHAR(10) NOT NULL,
  CONSTRAINT PK_categoria_licencia PRIMARY KEY (id_categoria_lic)
);

-- Tabla camion
CREATE TABLE camion
(
  id_camion INT NOT NULL,
  patente VARCHAR(10) NOT NULL,
  capacidad_max INT NOT NULL,
  id_modelo INT NOT NULL,
  id_marca INT NOT NULL,
  CONSTRAINT PK_camion PRIMARY KEY (id_camion),
  CONSTRAINT FK_camion_modelo FOREIGN KEY (id_modelo, id_marca) REFERENCES modelo(id_modelo, id_marca)
);

-- Tabla provincia
CREATE TABLE provincia
(
  id_provincia INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  id_pais INT NOT NULL,
  CONSTRAINT PK_provincia PRIMARY KEY (id_provincia),
  CONSTRAINT FK_provincia_pais FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

-- Tabla camion_producto
CREATE TABLE camion_producto
(
  id_producto INT NOT NULL,
  id_camion INT NOT NULL,
  CONSTRAINT PK_camion_producto PRIMARY KEY (id_producto, id_camion),
  CONSTRAINT FK_camion_producto_camion FOREIGN KEY (id_camion) REFERENCES camion(id_camion)
);

-- Tabla ciudad
CREATE TABLE ciudad
(
  id_ciudad INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  id_provincia INT NOT NULL,
  CONSTRAINT PK_ciudad PRIMARY KEY (id_ciudad),
  CONSTRAINT FK_ciudad_provincia FOREIGN KEY (id_provincia) REFERENCES provincia(id_provincia)
);

-- Tabla sucursal
CREATE TABLE sucursal
(
  id_sucursal INT NOT NULL,
  domicilio VARCHAR(200) NOT NULL,
  id_ciudad INT NOT NULL,
  CONSTRAINT PK_sucursal PRIMARY KEY (id_sucursal),
  CONSTRAINT FK_sucursal_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

-- Tabla camion_sucursal
CREATE TABLE camion_sucursal
(
  id_camion INT NOT NULL,
  id_sucursal INT NOT NULL,
  CONSTRAINT PK_camion_sucursal PRIMARY KEY (id_camion, id_sucursal),
  CONSTRAINT FK_camion_sucursal_camion FOREIGN KEY (id_camion) REFERENCES camion(id_camion),
  CONSTRAINT FK_camion_sucursal_sucursal FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
);

-- Tabla chofer
CREATE TABLE chofer
(
  id_chofer INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  dni INT NOT NULL,
  id_sucursal INT NOT NULL,
  id_categoria_lic INT NOT NULL,
  CONSTRAINT PK_chofer PRIMARY KEY (id_chofer),
  CONSTRAINT FK_chofer_sucursal FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal),
  CONSTRAINT FK_chofer_categoria_licencia FOREIGN KEY (id_categoria_lic) REFERENCES categoria_licencia(id_categoria_lic),
  CONSTRAINT UQ_chofer_dni UNIQUE (dni)
);

-- Tabla camion_chofer
CREATE TABLE camion_chofer
(
  fecha_asignacion DATE NOT NULL,
  id_camion INT NOT NULL,
  id_chofer INT NOT NULL,
  CONSTRAINT PK_camion_chofer PRIMARY KEY (id_camion, id_chofer),
  CONSTRAINT FK_camion_chofer_camion FOREIGN KEY (id_camion) REFERENCES camion(id_camion),
  CONSTRAINT FK_camion_chofer_chofer FOREIGN KEY (id_chofer) REFERENCES chofer(id_chofer),
  CONSTRAINT DF_camion_chofer_fecha_asignacion DEFAULT GETDATE() FOR fecha_asignacion
);

-- Tabla viaje

CREATE TABLE viaje
(
  fecha INT NOT NULL,
  id_viaje INT NOT NULL,
  duracion INT NOT NULL,
  distancia INT NOT NULL,
  peso_transportado INT NOT NULL,
  id_producto INT NOT NULL,
  id_camion INT NOT NULL,
  id_sucursal_origen INT NOT NULL,
  id_sucursal_destino INT NOT NULL,
  id_chofer INT NOT NULL,
  CONSTRAINT PK_viaje_nueva PRIMARY KEY (id_viaje),
  CONSTRAINT FK_viaje_nueva_camion_producto FOREIGN KEY (id_producto, id_camion) REFERENCES camion_producto(id_producto, id_camion),
  CONSTRAINT FK_viaje_nuevasucursal_origen FOREIGN KEY (id_sucursal_origen) REFERENCES sucursal(id_sucursal),
  CONSTRAINT FK_viaje_nueva_sucursal_destino FOREIGN KEY (id_sucursal_destino) REFERENCES sucursal(id_sucursal),
  CONSTRAINT FK_viaje_nueva_camion_chofer FOREIGN KEY (id_camion, id_chofer) REFERENCES camion_chofer(id_camion, id_chofer),
  CONSTRAINT CK_viaje_sucursal_origen_destino CHECK (id_sucursal_origen <> id_sucursal_destino)
);






