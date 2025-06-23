<?php
/*
$connectionInfo = [
    "Database" => "app_Checkalo",
    "UID" => "user_rpt",
    "PWD" => "Ph9Dri*3ewrep",
    "TrustServerCertificate" => "yes",
];
//$conn = sqlsrv_connect("184.168.28.51", $connectionInfo);*/
$pdo = new PDO(
    "sqlsrv:Server=184.168.28.51;Database=app_Checkalo",
    "user_rpt",
    "Ph9Dri*3ewrep"
);
var_dump($pdo);
die();
