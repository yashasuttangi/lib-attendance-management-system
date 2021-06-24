<?php

    $con = mysqli_connect('127.0.0.1','root','mysql123');

    if(!$con)
    {
        echo 'Not connected to the server';
    }

    if(!mysqli_select_db($con, 'attendance_management_system'))
    {
        echo 'Database not selected';
    }

    function gen_random_key() {

        $conn = mysqli_connect("localhost", "root", "mysql123", "attendance_management_system");

        $key = rand(100000, 999999);
        $result = mysqli_query($conn,"SELECT * FROM `Library_card_index` WHERE `lib_id`=$key");
        if(mysqli_num_rows($result) > 0){
            while($data = mysqli_fetch_assoc($result)){
                gen_random_key();
            }
        }else{
            // echo "No Records Found!";
            return $key;          
        }

    }

    $lib_id = gen_random_key();
    
    $Name = $_POST['name'];
    $PhoneNumber = $_POST['phone'];
    $College = $_POST['college'];
    $Department = $_POST['department'];
    $Designation = $_POST['designation'];
    $Employee_ID = $_POST['employee_id'];
    $password = $_POST['password'];

    
    mysqli_query($con, "INSERT INTO Library_card_index (lib_id, faculty_id, `password`) VALUES ('$lib_id', '$Employee_ID', '$password')");

    $sql = "INSERT INTO Outsider_faculty (lib_id, name, phone, college, department, designation, faculty_id) VALUES ('$lib_id', '$Name', '$PhoneNumber', '$College', '$Department','$Designation', '$Employee_ID')";

    

    if(!mysqli_query($con, $sql))
    {
        ?>
        <html>  
            <head>
                <title> Not Registered </title>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <link rel="stylesheet" type="text/css" href="style.css">
                <link href="https://fonts.googleapis.com/css?family=Nunito:400,600,700,800&display=swap" rel="stylesheet">
            </head>
            <body>
            
            <!-- <div class="topleft">Top Left</div> -->
            <div class="cont">
                <!-- <img src="images/warning_sign.png" alt="Warning" class="center-sign"> -->
                <!-- <img src="images/warning_sign.png" size="10"> -->
                <br>
                <br>
                <br>
                <h1 style="text-align:center"> Failed to register </h1>
                <br>
                <center><img src="images/negative2.png" height="200" width="200"></center>
                <br>
                <p style="text-align:center"> Check the details provided / User might already be registered </p>
                <a style = " white-space:nowrap;" href="index.html"><p class="forgot-pass"> HOME </p></a> 
            </div>

            </body>
        </html>
        

       <?php
    }
    else 
    {
        ?>
        <html>  
            <head>
            <title> Not Registered </title>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" type="text/css" href="style.css">
            <link href="https://fonts.googleapis.com/css?family=Nunito:400,600,700,800&display=swap" rel="stylesheet">
        </head>
        <body>
            <div class="cont">
                <br>
                <br>
                <br>
                <h1 style="text-align:center"> User Successfully Registered  </h1>
                <br>
                <center><img src="images/tick.png"></center>
                <br>
                <h3 style="text-align:center"> Your library ID is  <?php echo $lib_id ?> </h3>
            </div>
            </body>
        </html>

        <?php
    }
    
    header("refresh:07; url=index.html");

?>
    