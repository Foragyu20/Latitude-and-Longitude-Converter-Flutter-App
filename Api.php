<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Database connection setup
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "coordinates_db";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}

// Check if request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $dms_lat = $_POST['dms_lat'];
    $dms_lng = $_POST['dms_lng'];

    // Prepare and bind
    $stmt = $conn->prepare("INSERT INTO coordinates (latitude, longitude, dms_lat, dms_lng) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $latitude, $longitude, $dms_lat, $dms_lng);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Coordinates saved successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error saving coordinates"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

$conn->close();
?>
