import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/loading_dialog.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:app_settings/app_settings.dart';

class UserMapController extends GetxController {
  GoogleMapController? mapController;
  double? latitude;
  double? longitude;
  String? address;
  String? locality;

  RxList<Map<String, String>> suggestions = <Map<String, String>>[].obs;
  RxBool isLoading = false.obs; // Loading indicator

  String _selectedAddress = '';
  String get selectedAddress => _selectedAddress;

  String _lat = '';
  String get lat => _lat;

  String _long = '';
  String get long => _long;

  String _addressLine2 = '';
  String get addressLine2 => _addressLine2;
  //
  // final RxnDouble lat = RxnDouble();
  // final RxnDouble long = RxnDouble();

  void selectDirection(String val) {
    _selectedAddress = val;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
  }

  Future<void> getUserLocation() async {

    isLoading.value = true; // Start loading

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLoading.value = false; // Stop loading
      // Get.snackbar(
      //   'Location Services Disabled',
      //   'Please enable location services to continue.',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      isLoading.value = false; // Stop loading
      Get.snackbar(
        'Location Permission Denied',
        'Please enable location permission from settings.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        isLoading.value = false; // Stop loading
        Get.snackbar(
          'Location Permission Denied',
          'Please grant location permission to continue.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          mainButton: TextButton(
            onPressed: () => AppSettings.openAppSettings(), // Open app settings
            child: Text('Open Settings', style: TextStyle(color: Colors.white)),
          ),
        );
        return;
      }
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    latitude = currentPosition.latitude;
    longitude = currentPosition.longitude;
    _lat = currentPosition.latitude.toString();
    _long = currentPosition.longitude.toString();

    await updateAddress();

    isLoading.value = false; // Stop loading
    update();
  }

  Future<void> updateAddress() async {
    if (latitude != null && longitude != null) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude!, longitude!);
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          address =
              '${placemark.street ?? ''}, ${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}';
          _addressLine2 ='${placemark.street ?? ''}, ${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}';
          print('Address =>>>>: $address');
          print('City =>>>>: ${placemark.locality ?? 'Not available'}');
          print(
              'State =>>>>: ${placemark.administrativeArea ?? 'Not available'}');
          print('Locality =>>>> : ${placemark.subLocality ?? 'Not available'}');
        } else {
          print('No placemarks found');
        }
      } catch (e) {
        print("Error occurred while converting coordinates to address: $e");
      }
    } else {
      print('Latitude or Longitude is null');
    }
    update();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    update();
  }

  String apiKey =
      'AIzaSyBNB2kmkXSOtldNxPdJ6vPs_yaiXBG6SSU'; // Replace with your Google API Key

  Future<void> fetchSuggestions(String query) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final List<dynamic> predictions = data['predictions'];
        suggestions.value = predictions.map((prediction) {
          return {
            'description': prediction['description'] as String,
            'place_id': prediction['place_id'] as String,
          };
        }).toList();
      } else {
        suggestions.value = [];
      }
    } else {
      suggestions.value = [];
    }
  }

  Future<void> fetchLocationDetails(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];
        latitude = location['lat'];
        longitude = location['lng'];
        update(); // Update the UI
        await updateAddress(); // Update address based on new location
      }
    }
  }
}
