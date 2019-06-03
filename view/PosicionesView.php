<?php
    require_once('libs/Smarty.class.php');
    require_once('View.php');

    class PosicionesView extends View{
        function __construct() {
            parent::__construct();
        }
        function home(){
            $this->smarty->display('templates/home.tpl');
        }
        function posiciones($posiciones,$titulo){
            $this->smarty->assign('titulo',$titulo);
            $this->smarty->assign('posiciones',$posiciones);
            $this->smarty->display('templates/posiciones.tpl');
            //print_r($posiciones);
        }
        function aa($reviews, $categorias){
            $this->smarty->assign('reviews', $reviews);
            $this->smarty->assign('categorias', $categorias);
            $this->smarty->display('templates/home.tpl');
        }
    }
?>
