<?php

class ConfigApp
{
    public static $ACTION = 'action';
    public static $PARAMS = 'params';
    public static $ACTIONS = [
      'superTest' => 'TestController#test',
      '' => 'PosicionesController#home',
      'posicionesLibres' => 'PosicionesController#getPosicionesLibres',
      'posicionesOcupadasCliente' => 'PosicionesController#getPosicionesOcupadasCliente'
    ];

}

 ?>
