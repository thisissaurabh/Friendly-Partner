// import 'package:get/get.dart';
// import 'package:get_my_properties/data/api/api_client.dart';
// import 'package:get_my_properties/data/repo/auth_repo.dart';
// import 'package:get_my_properties/data/repo/location_repo.dart';
// import 'package:get_my_properties/data/repo/profile_repo.dart';
// import 'package:get_my_properties/utils/app_constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AppBindings extends Bindings {
//   @override
//   void dependencies() {
//     // Initialize SharedPreferences globally
//     Get.lazyPut(() => SharedPreferences.getInstance());
//
//     // Initialize ApiClient with base URL and SharedPreferences
//     Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));
//
//     // Initialize repositories
//     Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
//     Get.lazyPut(() => ProfileRepo(apiClient: Get.find()));
//     Get.lazyPut(() => LocationRepo(apiClient: Get.find()));
//     // Add more repositories as needed
//   }
// }
