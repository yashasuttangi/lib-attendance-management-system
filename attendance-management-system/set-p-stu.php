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

    $usn = $_POST['usn'];
    $password = $_POST['password'];
    $c_password = $_POST['confirm_password'];

    if($password == $c_password){    
        $res = mysqli_query($con, "SELECT * FROM `Students` WHERE `USN`='$usn'");
        if($res == false) {
            $rows = 0;
        } else {
            $rows = mysqli_num_rows($res);
        }

        if($rows == 1) {
            // Set password for a new faculty ID
            $sql1 = mysqli_query($con, "INSERT INTO `Library_card_index` (`lib_id`, `college_id`, `password`) VALUES ('$lib_id', '$usn', '$password')");
            $sql2 = mysqli_query($con, "UPDATE `Students` SET lib_id='$lib_id' WHERE USN='$usn'");
            if(!$sql2 || !$sql1) {
                ?>
                // Invalid Credentials 
                <html>
                    <head>
                        <link rel="stylesheet" type="text/css" href="style.css">
                        <script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                        <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
                    </head>
                    <body>
                    <p style="text-align:center"> .. </p>
                        <script>
                        Swal.fire({
                            title: 'Registration Failed',
                            text: 'Please make sure you are entering the correct details. For further queries contact the librarian',
                            icon: 'error',
                            confirmButtonText: 'Retry'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                    window.location.href = "set_pass_student.html";
                                //   Swal.fire(
                                //     'Deleted!',
                                //     'Your file has been deleted.',
                                //     'success'
                                //   )
                                }
                            })
                    </script>
                    </body>
                </html>
                <?php
            } else { // SUCCESS 
                ?>
                <html>  
                    <head>
                    <title> Registered </title>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <link rel="stylesheet" type="text/css" href="style.css">
                    <link href="https://fonts.googleapis.com/css?family=Nunito:400,600,700,800&display=swap" rel="stylesheet">
                </head>
                <body>
            <div class="cont">
                <br>
                <br>
                <h1 style="text-align:center"> Student Successfully Registered  </h1>
                <br>
                <center><img src="images/tick.png"></center>
                <br>
                <h2 style=text-align:center> Please remember your Library ID for login </h2>
                <h3 style="text-align:center"> Your library ID is  <?php echo $lib_id ?> </h3>
            </div>
            </body>
        </html>

        <?php
            }
        } 
        else {
            // Student does not exist
            ?>
                <html>
                    <head>
                        <link rel="stylesheet" type="text/css" href="style.css">
                        <script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                        <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
                    </head>
                    <body>
                    <p style="text-align:center"> .. </p>
                        <script>
                        Swal.fire({
                            title: 'USN does not exist!',
                            text: 'Please enter the correct USN',
                            icon: 'error',
                            confirmButtonText: 'Retry'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                    window.location.href = "set_pass_student.html";
                                //   Swal.fire(
                                //     'Deleted!',
                                //     'Your file has been deleted.',
                                //     'success'
                                //   )
                                }
                            })
                    </script>
                    </body>
                </html>
            <?php
        }
    }

    else {
        ?>
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="style.css">
                <script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
            </head>
            <body>
            <p style="text-align:center"> .. </p>
                <script>
                Swal.fire({
                    title: 'No',
                    text: 'Make sure password and confirm password fields have the same value',
                    icon: 'error',
                    confirmButtonText: 'Retry'
                }).then((result) => {
                    if (result.isConfirmed) {
                            window.location.href = "set_pass_student.html";
                        //   Swal.fire(
                        //     'Deleted!',
                        //     'Your file has been deleted.',
                        //     'success'
                        //   )
                        }
                    })
            </script>
            </body>
        </html>

        <?php
    }

    header("refresh:07; url=index.html");
?>


