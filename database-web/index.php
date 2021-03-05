<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="./css/stil2.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
    <title>Flight Database App</title>
  
    <style>
    body {
        font-family:  "Verdana",sans-serif;
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
        background-color: rgba(255, 255, 225,0.1);
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

    tr,
    th,
    td {
        font-size: 14px;
    }

    tr {
        height: 12px;
    }

    tr:nth-child(even) {
        background: #EBF5FB
    }

    tr:nth-child(odd) {
        background: #FFF
    }

    .table td,
    .table th {

        padding: 5px;
    }
    .multiline {
        white-space:pre;
        display: "none";
       
        
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
    </style>
    <script>
        function toggleSqlDiv() {
        var x = document.getElementById("sql_div");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
  }
}
    </script>
</head>

<body>

    <?php 
        include 'left.php';
    ?>

    <div class="main">
        <?php 
            if(isset($_GET['entity'])){
                include 'service.php'; 
            }else{
                echo "";
            }              
        ?>
    </div>
</body>

</html>