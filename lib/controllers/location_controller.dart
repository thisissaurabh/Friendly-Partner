import 'dart:convert';
import 'package:friendly_partner/data/repo/location_repo.dart';
import 'package:get/get.dart';

import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController implements GetxService {
  final LocationRepo locationRepo;

  LocationController({
    required this.locationRepo,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GoogleMapController? mapController;
  double? latitude;
  double? longitude;

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle location services disabled
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Handle location permission denied forever
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle location permission denied
        return;
      }
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    latitude = currentPosition.latitude;
    longitude = currentPosition.longitude;

    print('Latitude: $latitude, Longitude: $longitude');

    update();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (latitude != null && longitude != null) {
      print('Moving camera to LatLng: $latitude, $longitude');
      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latitude!, longitude!),
        ),
      );
    } else {
      print('Latitude or Longitude is null');
    }
  }
}
