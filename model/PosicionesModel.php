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
        $sentencia = $this->db->prepare("SELECT * FROM gr25_cliente c
        JOIN gr25_alquiler a ON (c.cuit_cuil = a.id_cliente)
        JOIN gr25_alquiler_posiciones ap ON (a.id_alquiler = ap.id_alquiler)
        WHERE cuit_cuil = ?");
        $sentencia->execute(array($id_cliente));
        return $sentencia->fetchAll(PDO::FETCH_ASSOC);

    }
    function getPosicionesLibre($fecha){
        $sentencia = $this->db->prepare("SELECT * FROM posiciones_libres(?)");
        $sentencia->execute(array($fecha));
        return $sentencia->fetchAll(PDO::FETCH_ASSOC);
    }
}
