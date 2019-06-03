<?php
require_once('model/Model.php');
class PosicionesModel extends Model{
    private $db;

    function __construct(){
      $this->db = $this->Connect();
    }

    function test(){

        $sentencia = $this->db->prepare("SELECT * FROM unc_249234.test1");
        $sentencia->execute();
        return $sentencia->fetchAll(PDO::FETCH_ASSOC);
    }
    function getPosicionesOcupadasCliente($id_cliente){
        $sentencia = $this->db->prepare("SELECT nro_posicion, nro_estanteria, nro_fila
        FROM gr25_alquiler a
        JOIN gr25_alquiler_posiciones ap ON (a.id_alquiler = ap.id_alquiler)
        WHERE CURRENT_DATE < a.fecha_hasta AND CURRENT_DATE >= a.fecha_desde
        AND a.id_cliente = ?");
        $sentencia->execute(array($id_cliente));
        return $sentencia->fetchAll(PDO::FETCH_ASSOC);

    }
    function getPosicionesLibres($fecha){
        $sentencia = $this->db->prepare("SELECT * FROM posiciones_libres(?)");
        $sentencia->execute(array($fecha));
        return $sentencia->fetchAll(PDO::FETCH_ASSOC);
    }
}
