<?php
phpinfo();
die();
ini_set("display_errors", "1");
ini_set("display_startup_errors", "1");
error_reporting(E_ALL);
/*
phpinfo();
*/
include "db.php";
$id = empty(!$_GET["report"]) ? $_GET["reporte"] : false;
$stmt = sqlsrv_query($conn, "select * from dbo.Vehiculos where InformeID=?");
if ($stmt === false) {
    die(print_r(sqlsrv_errors(), true));
}
$arr = sqlsrv_fetch_array($stmt, 2);
echo "<pre>";
var_dump($arr);
/*
184.168.28.51
user_rpt
Ph9Dri*3ewrep
*/
