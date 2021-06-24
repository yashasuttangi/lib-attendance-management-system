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


    $admin_id = $_POST['admin_id'];
    $password = $_POST['password'];

    $sql = "SELECT * FROM `Library_card_index` WHERE `faculty_id`=$admin_id";
    $sql2 = "SELECT * FROM `Faculty` WHERE `faculty_id`=$admin_id AND `Designation`='Librarian'";
    if(!$sql || !$sql2) {
        ?>
            <!-- WRONG PASSWORD -->
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
                        title: 'Admin ID is incorrect!',
                        text: 'Please check the admin ID and password',
                        icon: 'error',
                        confirmButtonText: 'Retry'
                    }).then((result) => {
                        if (result.isConfirmed) {
                                window.location.href = "admin_login.html";
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
    } else {
        $pass = mysqli_query($con, "SELECT * FROM `Library_card_index` WHERE `faculty_id`=$admin_id AND `password`='$password' AND `faculty_id`=(SELECT `faculty_id` FROM `Faculty` WHERE `Designation`='Librarian')");
        $res = mysqli_num_rows($pass);
        if($res == 1) {
            // echo "Password verified";
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
                        position: 'center',
                        icon: 'success',
                        title: 'Successful',
                        showConfirmButton: false,
                        timer: 2300
                    }).then(() => {
                            window.location.href = "http://localhost/attendance-management-system/admin/node_modules/startbootstrap-sb-admin-2/index.php";
                    })
                </script>
                </body>
            </html>

            <?php
        } else {
            // echo "Wrong password";
            ?>
                    <!-- WRONG PASSWORD -->
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
                            title: 'Wrong Password',
                            text: 'Please check your admin ID and password',
                            icon: 'error',
                            confirmButtonText: 'Retry'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                    window.location.href = "admin_login.html";
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

        echo "Success login";
    }


?>