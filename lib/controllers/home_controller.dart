import 'package:friendly_partner/app/screens/dashboard/dashboard.dart';
import 'package:friendly_partner/app/widgets/custom_snackbar.dart';
import 'package:friendly_partner/app/widgets/loading_dialog.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/profile_controller.dart';
import 'package:friendly_partner/data/repo/auth_repo.dart';
import 'package:friendly_partner/data/repo/home_repo.dart';
import 'package:friendly_partner/helper/route_helper.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final HomeRepo homeRepo;

  HomeController({
    required this.homeRepo,
  });
  var selectedButton = ''; // Use RxString for observable string

  void selectButton(String buttonName) {
    selectedButton = buttonName;
    update(); // Use update() to notify listeners
  }

  //You can use this to set the initial value.
  @override
  void onInit() {
    super.onInit();
    selectedButton = 'Wholesaler'; // Or any default value
  }

  Map<String, dynamic>? _retailerHomeData;
  Map<String, dynamic>? get retailerHomeData => _retailerHomeData;

  Future<void> getHomeData() async {
    print(
        'Fetching getHomeData ================> ${Get.find<AuthController>().getUserid()}');
    LoadingDialog.showLoading();

    try {
      Response response = await homeRepo.getRetailerHomeRepo(
          retailerId: Get.find<AuthController>().getUserid()!);

      if (response.statusCode == 200) {
        final data = response.body;
        _retailerHomeData = data['data'];

        print('Check Retails : ${_retailerHomeData}');
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }




  Map<String, dynamic>? _wholeSellerHomeData;
  Map<String, dynamic>? get wholeSellerHomeData => _wholeSellerHomeData;

  Future<void> getWholeSellerHomeData() async {
    print(
        'Fetching getHomeData ================> ${Get.find<AuthController>().getUserid()}');
    LoadingDialog.showLoading();

    try {
      Response response = await homeRepo.getWholeSellerHomeRepo();

      if (response.statusCode == 200) {
        final data = response.body;
        _wholeSellerHomeData = data['data'];

        print('Check Retails : ${_wholeSellerHomeData}');
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }

  List<dynamic>? _nonConnectedWholeSellerList;
  List<dynamic>? get nonConnectedWholeSellerList => _nonConnectedWholeSellerList;

  Future<void> getNonConnectedWholeSellerShopApi() async {
    try {

      LoadingDialog.showLoading();
      update();

      Response response = await homeRepo.getNonConnectedWholeSellerHomeRepo();

      print("📥 Full response getNonConnectedWholeSellerShopApi: ${response.bodyString}");
      print("📡 Status code getNonConnectedWholeSellerShopApi: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["shop"] != null) {
          List<dynamic> data = responseData["data"]["shop"];
          print("🎯 getNonConnectedWholeSellerShopApi Length : ${data.length}");
          _nonConnectedWholeSellerList = data;

          update();
        } else {
          print("🚫 No getNonConnectedWholeSellerShopApi in response");
          _nonConnectedWholeSellerList = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body getNonConnectedWholeSellerShopApi");
        final message =
            response.body?["message"] ?? "Error fetching search results";
        showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print("🚨 Exception getSearchShopApi: $e");
      showCustomSnackBar(
          Get.context!, 'Something went wrong _searchShopList: $e',
          isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }

}
