<?php
if (!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM user_info WHERE user_email = '$email' AND user_password = '$password'";
$result = $conn->query($sqllogin);
$numrow = $result->num_rows;

if ($numrow > 0) {
    while ($row = $result->fetch_assoc()) {
        $admin['id'] = $row['user_id'];
        $admin['email'] = $row['user_email'];
        $admin['name'] = $row['user_name'];
        $admin['password'] = $row['user_password'];
        $admin['phone'] = $row['user_phone'];
        $admin['address'] = $row['user_address'];
        $admin['regdate'] = $row['user_datereg'];
        $admin['otp'] = $row['otp'];
        $response = array('status' => 'success', 'data' => $admin);
        sendJsonResponse($response);
    }
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>