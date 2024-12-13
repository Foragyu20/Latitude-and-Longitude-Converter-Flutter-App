import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart'as http;
class LatLngConverterApp extends StatefulWidget {
  const LatLngConverterApp({super.key});

  @override
  LatLngConverterAppState createState() => LatLngConverterAppState();
}

class LatLngConverterAppState extends State<LatLngConverterApp> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  String _convertedCoords = '';
  LatLng? _markerPosition;

  void _convertToDMS() {
    double latitude = double.parse(_latitudeController.text);
    double longitude = double.parse(_longitudeController.text);

    setState(() {
      _convertedCoords = "${_toDMS(latitude, 'N', 'S')}, ${_toDMS(longitude, 'E', 'W')}";
      _markerPosition = LatLng(latitude, longitude);
    });
  }

  String _toDMS(double value, String posDir, String negDir) {
    final direction = value >= 0 ? posDir : negDir;
    value = value.abs();
    final degrees = value.floor();
    final minutes = ((value - degrees) * 60).floor();
    final seconds = (((value - degrees) * 60 - minutes) * 60).floor();
    return '$degrees° $minutes\' $seconds" $direction';
  }

  void _saveCoords() async {
    final lat = _latitudeController.text;
    final lng = _longitudeController.text;

   try {
      final response = await http.post(
        Uri.parse('https://example.com/save-coordinates'), // Replace with your API endpoint
        body: {'latitude': lat, 'longitude': lng},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.statusCode == 200 ? 'Coordinates saved successfully!' : 'Failed to save coordinates.')),
        );
      }
    } catch (e) {
      print("Error saving coordinates: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lat/Lng Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _latitudeController,
              decoration: const InputDecoration(labelText: 'Latitude (Decimal Degrees)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _longitudeController,
              decoration: const InputDecoration(labelText: 'Longitude (Decimal Degrees)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            if (_markerPosition != null)
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    center: _markerPosition,
                    zoom: 14,
                  ),
                  children: [
                    TileLayer(
                     urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                            point: _markerPosition!,
                            builder: (ctx) => const Icon(Icons.location_pin, color: Colors.red, size: 40),
                          ),
                        ],
                
              ),
          ],),
                  
        ),]
      ),
    ));
  }
}