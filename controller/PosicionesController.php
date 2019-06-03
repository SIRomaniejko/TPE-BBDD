<?php 
    require_once('model/PosicionesModel.php');
    require_once('view/PosicionesView.php');
    class PosicionesController{
        private $model;
        private $view;
        function __construct(){
            $this->model = new PosicionesModel();
            $this->view = new PosicionesView();
        }
        function home(){
            $this->view->home();
        }

        function test(){
            print_r($this->model->test());
        }

        function getPosicionesLibres(){
            $fecha = $_POST['fecha'];
            $pos = $this->model->getPosicionesLibres($fecha);
            $titulo = "Posiciones Libres";
            $this->view->posiciones($pos,$titulo);
        }
        function getPosicionesOcupadasCliente(){
            $cuil = $_POST['cuit'];
            $pos = $this->model->getPosicionesOcupadasCliente($cuil);
            $titulo = "Posiciones Ocupadas";
            $this->view->posiciones($pos,$titulo);
        }
    }