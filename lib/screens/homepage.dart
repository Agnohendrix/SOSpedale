import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:sos_ospedale/models/hospital.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String message = "Premi il pulsante";
  Hospital? nearest;

  Future<void> trovaPosizione() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        message = "GPS disattivato";
      });
      return;
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        message = "Permesso posizione negato";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    nearest = await trovaOspedalePiuVicino(position);

    setState(() {
      message =
      "Ospedale più vicino:\n"
          "${nearest?.nome}\n\n"
          "Lat: ${position.latitude}\n"
          "Lon: ${position.longitude}";
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Ospedale'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_hospital,
                size: 100,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: trovaPosizione,
                child: const Text("TROVA ORA"),
              ),
              const SizedBox(height: 20),
              if(nearest != null)
                ElevatedButton.icon(
                  onPressed: avviaNavigazione,
                  icon: const Icon(Icons.navigation),
                  label: const Text('NAVIGA'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Hospital>> loadHospitals() async {
    final jsonString =
    await rootBundle.loadString('assets/pronto_soccorso.json');

    final List<dynamic> data = json.decode(jsonString);

    return data.map((e) => Hospital.fromJson(e)).toList();
  }

  Future<Hospital?> trovaOspedalePiuVicino(
      Position posizione,
      ) async {
    final hospitals = await loadHospitals();

    Hospital? nearest;
    double minDistance = double.infinity;

    for (final hospital in hospitals) {
      double distance = Geolocator.distanceBetween(
        posizione.latitude,
        posizione.longitude,
        hospital.lat,
        hospital.lon,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearest = hospital;
      }
    }

    return nearest;
  }

  Future<void> avviaNavigazione() async {
    if(nearest == null) return;

    final Uri uri = Uri.parse(
      'geo:${nearest!.lat},${nearest!.lon}?q=${nearest!.lat},${nearest!.lon}',
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

}
