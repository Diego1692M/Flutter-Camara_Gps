import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1Ijoib3J0aXpqMDEiLCJhIjoiY2x1cG94YWs0MW9qbjJxb2FzMHh1MXpkZCJ9.oZnsfbMItbdn9mFg35JIeg';

class GeolocalizadorScreen extends StatefulWidget {
  const GeolocalizadorScreen({super.key});

  @override
  State<GeolocalizadorScreen> createState() => _GeolocalizadorScreenState();
}

class _GeolocalizadorScreenState extends State<GeolocalizadorScreen> {
  LatLng? myPosition;

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      myPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mapa'),
        ),
        body: myPosition == null
            ? const Center(child: CircularProgressIndicator())
            : FlutterMap(
                options: MapOptions(
                    center: myPosition, minZoom: 5, maxZoom: 18, zoom: 18),
                nonRotatedChildren: [
                  TileLayer(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                    additionalOptions: const {
                      'accessToken': MAPBOX_ACCESS_TOKEN,
                      'id': 'mapbox/streets-v12'
                    },
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                          point: myPosition!,
                          builder: (context) {
                            return const Icon(
                              Icons.person_pin_rounded,
                              color: Color.fromARGB(255, 50, 58, 116),
                              size: 40,
                            );
                          })
                    ],
                  )
                ],
              ));
  }
}
