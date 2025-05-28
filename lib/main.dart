import 'dart:io';
import 'package:flutter/material.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/user_map_controller.dart';
import 'package:friendly_partner/data/apis/api_client.dart';
import 'package:friendly_partner/data/repo/auth_repo.dart';
import 'package:friendly_partner/helper/route_helper.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper/gi_dart.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  HttpOverrides.global = MyHttpOverrides();
  Get.put(ApiClient(
      appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));
  Get.put(AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(AuthController(authRepo: Get.find(), sharedPreferences: Get.find()));
  Get.put(UserMapController());
  // await Firebase.initializeApp();
  //
  // Location location = new Location();
  // bool _serviceEnabled;
  //
  //
  // try {
  //   // Request location permission
  //   final permissionStatus = await Permission.locationAlways.request();
  //   if (!permissionStatus.isGranted) {
  //     debugPrint('Location permission denied');
  //     await Permission.location.request();
  //     // return;
  //   }
  //
  //   // Check if the location service is enabled
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       debugPrint('Location Service not enabled');
  //     }
  //   }
  // } catch (e) {
  //   debugPrint('Error checking location service: $e');
  // }

  await di.init();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final NotificationService _notificationService = NotificationService();
  @override
  void initState() {
    super.initState();
    // _notificationService.initialize();
    // _notificationService.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: light,
      initialRoute: RouteHelper.getInitialRoute(),
      getPages: RouteHelper.routes,
      defaultTransition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),
      builder: (BuildContext context, widget) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!);
      },
    );
  }
}
