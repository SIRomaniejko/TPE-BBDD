-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2019-06-01 23:48:25.308

-- tables
-- Table: GR25_ALQUILER
CREATE TABLE GR25_ALQUILER (
    id_alquiler int  NOT NULL,
    id_cliente int  NOT NULL,
    fecha_desde date  NOT NULL,
    fecha_hasta date  NULL,
    importe_dia decimal(10,2)  NOT NULL,
    CONSTRAINT PK_GR25_ALQUILER PRIMARY KEY (id_alquiler)
);

-- Table: GR25_ALQUILER_POSICIONES
CREATE TABLE GR25_ALQUILER_POSICIONES (
    id_alquiler int  NOT NULL,
    nro_posicion int  NOT NULL,
    nro_estanteria int  NOT NULL,
    nro_fila int  NOT NULL,
    estado boolean  NOT NULL,
    CONSTRAINT PK_GR25_ALQUILER_POSICIONES PRIMARY KEY (id_alquiler,nro_posicion,nro_estanteria,nro_fila)
);

-- Table: GR25_CLIENTE
CREATE TABLE GR25_CLIENTE (
    cuit_cuil int  NOT NULL,
    apellido varchar(60)  NOT NULL,
    nombre varchar(40)  NOT NULL,
    fecha_alta date  NOT NULL,
    CONSTRAINT PK_GR25_CLIENTE PRIMARY KEY (cuit_cuil)
);

-- Table: GR25_ESTANTERIA
CREATE TABLE GR25_ESTANTERIA (
    nro_estanteria int  NOT NULL,
    nombre_estanteria varchar(80)  NOT NULL,
    CONSTRAINT PK_GR25_ESTANTERIA PRIMARY KEY (nro_estanteria)
);

-- Table: GR25_FILA
CREATE TABLE GR25_FILA (
    nro_estanteria int  NOT NULL,
    nro_fila int  NOT NULL,
    nombre_fila varchar(80)  NOT NULL,
    peso_max_kg decimal(10,2)  NOT NULL,
    CONSTRAINT PK_GR25_FILA PRIMARY KEY (nro_estanteria,nro_fila)
);

-- Table: GR25_MOVIMIENTO
CREATE TABLE GR25_MOVIMIENTO (
    id_movimiento int  NOT NULL,
    fecha timestamp  NOT NULL,
    responsable varchar(80)  NOT NULL,
    tipo char(1)  NOT NULL,
    CONSTRAINT PK_GR25_MOVIMIENTO PRIMARY KEY (id_movimiento)
);

-- Table: GR25_MOV_ENTRADA
CREATE TABLE GR25_MOV_ENTRADA (
    id_movimiento int  NOT NULL,
    transporte varchar(80)  NOT NULL,
    guia varchar(80)  NOT NULL,
    cod_pallet varchar(20)  NOT NULL,
    id_alquiler int  NOT NULL,
    nro_posicion int  NOT NULL,
    nro_estanteria int  NOT NULL,
    nro_fila int  NOT NULL,
    CONSTRAINT PK_GR25_MOV_ENTRADA PRIMARY KEY (id_movimiento)
);

-- Table: GR25_MOV_INTERNO
CREATE TABLE GR25_MOV_INTERNO (
    id_movimiento int  NOT NULL,
    razon varchar(200)  NULL,
    nro_posicion int  NOT NULL,
    nro_estanteria int  NOT NULL,
    nro_fila int  NOT NULL,
    id_movimiento_anterior int  NOT NULL,
    CONSTRAINT PK_GR25_MOV_INTERNO PRIMARY KEY (id_movimiento)
);

-- Table: GR25_MOV_SALIDA
CREATE TABLE GR25_MOV_SALIDA (
    id_movimiento int  NOT NULL,
    transporte varchar(80)  NOT NULL,
    guia varchar(80)  NOT NULL,
    id_movimiento_entrada int  NOT NULL,
    CONSTRAINT PK_GR25_MOV_SALIDA PRIMARY KEY (id_movimiento)
);

-- Table: GR25_PALLET
CREATE TABLE GR25_PALLET (
    cod_pallet varchar(20)  NOT NULL,
    descripcion varchar(200)  NOT NULL,
    peso decimal(10,2)  NOT NULL,
    CONSTRAINT PK_GR25_PALLET PRIMARY KEY (cod_pallet)
);

-- Table: GR25_POSICION
CREATE TABLE GR25_POSICION (
    nro_posicion int  NOT NULL,
    nro_estanteria int  NOT NULL,
    nro_fila int  NOT NULL,
    tipo varchar(40)  NOT NULL,
    CONSTRAINT UQ_GR25_POSICION_nro_posicion UNIQUE (nro_posicion) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT PK_GR25_POSICION PRIMARY KEY (nro_posicion,nro_estanteria,nro_fila)
);

-- foreign keys
-- Reference: FK_GR25_ALQUILER_CLIENTE (table: GR25_ALQUILER)
ALTER TABLE GR25_ALQUILER ADD CONSTRAINT FK_GR25_ALQUILER_CLIENTE
    FOREIGN KEY (id_cliente)
    REFERENCES GR25_CLIENTE (cuit_cuil)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_GR25_ALQUILER_POSICIONES_ALQUILER (table: GR25_ALQUILER_POSICIONES)
ALTER TABLE GR25_ALQUILER_POSICIONES ADD CONSTRAINT FK_GR25_ALQUILER_POSICIONES_ALQUILER
    FOREIGN KEY (id_alquiler)
    REFERENCES GR25_ALQUILER (id_alquiler)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_GR25_ALQUILER_POSICIONES_POSICION (table: GR25_ALQUILER_POSICIONES)
ALTER TABLE GR25_ALQUILER_POSICIONES ADD CONSTRAINT FK_GR25_ALQUILER_POSICIONES_POSICION
    FOREIGN KEY (nro_posicion, nro_estanteria, nro_fila)
    REFERENCES GR25_POSICION (nro_posicion, nro_estanteria, nro_fila)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_GR25_FILA_ESTANTERIA (table: GR25_FILA)
ALTER TABLE GR25_FILA ADD CONSTRAINT FK_GR25_FILA_ESTANTERIA
    FOREIGN KEY (nro_estanteria)
    REFERENCES GR25_ESTANTERIA (nro_estanteria)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_GR25_MOV_ENTRADA_ALQUILER_POSICIONES (table: GR25_MOV_ENTRADA)
ALTER TABLE GR25_MOV_ENTRADA ADD CONSTRAINT FK_GR25_MOV_ENTRADA_ALQUILER_POSICIONES
    FOREIGN KEY (id_alquiler, nro_posicion, nro_estanteria, nro_fila)
    REFERENCES GR25_ALQUILER_POSICIONES (id_alquiler, nro_posicion, nro_estanteria, nro_fila)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_GR25_MOV_ENTRADA_MOVIMIENTO (table: GR25_MOV_ENTRADA)
ALTER TABLE GR25_MOV_ENTRADA ADD CONSTRAINT FK_GR25_MOV_ENTRADA_MOVIMIENTO
    FOREIGN KEY (id_movimiento)
    REFERENCES GR25_MOVIMIENTO (id_movimiento)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_GR25_MOV_ENTRADA_PALLET (table: GR25_MOV_ENTRADA)
ALTER TABLE GR25_MOV_ENTRADA ADD CONSTRAINT FK_GR25_MOV_ENTRADA_PALLET
    FOREIGN KEY (cod_pallet)
    REFERENCES GR25_PALLET (cod_pallet)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_GR25_MOV_INTERNO_MOVIMIENTO (table: GR25_MOV_INTERNO)
ALTER TABLE GR25_MOV_INTERNO ADD CONSTRAINT FK_GR25_MOV_INTERNO_MOVIMIENTO
    FOREIGN KEY (id_movimiento)
    REFERENCES GR25_MOVIMIENTO (id_movimiento)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_GR25_MOV_INTERNO_POSICION (table: GR25_MOV_INTERNO)
ALTER TABLE GR25_MOV_INTERNO ADD CONSTRAINT FK_GR25_MOV_INTERNO_POSICION
    FOREIGN KEY (nro_posicion, nro_estanteria, nro_fila)
    REFERENCES GR25_POSICION (nro_posicion, nro_estanteria, nro_fila)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_GR25_MOV_SALIDA_MOVIMIENTO (table: GR25_MOV_SALIDA)
ALTER TABLE GR25_MOV_SALIDA ADD CONSTRAINT FK_GR25_MOV_SALIDA_MOVIMIENTO
    FOREIGN KEY (id_movimiento)
    REFERENCES GR25_MOVIMIENTO (id_movimiento)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_GR25_POSICION_FILA (table: GR25_POSICION)
ALTER TABLE GR25_POSICION ADD CONSTRAINT FK_GR25_POSICION_FILA
    FOREIGN KEY (nro_estanteria, nro_fila)
    REFERENCES GR25_FILA (nro_estanteria, nro_fila)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: GR25_MOV_INTERNO_MOVIMIENTO (table: GR25_MOV_INTERNO)
ALTER TABLE GR25_MOV_INTERNO ADD CONSTRAINT GR25_MOV_INTERNO_MOVIMIENTO
    FOREIGN KEY (id_movimiento_anterior)
    REFERENCES GR25_MOVIMIENTO (id_movimiento)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: GR25_MOV_SALIDA_MOV_ENTRADA (table: GR25_MOV_SALIDA)
ALTER TABLE GR25_MOV_SALIDA ADD CONSTRAINT GR25_MOV_SALIDA_MOV_ENTRADA
    FOREIGN KEY (id_movimiento_entrada)
    REFERENCES GR25_MOV_ENTRADA (id_movimiento)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

--
-- Data for Name: gr25_cliente; Type: TABLE DATA; Schema: unc_249234; Owner: unc_249234
--

INSERT INTO gr25_cliente VALUES (10000000, 'rodolfez', 'juan', '2000-01-01');
INSERT INTO gr25_cliente VALUES (20000000, 'Jorgelin', 'Jorge', '2001-09-11');
INSERT INTO gr25_cliente VALUES (3000000, 'Trelew', 'Jose', '2003-01-01');
INSERT INTO gr25_cliente VALUES (40000000, 'Plomero', 'Mario', '2004-01-01');
INSERT INTO gr25_cliente VALUES (50000000, 'Plomero', 'Luigi', '2005-01-01');


INSERT INTO gr25_alquiler VALUES (1, 3000000, '2018-01-01', '2020-01-01', 10.00);
INSERT INTO gr25_alquiler VALUES (2, 10000000, '2018-01-01', '2020-01-03', 10.00);
INSERT INTO gr25_alquiler VALUES (3, 20000000, '2018-01-01', '2020-01-03', 10.00);
INSERT INTO gr25_alquiler VALUES (4, 40000000, '2018-01-01', '2020-01-03', 10.00);
INSERT INTO gr25_alquiler VALUES (5, 50000000, '2018-01-01', '2020-01-03', 10.00);



--
-- Data for Name: gr25_pallet; Type: TABLE DATA; Schema: unc_249234; Owner: unc_249234
--

INSERT INTO gr25_pallet VALUES ('AAA001', 'doritos', 10.00);
INSERT INTO gr25_pallet VALUES ('AAA002', 'Manaos', 40.00);
INSERT INTO gr25_pallet VALUES ('AAA003', 'plomo', 100.00);
INSERT INTO gr25_pallet VALUES ('AAA004', 'plumas', 100.00);
INSERT INTO gr25_pallet VALUES ('AAA005', 'plastico', 50.00);





--
-- Data for Name: gr25_estanteria; Type: TABLE DATA; Schema: unc_249234; Owner: unc_249234
--

INSERT INTO gr25_estanteria VALUES (1, 'A');
INSERT INTO gr25_estanteria VALUES (2, 'B');
INSERT INTO gr25_estanteria VALUES (3, 'C');
INSERT INTO gr25_estanteria VALUES (4, 'D');
INSERT INTO gr25_estanteria VALUES (5, 'E');


--
-- Data for Name: gr25_fila; Type: TABLE DATA; Schema: unc_249234; Owner: unc_249234
--

INSERT INTO gr25_fila VALUES (1, 1, 'A', 100.00);
INSERT INTO gr25_fila VALUES (1, 2, 'B', 100.00);
INSERT INTO gr25_fila VALUES (1, 3, 'C', 100.00);
INSERT INTO gr25_fila VALUES (1, 4, 'D', 100.00);
INSERT INTO gr25_fila VALUES (1, 5, 'E', 100.00);


--
-- Data for Name: gr25_posicion; Type: TABLE DATA; Schema: unc_249234; Owner: unc_249234
--

INSERT INTO gr25_posicion VALUES (1, 1, 1, 'general');
INSERT INTO gr25_posicion VALUES (2, 1, 1, 'vidrio');
INSERT INTO gr25_posicion VALUES (3, 1, 1, 'insecticidas');
INSERT INTO gr25_posicion VALUES (4, 1, 1, 'inflamable');
INSERT INTO gr25_posicion VALUES (5, 1, 1, 'general');



--
-- Data for Name: gr25_alquiler_posiciones; Type: TABLE DATA; Schema: unc_249234; Owner: unc_249234
--

INSERT INTO gr25_alquiler_posiciones VALUES (1, 1, 1, 1, false);
INSERT INTO gr25_alquiler_posiciones VALUES (1, 2, 1, 1, false);
INSERT INTO gr25_alquiler_posiciones VALUES (1, 3, 1, 1, false);
INSERT INTO gr25_alquiler_posiciones VALUES (1, 4, 1, 1, false);
INSERT INTO gr25_alquiler_posiciones VALUES (1, 5, 1, 1, false);



--
-- Data for Name: gr25_movimiento; Type: TABLE DATA; Schema: unc_249234; Owner: unc_249234
--

INSERT INTO gr25_movimiento VALUES (1, '2019-01-01 00:00:00', 'cliente', 'e');
INSERT INTO gr25_movimiento VALUES (2, '2019-01-01 00:00:00', 'cliente', 'e');
INSERT INTO gr25_movimiento VALUES (3, '2019-01-01 00:00:00', 'cliente', 'e');
INSERT INTO gr25_movimiento VALUES (4, '2019-01-01 00:00:00', 'cliente', 'e');
INSERT INTO gr25_movimiento VALUES (5, '2019-01-01 00:00:00', 'cliente', 'e');
INSERT INTO gr25_movimiento VALUES (6, '2019-01-02 00:00:00', 'jefe', 'i');
INSERT INTO gr25_movimiento VALUES (8, '2019-01-02 00:00:00', 'jefe', 'i');
INSERT INTO gr25_movimiento VALUES (9, '2019-01-02 00:00:00', 'jefe', 'i');
INSERT INTO gr25_movimiento VALUES (10, '2019-01-02 00:00:00', 'jefe', 'i');
INSERT INTO gr25_movimiento VALUES (12, '2019-01-03 00:00:00', 'empleado', 's');
INSERT INTO gr25_movimiento VALUES (13, '2019-01-03 00:00:00', 'empleado', 's');
INSERT INTO gr25_movimiento VALUES (14, '2019-01-03 00:00:00', 'empleado', 's');
INSERT INTO gr25_movimiento VALUES (11, '2019-01-01 12:00:00', 'empleado', 's');
INSERT INTO gr25_movimiento VALUES (15, '2019-01-01 23:00:00', 'empleado', 's');
INSERT INTO gr25_movimiento VALUES (7, '2019-01-02 01:00:00', 'jefe', 'i');


--
-- Data for Name: gr25_mov_entrada; Type: TABLE DATA; Schema: unc_249234; Owner: unc_249234
--

INSERT INTO gr25_mov_entrada VALUES (1, 'triciclo', '', 'AAA001', 1, 1, 1, 1);
INSERT INTO gr25_mov_entrada VALUES (2, 'AAA-001', '', 'AAA002', 1, 2, 1, 1);
INSERT INTO gr25_mov_entrada VALUES (3, 'AAA-001', '', 'AAA003', 1, 3, 1, 1);
INSERT INTO gr25_mov_entrada VALUES (4, 'AAA-001', '', 'AAA004', 1, 4, 1, 1);
INSERT INTO gr25_mov_entrada VALUES (5, 'AAA-001', '', 'AAA005', 1, 5, 1, 1);


--
-- Data for Name: gr25_mov_interno; Type: TABLE DATA; Schema: unc_249234; Owner: unc_249234
--

INSERT INTO gr25_mov_interno VALUES (7, 'ya limpiamos el estante de la leche', 3, 1, 1, 6);
INSERT INTO gr25_mov_interno VALUES (8, 'limpieza', 5, 1, 1, 4);
INSERT INTO gr25_mov_interno VALUES (10, 'mas limpieza', 5, 1, 1, 9);
INSERT INTO gr25_mov_interno VALUES (6, 'a jorge pablo se le cayo una botella de leche ensima', 1, 1, 1, 3);
INSERT INTO gr25_mov_interno VALUES (9, 'limpieza terminada', 4, 1, 1, 8);


--
-- Data for Name: gr25_mov_salida; Type: TABLE DATA; Schema: unc_249234; Owner: unc_249234
--

INSERT INTO gr25_mov_salida VALUES (11, 'AAA-001', '', 1);
INSERT INTO gr25_mov_salida VALUES (12, 'AAA-001', '', 2);
INSERT INTO gr25_mov_salida VALUES (13, 'AAA-001', '', 3);
INSERT INTO gr25_mov_salida VALUES (14, 'AAA-001', '', 4);
INSERT INTO gr25_mov_salida VALUES (15, 'AAA-001', '', 5);







-- End of file.

