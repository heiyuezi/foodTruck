import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'about_screen.dart'; // Make sure this file exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FoodTruckApp());
}

class FoodTruckApp extends StatelessWidget {
  const FoodTruckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Truck Tracker',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _listenToFirebase();
  }

  void _listenToFirebase() {
    final dbRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://foodtrucktrack-c225a-default-rtdb.asia-southeast1.firebasedatabase.app',
    ).ref('foodtrucks');

    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final Set<Marker> newMarkers = {};

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            final type = value['type'] ?? 'Unknown';
            final locationDesc = value['locationDesc'] ?? 'No location';
            final reportedBy = value['reportedBy'] ?? 'Anonymous';
            final updatedAt = value['updatedAt'] ?? '';
            final double? lat = _parseDouble(value['latitude']);
            final double? lng = _parseDouble(value['longitude']);

            if (lat != null && lng != null) {
              final position = LatLng(lat, lng);
              final formattedTime = _formatTimestamp(updatedAt);

              // Shorten long strings to prevent cutoff in the UI
              final shortReportedBy = _shorten(reportedBy, 20);
              final shortLocation = _shorten(locationDesc, 25);

              newMarkers.add(
                Marker(
                  markerId: MarkerId(key),
                  position: position,
                  infoWindow: InfoWindow(
                    title: '$type (by $shortReportedBy)',
                    snippet: 'On $formattedTime\nAt: $shortLocation',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                ),
              );
            }
          }
        });

        setState(() {
          _markers
            ..clear()
            ..addAll(newMarkers);
        });
      }
    });
  }

  double? _parseDouble(dynamic val) {
    if (val is double) return val;
    if (val is int) return val.toDouble();
    if (val is String) return double.tryParse(val);
    return null;
  }

  String _formatTimestamp(String ts) {
    try {
      final dt = DateTime.parse(ts);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return ts;
    }
  }

  String _shorten(String text, [int max = 25]) {
    return text.length > max ? '${text.substring(0, max)}...' : text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Truck Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(6.4444, 100.2760), // UiTM Arau
          zoom: 14,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
