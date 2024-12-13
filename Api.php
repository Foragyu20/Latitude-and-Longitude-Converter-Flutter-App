<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *'); // Allow all origins for CORS

// Database connection setup
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "coordinates_db";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Database connection failed"]));
}

// Check if the request is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get POST data
    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $dms_lat = $_POST['dms_lat'];
    $dms_lng = $_POST['dms_lng'];

    // Insert into database
    $sql = "INSERT INTO coordinates (latitude, longitude, dms_lat, dms_lng) VALUES ('$latitude', '$longitude', '$dms_lat', '$dms_lng')";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Coordinates saved successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error: " . $sql . " - " . $conn->error]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

$conn->close();
?>
