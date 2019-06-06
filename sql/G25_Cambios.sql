--A)
ALTER TABLE gr25_alquiler ADD CONSTRAINT chk_fecha_consistente
check(fecha_desde < fecha_hasta);
--INSERT que viola la constraint
INSERT INTO gr25_alquiler ("id_alquiler","id_cliente","fecha_desde","fecha_hasta","importe_dia")
                    VALUES('6','3000000','2019/5/21','2019/5/15','100');
--Respuesta del DBMS
--ERROR:  new row for relation "gr25_alquiler" violates check constraint "chk_fecha_consistente"
--DETAIL:  Failing row contains (6, 3000000, 2019-05-21, 2019-05-15, 100.00).

--b
--no anda
 CREATE OR REPLACE FUNCTION restriccionPeso( ) RETURNS trigger AS $body$
BEGIN
	IF(EXISTS(SELECT 1
				FROM GR25_MOVIMIENTO m JOIN GR25_MOV_ENTRADA me ON (m.id_movimiento = me.id_movimiento) JOIN GR25_PALLET p ON(me.cod_pallet = p.cod_pallet) JOIN GR25_FILA f ON (f.nro_fila = me.nro_fila AND f.nro_estanteria = me.nro_estanteria) LEFT JOIN GR25_MOV_SALIDA s ON (s.id_movimiento_entrada = me.id_movimiento) 
				WHERE s.id_movimiento IS NULL AND GR25_MOV_ENTRADA.nro_fila = new.nro_fila
				GROUP BY me.nro_estanteria, me.nro_fila, m.fecha
				HAVING EXISTS(SELECT 1
					FROM GR25_MOVIMIENTO m2 JOIN GR25_MOV_ENTRADA me2 ON (m2.id_movimiento = me2.id_movimiento)
					WHERE me.nro_estanteria = me2.nro_estanteria AND me.nro_fila = me2.nro_fila
					GROUP BY me2.nro_estanteria, me2.nro_fila
					HAVING m.fecha = MAX(m2.fecha))
				AND SUM(p.peso) > MAX(f.peso_max_kg)))
	THEN RAISE EXCEPTION 'el peso total supera la capacidad de la fila';
	END IF;
	RETURN new;
END; $body$ LANGUAGE 'plpgsql';


CREATE TRIGGER verificaPeso
AFTER INSERT ON GR25_MOV_ENTRADA
FOR EACH ROW
EXECUTE PROCEDURE restriccionPeso( )

--esto superaria el max de una fila
--UPDATE GR25_PALLET SET peso = 101
--WHERE descripcion = 'plomo'

--C)
ALTER TABLE gr25_posicion ADD CONSTRAINT chk_valores_tipo
check(tipo = 'general' OR tipo = 'vidrio' OR tipo = 'insecticidas' OR tipo = 'inflamable');
--INSERT que viola la constraint
INSERT INTO gr25_posicion ("nro_posicion","nro_estanteria","nro_fila","tipo")
                    VALUES('6','1','1','limpieza');
--Respuesta del DBMS
--ERROR:  new row for relation "gr25_posicion" violates check constraint "chk_valores_tipo"
--DETAIL:  Failing row contains (6, 1, 1, limpieza).

--servicio 1
CREATE OR REPLACE FUNCTION posiciones_libres(date) RETURNS TABLE(nro_posicion integer, nro_estanteria integer, nro_fila integer) AS $$
DECLARE
	dateEntrada ALIAS FOR $1;
BEGIN
	RETURN QUERY SELECT p.nro_posicion, p.nro_estanteria, p.nro_fila
			FROM GR25_POSICION p NATURAL LEFT JOIN GR25_ALQUILER_POSICIONES ap NATURAL JOIN GR25_ALQUILER a
			WHERE id_alquiler IS NULL OR (a.fecha_desde > dateEntrada OR a.fecha_hasta < dateEntrada);
END; $$ LANGUAGE plpgsql;

--SELECT * FROM posiciones_libres(TO_DATE('2019/1/1', 'YYYY/MM/DD')) 
--devuelve 0
--SELECT * FROM posiciones_libres(TO_DATE('2020/1/1', 'YYYY/MM/DD'))
--devuelve varias posiciones



--servicio 2
CREATE OR REPLACE FUNCTION avisoVencimiento(integer) RETURNS TABLE(cuit_cuil integer, apellido varchar, nombre varchar) AS $$
DECLARE
	dias ALIAS FOR $1;
BEGIN
	RETURN QUERY SELECT c.cuit_cuil, c.apellido, c.nombre
		FROM GR25_CLIENTE c JOIN gr25_alquiler a ON (c.cuit_cuil = a.id_cliente)
		WHERE (a.fecha_hasta - CURRENT_DATE) <= dias;
END; $$ LANGUAGE plpgsql;


--SELECT * FROM aviso_vencimiento(213)
--devuelve a 3000000 Trelew	Jose
--SELECT * FROM aviso_vencimiento(215)
--DEVUELVE A EL RESTO



--vista2
CREATE VIEW mayores_inversores AS SELECT c.cuit_cuil, c.nombre, c.apellido, (COALESCE(c1.pagado_en_anio ,0) + COALESCE(c2.pagado_en_anio ,0) + COALESCE(c3.pagado_en_anio ,0) + COALESCE(c4.pagado_en_anio ,0)) AS dinero_invertido
FROM GR25_CLIENTE c LEFT JOIN
(SELECT SUM((CURRENT_DATE - a.fecha_desde) * a.importe_dia) AS pagado_en_anio, a.id_cliente
FROM GR25_ALQUILER a
WHERE DATE_PART('year', a.fecha_desde) = DATE_PART('year', CURRENT_DATE)  AND a.fecha_hasta > CURRENT_DATE AND CURRENT_DATE - a.fecha_desde > 0
GROUP BY a.id_cliente) c1
ON (c1.id_cliente = c.cuit_cuil)
LEFT JOIN 
(SELECT SUM(EXTRACT(doy from CURRENT_DATE) * a.importe_dia) AS pagado_en_anio, a.id_cliente
FROM GR25_ALQUILER a
WHERE DATE_PART('year', a.fecha_desde) < DATE_PART('year', CURRENT_DATE)  AND a.fecha_hasta > CURRENT_DATE
GROUP BY a.id_cliente) c2
ON(c2.id_cliente = c.cuit_cuil)
LEFT JOIN
(SELECT SUM((a.fecha_desde - a.fecha_hasta) * a.importe_dia) AS pagado_en_anio, a.id_cliente
FROM GR25_ALQUILER a
WHERE DATE_PART('year', a.fecha_desde) = DATE_PART('year', CURRENT_DATE)  AND a.fecha_hasta < CURRENT_DATE AND CURRENT_DATE - a.fecha_desde > 0
GROUP BY a.id_cliente) c3
ON(c3.id_cliente = c.cuit_cuil)
LEFT JOIN
(SELECT SUM(EXTRACT(doy from a.fecha_hasta) * a.importe_dia) AS pagado_en_anio, a.id_cliente
FROM GR25_ALQUILER a
WHERE DATE_PART('year', a.fecha_desde) < DATE_PART('year', CURRENT_DATE)  AND a.fecha_hasta < CURRENT_DATE
GROUP BY a.id_cliente) c4
ON (c.cuit_cuil = c4.id_cliente)
ORDER BY (COALESCE(c1.pagado_en_anio ,0) + COALESCE(c2.pagado_en_anio ,0) + COALESCE(c3.pagado_en_anio ,0) + COALESCE(c4.pagado_en_anio ,0)) DESC
LIMIT 10


--vista 1
CREATE VIEW estado_posiciones AS
SELECT p.nro_posicion,p.nro_fila,p.nro_estanteria,(ap.id_alquiler IS NOT NULL) AS ocupado, (a.fecha_hasta - CURRENT_DATE) AS dias_restantes 
FROM gr25_posicion p
LEFT JOIN gr25_alquiler_posiciones ap ON (p.nro_posicion = ap.nro_posicion)
LEFT JOIN gr25_alquiler a ON (ap.id_alquiler = a.id_alquiler);
