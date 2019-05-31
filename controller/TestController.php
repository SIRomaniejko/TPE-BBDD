<?php 
    require_once('model/TestModel.php');
    class TestController{
        private $model;
        function __construct(){
            $this->model = new testModel();
            
        }

        function test(){
            print_r($this->model->test());
        }
    }