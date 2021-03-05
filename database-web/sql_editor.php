<!DOCTYPE html>

<html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>CodeMirror: SQL Mode for CodeMirror</title>

  <link rel="stylesheet" href="./code-mirror-files/docs.css">
  <link rel="stylesheet" href="./css/stil2.css">
  <link rel="stylesheet" href="./code-mirror-files/codemirror.css">
  <script src="./code-mirror-files/codemirror.js"></script>
  <script src="./code-mirror-files/matchbrackets.js"></script>
  <script src="./code-mirror-files/sql.js"></script>
  <link rel="stylesheet" href="./code-mirror-files/show-hint.css">
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
  <script src="./code-mirror-files/show-hint.js"></script>
  <script src="./code-mirror-files/sql-hint.js"></script>
  <style>
    .CodeMirror {
      border-top: 1px solid black;
      border-bottom: 1px solid black;
    }
  

        hr {
            border-color: rgba(200, 200, 200, 0.2);
        }
        .sidenav {
            height: 100%;
            width: 220px;
            position: fixed;
            z-index: 1;
            top: 0;
            left: 0;
            background-color: #111;
            overflow-x: hidden;
            padding-top: 20px;
        }

        .sidenav a {
            padding: 6px 8px 6px 8px;
            text-decoration: none;
            font-size: 16px;
            color: #c1c1c1;
            display: block;
        }

        .sidenav a:hover {
            color: #fff1f1;
            border-left: 3px solid rgb(6, 175, 226);
        }

         
        .main {
            margin-left: 220px;

            padding: 0px 5px;
        }

        @media screen and (max-height: 450px) {
            .sidenav {
                padding-top: 15px;
            }

            .sidenav a {
                font-size: 12px;
            }
        }
		
		tr,th,td{
			font-size: 14px;
		}
		tr{
			height:12px;
            cursor: pointer;
		}
		tr:nth-child(even) {background: #EBF5FB}
		tr:nth-child(odd) {background: #FFF}
	    .table td, .table th{
		
		padding:5px;
	    }
        input[type=button], input[type=submit], input[type=reset] {
            background-color: #4CAF50;
            border: none;
            color: white;
            padding: 8px 32px;
            text-decoration: none;
            margin: 4px 2px;
            cursor: pointer;
            
       
        }
        .CodeMirror{
            height: 200px;
        }
  </style>
</head>

<body>
<?php 
    include 'left.php';
?>
    <div class="main">
<?php
  ini_set('display_errors', '1');
  ini_set('display_startup_errors', '1');
  error_reporting(E_ALL);
  require_once 'api.php';
  $apim = new api();

  $first_sql="select 
  customer.Customer_id,
  customer.Customer_name,
  ffc.Airline_code,
  ffc.Total_millage ,
  segment.Segment_name 'Customer Segment'
  ,(segment.Millage_min) 'Segment Min', 
  (segment.Millage_max) 'Segment Max'
  from ffc
  left join customer on customer.Customer_id = ffc.Customer_id
  left join segment on (segment.Airline_code = ffc.Airline_code )
  and (ffc.Total_millage between segment.Millage_min and segment.Millage_max)";

  $cmd = isset($_POST['sorgu_sql']) ? $_POST['sorgu_sql'] : $first_sql;
?>
    <script>
        function clearSql() {
          document.getElementById("code").value = ""; 
          console.log("Deneme");
        }
    </script>
  <form action="./sql_editor.php" method="POST" >
  <input type="submit" value="EXEC SQL">  </input> <br>
    <textarea id="code" name="sorgu_sql" style="display: none;"><?php echo $cmd; ?></textarea>
    <script>
      window.onload = function () {
        var mime = 'text/x-mariadb';
        // get mime type
        if (window.location.href.indexOf('mime=') > -1) {
          mime = window.location.href.substr(window.location.href.indexOf('mime=') + 5);
        }
        window.editor = CodeMirror.fromTextArea(document.getElementById('code'), {
          mode: mime,
          indentWithTabs: true,
          smartIndent: true,
          lineNumbers: true,
          matchBrackets: true,
          autofocus: true,
          extraKeys: { "Ctrl-Space": "autocomplete" },
          hintOptions: {
            tables: {
              users: ["name", "score", "birthDate"],
              countries: ["name", "population", "size"]
            }
          }
        });
      };


    </script>
<?php
  
    $data = [];

    $veri=$apim->get_sqltable(  $cmd );
    $data = $veri['data'];
    $sorgu=$veri['sql'];
    echo "<h5 class=' pl-2 pt-3 pb-2  bg-light text-dark border-bottom'>SQL | <span class='text-primary'><i> Table Records</i></span> </h5>";
    if(count($data)>0){                 
        echo "<table id=\"data_table\" border='0' class='fixed_header table table-hover'>\r\n";
        $colNames = array_keys(reset($data));                      
        echo " <thead><tr>\r\n";
        foreach($colNames as $colName)
        {
            echo "<th>".($colName)."</th>\r\n";
        }
 //       echo "<th>Actions</th>\r\n";
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
//            echo "<td> <a href='?entity=".$cmd."&action=delete&id=1' class=\"bg-dangwer\">DEL</a></td>\r\n";                      
            echo "</tr>\r\n";
        }
        echo "</table>\r\n";
    }else{
        echo "<div style=\"width:100%\" class=\" bg-secondary text-white\">Kayıt yok</div>";
    } 
?></div>
</body>

</html>