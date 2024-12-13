import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() {
  runApp(const LatLngConverterApp());
}

class LatLngConverterApp extends StatefulWidget {
  const LatLngConverterApp({super.key});

  @override
  LatLngConverterAppState createState() => LatLngConverterAppState();
}

class LatLngConverterAppState extends State<LatLngConverterApp> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final MapController _mapController = MapController();
  String _convertedCoords = '';
  LatLng _markerPosition = LatLng(14.5597, 121.0629);

  void _convertToDMS() {
    double latitude = double.parse(_latitudeController.text);
    double longitude = double.parse(_longitudeController.text);

    setState(() {
      _convertedCoords =
          "${_toDMS(latitude, 'N', 'S')}, ${_toDMS(longitude, 'E', 'W')}";
      _markerPosition = LatLng(latitude, longitude);
    });

    _mapController.move(_markerPosition, 14);
  }

  void _saveCoords() async {
    final lat = _latitudeController.text;
    final lng = _longitudeController.text;

    try {
      final response = await http.post(
        Uri.parse('https://192.168.100.26/PHP_api/Api.php'),
        body: {
          'latitude': lat,
          'longitude': lng,
          'dms_lat': _toDMS(double.parse(lat), 'N', 'S'),
          'dms_lng': _toDMS(double.parse(lng), 'E', 'W')
        },
        headers: {
          HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.statusCode == 200
                ? 'Coordinates saved successfully!'
                : 'Failed to save coordinates.'),
          ),
        );
      }
    } catch (e) {
      print(
          "Error saving coordinates: $e"); // Change this to use a logger instead
    }
  }

  String _toDMS(double value, String posDir, String negDir) {
    final direction = value >= 0 ? posDir : negDir;
    value = value.abs();
    final degrees = value.floor();
    final minutes = ((value - degrees) * 60).floor();
    final seconds = (((value - degrees) * 60 - minutes) * 60).floor();
    return '$degrees° $minutes\' $seconds" $direction';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('Lat/Lng Converter')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              DecimalInputField(
                controller: _latitudeController,
                labelText: 'Latitude (Decimal Degrees)',
              ),
              DecimalInputField(
                controller: _longitudeController,
                labelText: 'Longitude (Decimal Degrees)',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _convertToDMS,
                child: const Text('Convert Coords'),
              ),
              if (_convertedCoords.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Converted Coords: $_convertedCoords'),
                ),
              ElevatedButton(
                onPressed: _saveCoords,
                child: const Text('Save to Database'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _markerPosition,
                    zoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                      tileSize: 256,
                      minZoom: 0,
                      maxZoom: 18,
                      backgroundColor: const Color(0xFFE0E0E0),
                      errorTileCallback: (tile, error, stackTrace) {
                        print("Tile load error: $error");
                      },
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _markerPosition,
                          builder: (ctx) => const Icon(Icons.location_pin,
                              color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ]),
          )),
    );
  }
}

class DecimalInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const DecimalInputField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: _validateInput(controller.text),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
      ],
      onChanged: (value) {
        (context as Element).markNeedsBuild();
      },
    );
  }

  String? _validateInput(String input) {
    if (input.isEmpty) {
      return 'This field cannot be empty';
    }
    if (double.tryParse(input) == null) {
      return 'Enter a valid decimal number';
    }
    return null;
  }
}
