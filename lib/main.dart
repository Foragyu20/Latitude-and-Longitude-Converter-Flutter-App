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
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

}
