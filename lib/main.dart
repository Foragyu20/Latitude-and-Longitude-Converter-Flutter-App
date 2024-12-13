import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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


void _convertToDMS() {
    double latitude = double.parse(_latitudeController.text);
    double longitude = double.parse(_longitudeController.text);

    setState(() {
      _convertedCoords = "${_toDMS(latitude, 'N', 'S')}, ${_toDMS(longitude, 'E', 'W')}";
      _markerPosition = LatLng(latitude, longitude);
    })
   String _toDMS(double value, String posDir, String negDir) {
    final direction = value >= 0 ? posDir : negDir;
    value = value.abs();
    final degrees = value.floor();
    final minutes = ((value - degrees) * 60).floor();
    final seconds = (((value - degrees) * 60 - minutes) * 60).floor();
    return '$degrees° $minutes\' $seconds" $direction';
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
          ],
        ),
      ),
    );
  }
}

