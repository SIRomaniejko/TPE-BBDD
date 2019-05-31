<?php

define('HOME', 'Location: http://'.$_SERVER["SERVER_NAME"] .":". $_SERVER['SERVER_PORT'].dirname($_SERVER["PHP_SELF"]));
define('ROOT',  dirname($_SERVER["PHP_SELF"]));
define('LOGIN', HOME."/login");
define('ADMIN', HOME."/administrador");
define('USERS', HOME."/usuarios");
define('ERRORTITULO', HOME."/errorFormulario");
define('404', HOME."/404");
require_once "config/ConfigApp.php";
require_once('controller/TestController.php');

function parseURL($url)
{
  $urlExploded = explode('/', $url);
  $arrayReturn[ConfigApp::$ACTION] = $urlExploded[0];
  #borrar/1/2/3/4
  $arrayReturn[ConfigApp::$PARAMS] = isset($urlExploded[1]) ? array_slice($urlExploded,1) : null;
  return $arrayReturn;
}

if(isset($_GET['action'])){
   #$urlData[ACTION] = borrar
   #$urlData[PARAMS] = [1,2,3,4]

    $urlData = parseURL($_GET['action']);
    $action = $urlData[ConfigApp::$ACTION]; //home
    if(array_key_exists($action,ConfigApp::$ACTIONS)){
        $params = $urlData[ConfigApp::$PARAMS];
        $action = explode('#',ConfigApp::$ACTIONS[$action]); //Array[0] -> TareasController [1] -> BorrarTarea
        $controller =  new $action[0]();
        $metodo = $action[1];
        if(isset($params) &&  $params != null){
            echo $controller->$metodo($params);
        }
        else{
            echo $controller->$metodo();
        }
    }else{
        header(HOME."/404");
    }
}
 ?>
