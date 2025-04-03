DROP DATABASE IF EXISTS sakilacampus;
CREATE DATABASE sakilacampus;
USE sakilacampus;

CREATE TABLE film_text (
film_id SMALLINT PRIMARY KEY,
title VARCHAR(255),
descripcion TEXT
);

CREATE TABLE actor (
id_actor SMALLINT PRIMARY KEY,
nombre VARCHAR(45),
apellidos VARCHAR(45),
ultima_actualizacion TIMESTAMP
);


CREATE TABLE pais(
id_pais SMALLINT PRIMARY KEY,
nombre VARCHAR(50),
ultima_actualizacion TIMESTAMP
);

CREATE TABLE ciudad(
id_ciudad SMALLINT PRIMARY KEY,
nombre VARCHAR(50),
id_pais SMALLINT,
ultima_actualizacion TIMESTAMP,
CONSTRAINT pk_pais FOREIGN KEY  (id_pais)  REFERENCES  pais(id_pais)
);


CREATE TABLE idioma (
id_idioma TINYINT PRIMARY KEY,
nombre CHAR(20),
ultima_actualizacion TIMESTAMP
);

CREATE TABLE categoria (
id_categoria TINYINT PRIMARY KEY, 
nombre VARCHAR(25),
ultima_actualizacion TIMESTAMP
);


CREATE TABLE direccion (
id_direccion SMALLINT PRIMARY KEY,
direccion1 VARCHAR(50),
direccion2 VARCHAR(50),
distrito VARCHAR(20),
id_ciudad SMALLINT,
codigo_postal VARCHAR(10),
telefono VARCHAR (20),
ultima_actualizacion TIMESTAMP,
CONSTRAINT pk_direccion_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

CREATE TABLE pelicula (
id_pelicula SMALLINT PRIMARY KEY,
titulo VARCHAR(255),
descripcion TEXT,
anyo_lanzamiento YEAR,
id_idioma TINYINT,
id_idioma_original TINYINT,
duracion_alquiler TINYINT,
rental_rate DECIMAL(4,2),
duracion SMALLINT,
replacement_cost DECIMAL(5,2),
clasificacion ENUM('G', 'PG', 'PG-13', 'R', 'NC-17'),
caracteristicas_especiales SET('Trailers', 'Commentaires', 'Deleted Scenes', 'Behind the Scenes'),
CONSTRAINT pk_id_idioma FOREIGN KEY(id_idioma) REFERENCES idioma(id_idioma),
CONSTRAINT pk_id_idioma_original FOREIGN KEY(id_idioma_original) REFERENCES idioma(id_idioma) 
);


CREATE TABLE almacen (
id_almacen TINYINT PRIMARY KEY,
id_empleado_jefe TINYINT,
id_direccion SMALLINT,
ultima_actualizacion TIMESTAMP,
CONSTRAINT id_direccion2 FOREIGN KEY(id_direccion) REFERENCES direccion(id_direccion)
);

CREATE TABLE empleado (
id_empleado TINYINT PRIMARY KEY,
nombre VARCHAR(45),
apellidos VARCHAR(45),
id_direccion SMALLINT,
imagen BLOB,
email VARCHAR(45),
id_almacen TINYINT,
activo TINYINT,
username VARCHAR(16),
password  VARCHAR(40),
CONSTRAINT id_direccion3 FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion),
CONSTRAINT id_almacen FOREIGN KEY (id_almacen) REFERENCES almacen(id_almacen)
);

ALTER TABLE almacen ADD CONSTRAINT id_jefe FOREIGN KEY (id_empleado_jefe) REFERENCES empleado(id_empleado);

CREATE TABLE cliente(
id_cliente SMALLINT PRIMARY KEY,
id_almacen TINYINT,
nombre VARCHAR(45),
apellidos VARCHAR(45),
email VARCHAR(50),
id_direccion SMALLINT,
activo TINYINT(1),
fecha_creacion DATETIME,
ultima_actualizacion TIMESTAMP,
CONSTRAINT pk_id_almacen FOREIGN KEY (id_almacen) REFERENCES almacen(id_almacen),
CONSTRAINT pk_direccion4 FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion)
);

CREATE TABLE inventario (
id_inventario mediumint PRIMARY KEY,
id_pelicula SMALLINT,
id_almacen TINYINT,
ultima_actualizacion TIMESTAMP,
CONSTRAINT id_pelicula1 FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
CONSTRAINT id_almacen1 FOREIGN KEY (id_almacen) REFERENCES almacen(id_almacen)
);

CREATE TABLE alquiler (
id_alquiler INT PRIMARY KEY,
fecha_alquiler DATETIME,
id_inventario MEDIUMINT,
id_cliente SMALLINT,
fecha_devolucion DATETIME,
id_empleado TINYINT,
ultima_actualizacion TIMESTAMP,
CONSTRAINT id_inventario1 FOREIGN KEY (id_inventario) REFERENCES inventario(id_inventario),
CONSTRAINT id_cliente1 FOREIGN KEY(id_cliente)  REFERENCES cliente(id_cliente),
CONSTRAINT id_empleado1 FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE pago(
id_pago SMALLINT PRIMARY KEY,
id_cliente SMALLINT,
id_empleado TINYINT,
id_alquiler INT,
total DECIMAL (5,2),
fecha_pago DATETIME, 
ultima_actualizacion TIMESTAMP,
CONSTRAINT id_cliente2 FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente),
CONSTRAINT id_empleado2 FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
CONSTRAINT id_alquiler1 FOREIGN KEY(id_alquiler) REFERENCES alquiler(id_alquiler)
);

CREATE TABLE pelicula_actor (
id_actor SMALLINT,
id_pelicula SMALLINT,
ultima_actualizacion TIMESTAMP,
PRIMARY KEY(id_actor,id_pelicula),
CONSTRAINT pk_id_actor FOREIGN KEY (id_actor) REFERENCES actor(id_actor),
CONSTRAINT pk_id_pelicula FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
);

CREATE TABLE pelicula_categoria(
id_pelicula SMALLINT,
id_categoria TINYINT,
PRIMARY KEY(id_pelicula, id_categoria),
CONSTRAINT pk_id_pelicula2 FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
CONSTRAINT pk_id_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);


