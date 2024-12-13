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
    die(json_encode(["status" => "error", "message" => "Database connection failed"]));
}

// Get POST data
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$dms_lat = $_POST['dms_lat'];
$dms_lng = $_POST['dms_lng'];
