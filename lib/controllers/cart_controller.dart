import 'dart:convert';
import 'dart:developer';

import 'package:friendly_partner/app/screens/dashboard/dashboard.dart';
import 'package:friendly_partner/app/widgets/custom_snackbar.dart';
import 'package:friendly_partner/app/widgets/loading_dialog.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/data/repo/auth_repo.dart';
import 'package:friendly_partner/data/repo/cart_repo.dart';
import 'package:friendly_partner/data/repo/home_repo.dart';
import 'package:friendly_partner/helper/route_helper.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../app/screens/orders/order_successful.dart';
import '../utils/images.dart';
class CartController extends GetxController {
  final CartRepo cartRepo;

  CartController({
    required this.cartRepo,
  });
  @override
  void onInit() {
    super.onInit();
    loadCartFromPrefs();
  }
  // Map<String, dynamic>? _shopProducts;
  // Map<String, dynamic>? get shopProducts => _shopProducts;


  String _selectedPinCode = '';
  String get selectedPinCode => _selectedPinCode;

  void selectPinCode(String val) {
    _selectedPinCode = val;
    update();
  }

  String _selectedAddressId = '';
  String get selectedAddressId => _selectedAddressId;

  void selectAddressId(String val) {
    _selectedAddressId = val;
    update();
  }




  Future<void> addToCartApi({required String productId}) async {
    try {
      LoadingDialog.showLoading();
      update();
      Response response = await cartRepo.addToCarturl(productId: productId);
      print('📥 Raw headers addToCartApi: ${response.headers}');
      print('📥 Raw response addToCartApi: ${response.bodyString}');
      print('📡 Status code addToCartApi: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;
        addProduct(productId);
        print('✅ Response data addToCartApi: $responseData');
      } else {
        showCustomSnackBar(Get.context!, "Sorry! product cart quantity is limited. No more stock", isError: true);
      }
    } catch (e) {
      print('🚨 Exception during login: $e');
      showCustomSnackBar(Get.context!, "Sorry! product cart quantity is limited. No more stock", isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }

  Future<void> cartIncrementApi({required String productId}) async {
    try {
      // LoadingDialog.showLoading();
      // update();
      Response response =
          await cartRepo.addToCartIncrementurl(productId: productId);
      print('📥 Raw headers cartIncrementApi: ${response.headers}');
      print('📥 Raw response cartIncrementApi: ${response.bodyString}');
      print('📡 Status code cartIncrementApi: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;
      increment(productId);
        print('✅ Response data cartIncrementApi: $responseData');
      } else {
        showCustomSnackBar(Get.context!, "Sorry! product cart quantity is limited. No more stock", isError: true);
        // showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print('🚨 Exception during login : $e');
      showCustomSnackBar(Get.context!, "Sorry! product cart quantity is limited. No more stock", isError: true);
      // showCustomSnackBar(Get.context!, 'Something went wrong: $e',
      //     isError: true);
    } finally {
      // LoadingDialog.hideLoading();
      update();
    }
  }

  Future<void> minusRemoveIncrementApi({required String productId}) async {
    try {
      // LoadingDialog.showLoading();
      // update();
      Response response =
          await cartRepo.minusRemoveIncrement(productId: productId);
      print('📥 Raw headers minusRemoveIncrementApi: ${response.headers}');
      print('📥 Raw response minusRemoveIncrementApi: ${response.bodyString}');
      print('📡 Status code minusRemoveIncrementApi: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;
     decrement(productId);
        print('✅ Response data minusRemoveIncrementApi: $responseData');
      } else {
        // showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print('🚨 Exception during login : $e');
      showCustomSnackBar(Get.context!, 'Something went wrong: $e',
          isError: true);
    } finally {
      // LoadingDialog.hideLoading();
      update();
    }
  }

  Future<void> deleteCartApi({required String productId}) async {
    try {
      // LoadingDialog.showLoading();
      // update();
      Response response =
      await cartRepo.deleteCartUrl(productId: productId);
      print('📥 Raw headers deleteCartApi : ${response.headers}');
      print('📥 Raw response deleteCartApi : ${response.bodyString}');
      print('📡 Status code deleteCartApi : ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;
        cartItems.remove(productId);
        saveCartToPrefs();
        // ✅ Refresh cart list
        await getCartList();

        update();
        print('✅ Response data deleteCartApi: $responseData');
      } else {
        await getCartList();
        update();
        // showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      await getCartList();
      update();
      print('🚨 Exception during login : $e');
      // showCustomSnackBar(Get.context!, 'Something went wrong: $e',
      //     isError: true);
    } finally {
      // LoadingDialog.hideLoading();
      update();
    }
  }


  Future<void> saveCartToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart_items', jsonEncode(cartItems));
  }

  Future<void> loadCartFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('cart_items');
    if (jsonString != null) {
      Map<String, dynamic> map = jsonDecode(jsonString);
      cartItems.value = map.map((key, value) => MapEntry(key, value as int));
      update();
    }
  }


  Future<void> clearCartFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart_items');
    cartItems.clear();
    update(); // if you're using GetX
  }


  var cartItems = <String, int>{}.obs; // key: productId, value: quantity

  void addProduct(String productId) {
    cartItems[productId] = 1;
    // addToCartApi(productId: productId);
    saveCartToPrefs();
    getCartList(true);
    update();
  }

  void increment(String productId) {
    if (cartItems.containsKey(productId)) {
      cartItems[productId] = cartItems[productId]! + 1;
      saveCartToPrefs();
      getCartList(true);
      update();
    }
  }

  void decrement(String productId) {
    if (cartItems.containsKey(productId) && cartItems[productId]! > 1) {
      cartItems[productId] = cartItems[productId]! - 1;
    } else {
      cartItems.remove(productId);
    }

    saveCartToPrefs();
    getCartList(true);
    update();
  }

  int getQuantity(String productId) {
    return cartItems[productId] ?? 0;
  }

  Map<String, dynamic>? _cart;
  Map<String, dynamic>? get cart => _cart;

  Future<void> getCartList([bool isHideLoader = false]) async {
    try {

      if (!isHideLoader) LoadingDialog.showLoading();
      update();

      print("🔥 Calling getCartList API...");
      Response response = await cartRepo.getCartList();

      print("📥 Full response getCartList: ${response.bodyString}");
      print("📡 Status code getCartList: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseData = response.body;

        // ✅ Assign entire data map to _cart
        _cart = responseData["data"] ?? {};

        print("🎯 Total Shops in Cart: ${_cart?["cart_items"]?.length ?? 0}");
      } else {
        print("❌ Non-200 response");
        var responseData = response.body;
        // showCustomSnackBar(
        //   Get.context!,
        //   responseData["message"] ?? 'Error fetching getCartList',
        //   isError: true,
        // );
      }
    } catch (e) {
      print("🚨 Exception: $e");
      // showCustomSnackBar(Get.context!, 'Something went wrong: $e',
      //     isError: true);
    } finally {
      if (!isHideLoader) LoadingDialog.hideLoading();
      // LoadingDialog.hideLoading();
      update(); // This will notify GetBuilder listeners
    }
  }


  Map<String, dynamic>? _cartCheckout;
  Map<String, dynamic>? get cartCheckout => _cartCheckout;



  Future<void> getCheckoutCart({required List<dynamic> shopIds}) async {
    var url = Uri.parse('${AppConstants.baseUrl}${AppConstants.cartCheckoutUrl}');

    var token = Get.find<AuthController>().getUserToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var body = json.encode({
      "shop_ids": shopIds,
    });

    log('--- API CALL: Checkout Cart ---');
    log('URL getCheckoutCart: $url');
    log('Token getCheckoutCart: $token');
    log('Headers getCheckoutCart: $headers');
    log('Body getCheckoutCart:  $body');

    try {
      var response = await http.post(url, headers: headers, body: body);

      log('--- API RESPONSE getCheckoutCart ---');
      log('Status Code getCheckoutCart: ${response.statusCode}');
      log('Response Body getCheckoutCart: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        /// ✅ Save only the `data` part (you can choose the whole thing if needed)
        _cartCheckout = jsonData['data'];

     update();
      } else {
        log('Error getCheckoutCart: ${response.statusCode}');
        log('Message getCheckoutCart: ${response.body}');
      }
    } catch (e) {
      log('Exception occurred getCheckoutCart: $e');
    }
  }


  bool _isCheckingPinCodeLoading = false;
  bool get isCheckingPinCodeLoading => _isCheckingPinCodeLoading;


  Map<String, dynamic>? _checkPinCode;
  Map<String, dynamic>? get checkPinCode => _checkPinCode;

  Future<void> getCheckPinCodeList({required String pinCode}) async {
    try {
      _isCheckingPinCodeLoading = true;
      update();
      print("🔥 Calling getCheckPincodeList API...");
      Response response = await cartRepo.getCheckPinCode(pincode: pinCode);
      print("📥 Full response getCheckPincodeList: ${response.bodyString}");
      print("📡 Status code getCheckPincodeList: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseData = response.body;
        _checkPinCode = responseData["data"]["pincode"];
        print("🎯 Total Shops in getCheckPincodeList: ${_checkPinCode}");
        _isCheckingPinCodeLoading = false;
        update();
      } else {
        print("❌ Non-200 response getCheckPincodeList");
        _isCheckingPinCodeLoading = false;
        update();
      }
    } catch (e) {
      print("🚨 Exception getAddgetCheckPincodeListressList: $e");
      _isCheckingPinCodeLoading = false;
      update();
    } finally {
      _isCheckingPinCodeLoading = false;
      update();
    }

  }





  Future<void> placeOrderApi({
    required List<dynamic> shopIds,
    required String addressId,
    required String note,
    required String paymentMethod,
    required String couponCode,
  }) async {
    var url = Uri.parse('${AppConstants.baseUrl}${AppConstants.placeOrder}');
    var token = Get.find<AuthController>().getUserToken();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var bodyMap = {
      "shop_ids": shopIds,
      "address_id": addressId,
      "note": note,
      "payment_method": paymentMethod,
      "coupon_code": couponCode,
    };

    var body = json.encode(bodyMap);

    log('📡 --- API CALL: placeOrderApi ---');
    log('🌐 URL: $url');
    log('🔐 Token: $token');
    log('🧾 Headers: $headers');
    log('📦 Request Body (Raw JSON): $body');
    log('🔍 Request Body (Decoded):');
    bodyMap.forEach((key, value) => log('  ➤ $key: $value'));

    try {
      var response = await http.post(url, headers: headers, body: body);

      log('📥 --- API RESPONSE: placeOrderApi ---');
      log('📊 Status Code: ${response.statusCode}');
      log('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final message = responseData["message"];
        if (message == "Order created successfully") {
          log('✅ FULL SUCCESS RESPONSE: $responseData'); // ✅ Print full response
          LoadingGif.showLoading(message: "Order Placed Successfully", lottie: Images.lottieSuccess);
          await Future.delayed(const Duration(seconds: 3));
          LoadingGif.hideLoading();
          clearCartFromPrefs();
           await  Get.to(() => OrderSuccessful(orderId: '',));
          update();

        }

      } else {
        LoadingGif.showLoading(message: "Order Failed Please Try Again Later", lottie: Images.lottieFailed);
        await Future.delayed(const Duration(seconds: 3));
        LoadingGif.hideLoading();
        update();
        log('❌ Error occurred while placing order.');
      }

    } catch (e) {
      LoadingGif.showLoading(message: "Order Failed Please Try Again Later", lottie: Images.lottieFailed);
      await Future.delayed(const Duration(seconds: 3));
      LoadingGif.hideLoading();
      update();
    }
  }



}
