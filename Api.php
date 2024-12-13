<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Database connection setup
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "coordinates_db";

$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Database connection failed: " . $conn->connect_error]));
}

// Get POST data
$latitude = $_POST['latitude'] ?? null;
$longitude = $_POST['longitude'] ?? null;
$dms_lat = $_POST['dms_lat'] ?? null;
$dms_lng = $_POST['dms_lng'] ?? null;

// Validate input
if (empty($latitude) || empty($longitude) || empty($dms_lat) || empty($dms_lng)) {
    echo json_encode(["status" => "error", "message" => "Invalid input"]);
    exit;
}

// Insert into database using prepared statements
$sql = $conn->prepare("INSERT INTO coordinates (latitude, longitude, dms_lat, dms_lng) VALUES (?, ?, ?, ?)");
$sql->bind_param("ddss", $latitude, $longitude, $dms_lat, $dms_lng);

if ($sql->execute()) {
    echo json_encode(["status" => "success", "message" => "Coordinates saved successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error: " . $sql->error]);
}

$sql->close();
$conn->close();
?>
