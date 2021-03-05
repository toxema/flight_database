<?php
ini_set('display_errors', '1');
ini_set('display_startup_errors', '1');
error_reporting(E_ALL);
require_once 'api.php';
$apim = new api();
$cmd = isset($_GET['entity']) ? $_GET['entity'] : 'customer';
$action = isset($_GET['action']) ? $_GET['action'] : 'list';

$data = [];

$veri=$apim->get_table(  $cmd ,$action);
$data = $veri['data'];
$sorgu=$veri['sql'];

echo "<h5 class=' pl-2 pt-3 pb-2  bg-light text-dark border-bottom'>".strtoupper($cmd)." | 
<span class='text-primary'><i> Table Records</i></span>
<a href=\"#\"  class=\" bg-dark text-yellow px-3 py-1\" style=\"float:right;\" onclick=\"toggleSqlDiv()\">
<i class=\"fa fa-laptop-code\"></i>  SQL View</a>
</h5>";
echo "<div id=\"sql_div\" style =\" display: none; \"class=\"multiline border mt-1 pl-2 bg-warning\">".$sorgu."</div>";


if(count($data)>0){                 
    echo "<table id=\"data_table\" border='0' class='fixed_header table table-hover'>\r\n";
    $colNames = array_keys(reset($data));                      
    echo " <thead><tr>\r\n";
    foreach($colNames as $colName)
    {
        echo "<th>".($colName)."</th>\r\n";
    }
  //  echo "<th>Actions</th>\r\n";
    echo "</tr>\r\n";   
    echo " </thead><tr>\r\n";               
    echo "</tr>\r\n";
    for($k=0;$k<count($data);$k++){
        $row=$data[$k];
        if($k%2==0){
            echo "<tr class=\"odd-row\">\r\n";
        }else {
            
            echo "<tr>\r\n";
        }
        
        foreach ($row as $field => $value) { // I you want you can right this line like this: foreach($row as $value) {
            echo "<td>" . $value . "</td>\r\n"; // I just did not use "htmlspecialchars()" function. 
        } 
       // echo "<td> <a href='?entity=".$cmd."&action=delete&id=1' class=\"bg-dangwer\">DEL</a></td>\r\n";                      
        echo "</tr>\r\n";
    }
    echo "</table>\r\n";
}else{
    echo "<div style=\"width:100%\" class=\" bg-secondary text-white\">Kayıt yok</div>";
} 
?>