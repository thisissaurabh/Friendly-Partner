// import 'package:location/location.dart';
//
// class LocationService {
//   final Location _location = Location();
//
//   Future<bool> requestPermission() async {
//     final permission = await _location.requestPermission();
//     return permission == PermissionStatus.granted;
//   }
//
//   Future<LocationData?> getCurrentLocation() async {
//     bool serviceEnabled = await _location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _location.requestService();
//       if (!serviceEnabled) {
//         // Service not enabled; handle accordingly
//         return null;
//       }
//     }
//
//     final permission = await _location.hasPermission();
//     if (permission == PermissionStatus.denied) {
//       final granted = await _location.requestPermission();
//       if (granted != PermissionStatus.granted) {
//         // Permission not granted; handle accordingly
//         return null;
//       }
//     }
//
//     return await _location.getLocation();
//   }
// }
