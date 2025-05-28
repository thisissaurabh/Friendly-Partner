import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/cart_controller.dart';
import 'package:friendly_partner/controllers/helper_controller.dart';
import 'package:friendly_partner/controllers/home_controller.dart';
import 'package:friendly_partner/controllers/location_controller.dart';
import 'package:friendly_partner/controllers/orders_controller.dart';
import 'package:friendly_partner/controllers/profile_controller.dart';
import 'package:friendly_partner/controllers/user_map_controller.dart';
import 'package:friendly_partner/data/apis/api_client.dart';
import 'package:friendly_partner/data/repo/auth_repo.dart';
import 'package:friendly_partner/data/repo/cart_repo.dart';
import 'package:friendly_partner/data/repo/home_repo.dart';
import 'package:friendly_partner/data/repo/location_repo.dart';
import 'package:friendly_partner/data/repo/profile_repo.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => HomeRepo(
        apiClient: Get.find(),
      ));
  Get.lazyPut(() => ProfileRepo(
        apiClient: Get.find(),
      ));

  Get.lazyPut(() => LocationRepo(
        apiClient: Get.find(),
      ));
  Get.lazyPut(() => CartRepo(
        apiClient: Get.find(),
      ));

  /// Controller

  Get.lazyPut(() =>
      AuthController(authRepo: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => OrdersController());
  Get.lazyPut(() => ProfileController(profileRepo: Get.find()));
  Get.lazyPut(() => UserMapController());
  Get.lazyPut(() => HomeController(homeRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => HelperController());
}
