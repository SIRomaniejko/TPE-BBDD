<?php
class Model{
    function Connect(){
        return new PDO('pgsql:host=dbases.exa.unicen.edu.ar;'
        .'dbname=cursada'
        , 'unc_249234', 'TPEBBDD');
    }
}
