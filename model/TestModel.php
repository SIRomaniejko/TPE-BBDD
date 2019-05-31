<?php
require_once('model/Model.php');
class TestModel extends Model{
    private $db;

    function __construct(){
      $this->db = $this->Connect();
    }

    function test(){

        $sentencia = $this->db->prepare("SELECT * FROM unc_249234.test1");
        $sentencia->execute();
        return $sentencia->fetchAll(PDO::FETCH_ASSOC);
    }
}
