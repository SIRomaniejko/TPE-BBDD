<?php 
    require_once('model/PosicionesModel.php');
    class PosicionesController{
        private $model;
        function __construct(){
            $this->model = new PosicionesModel();
            
        }
        function home(){
            $this->model->home();
        }

        function test(){
            print_r($this->model->test());
        }

        function getPosicionesLibres($params){
            $this->model->getPosicionesLibres($params[0]);
        }
        
    }