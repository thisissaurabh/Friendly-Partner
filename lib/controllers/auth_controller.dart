import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friendly_partner/app/screens/auth/signin_dashboard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:friendly_partner/app/screens/dashboard/dashboard.dart';
import 'package:friendly_partner/app/widgets/custom_snackbar.dart';
import 'package:friendly_partner/app/widgets/loading_dialog.dart';
import 'package:friendly_partner/data/repo/auth_repo.dart';
import 'package:friendly_partner/helper/route_helper.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class AuthController extends GetxController {
  final AuthRepo authRepo;
  final SharedPreferences sharedPreferences;
  AuthController({
    required this.authRepo,
    required this.sharedPreferences,
  });

  DateTime? lastBackPressTime;

  Future<bool> handleOnWillPop() async {
    final now = DateTime.now();

    if (lastBackPressTime == null || now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
      updateLastBackPressTime(now);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      SystemNavigator.pop();
      return Future.value(false);
    }
    return Future.value(true);
  }

  void updateLastBackPressTime(DateTime time) {
    lastBackPressTime = time;
    update();
  }

  DateTime? _lastBackPressTime;

  Future<bool> willPopCallback() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      Get.showSnackbar(
        GetSnackBar(
          message: 'Press back again to exit',
          duration: Duration(seconds: 2),
        ),
      );
      return Future.value(false);
    }
    SystemNavigator.pop(); // Closes the app
    update();
    return Future.value(true);
  }


  var selectedButton = 'Wholesaler';

  void selectButton(String buttonName) {
    selectedButton = buttonName;
    update();
  }

  var address = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddress(); // Load the address when the controller is initialized

  }

  int _loginType = 0;
  int get loginType => _loginType;

  void selectLoginType(int index) {
    _loginType = index;
    print(loginType);
    update();
  }


  bool isWholeSellerLogin() {
    return isLoggedIn() && authRepo.getLoginType() == 0;
  }

  bool isRetailerLogin() {
    return isLoggedIn() && authRepo.getLoginType() == 1;
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  Future<void> saveLatitude(double latitude) async {
    await sharedPreferences.setDouble(AppConstants.latitude, latitude);
  }

  double? getLatitude() {
    return sharedPreferences.getDouble(AppConstants.latitude);
  }

  Future<void> saveUserId(String userId) async {
    await sharedPreferences.setString(AppConstants.userId, userId);
  }

  String? getUserid() {
    return sharedPreferences.getString(AppConstants.userId);
  }

  Future<void> saveLongitude(double latitude) async {
    await sharedPreferences.setDouble(AppConstants.longitude, latitude);
  }

  double? getLongitude() {
    return sharedPreferences.getDouble(AppConstants.longitude);
  }

  Future<void> saveAddress(String address) async {
    await sharedPreferences.setString(AppConstants.address, address);
    update();
  }

  String? getSaveAddress() {
    return sharedPreferences.getString(AppConstants.address);
  }

  Future<void> saveHomeAddress(String newAddress) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(AppConstants.address, newAddress);
    address.value = newAddress; // Update the RxString value
  }

  Future<void> loadAddress() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? savedAddress = sharedPreferences.getString(AppConstants.address);
    if (savedAddress != null) {
      address.value = savedAddress; // Update the RxString value
    }
  }

  Future<bool> saveLoginType(
    String token,
  ) async {
    return await sharedPreferences.setString(AppConstants.loginType, token);
  }

  String getLoginType() {
    return sharedPreferences.getString(AppConstants.loginType) ?? "";
  }



  Future<void> loginApi(String username, String password) async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await authRepo.login(username, password);
      print('📥 Raw headers: ${response.headers}');
      print('📥 Raw response: ${response.bodyString}');
      print('📡 Status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        print('✅ Response data: $responseData');

        if (responseData["message"] == "Login successfully") {
          var token = responseData['data']?['access']?['token'];
          var userId = responseData['data']?['user']?['id'];
          print('🔑 Token: $token');

          if (token != null) {
            authRepo.saveUserToken(token);
          saveUserId(userId.toString());
   await authRepo.saveLoginType(1);

            print("cehck");
            LoadingDialog.hideLoading();
            await Get.toNamed(RouteHelper.getDashboardRoute());
            update();
          } else {
            print('⚠️ Token not found in response');
            showCustomSnackBar(Get.context!, 'Token not found in response',
                isError: true);
          }
        } else {
          print('❌ Unexpected login message: ${responseData["message"]}');
          showCustomSnackBar(
              Get.context!, responseData["message"] ?? 'Login failed',
              isError: true);
        }
      } else {
        print('❗ Non-200 response or null body');
        var message = response.body != null &&
                response.body is Map &&
                response.body['message'] != null
            ? response.body['message']
            : 'Login failed, Invalid Credentials';
        showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print('🚨 Exception during login: $e');
      showCustomSnackBar(Get.context!, 'Something went wrong: $e',
          isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }


  // Future<void> registerApi({required String name, required String email, required String password}) async {
  //   try {
  //     LoadingDialog.showLoading();
  //     update();
  //
  //     Response response = await authRepo.register(name: name, email: email, password: password);
  //     print('📥 Raw headers: ${response.headers}');
  //     print('📥 Raw response: ${response.bodyString}');
  //     print('📡 Status code: ${response.statusCode}');
  //
  //     if (response.statusCode == 200 && response.body != null) {
  //       var responseData = response.body;
  //
  //       print('✅ Response data: $responseData');
  //
  //       if (responseData["message"] == "address created successfully") {
  //
  //         LoadingDialog.hideLoading();
  //         showCustomSnackBar(Get.context!, "Address Added");
  //         // await Get.toNamed(RouteHelper.getSigningRoute());
  //         update();
  //       } else {
  //
  //         // showCustomSnackBar(
  //         //     Get.context!,'New Account Registration Currently not Available',
  //         //     isError: true);
  //       }
  //     } else {
  //       // showCustomSnackBar(
  //       //     Get.context!,'New Account Registration Currently not Available',
  //       //     isError: true);
  //     }
  //   } catch (e) {
  //     print('🚨 Exception during login: $e');
  //     showCustomSnackBar(Get.context!, 'Something went wrong: $e',
  //         isError: true);
  //   } finally {
  //     LoadingDialog.hideLoading();
  //     update();
  //   }
  // }


  Future<void> registerApi({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await authRepo.register(
        name: name,
        email: email,
        password: password,
      );

      print('📥 Raw headers: ${response.headers}');
      print('📥 Raw response: ${response.bodyString}');
      print('📡 Status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        print('✅ Response data: $responseData');

        if (responseData["message"] == "Registration successfully complete") {
          print("cehckw");
          LoadingDialog.hideLoading();
          showCustomSnackBar(Get.context!, "Account Created Successfully");
         await Get.to(() => SigningDashboard());
          update();

        } else {
          print("cehck");
          showCustomSnackBar(Get.context!, 'Currently Account Creation is Disabled', isError: true);
        }
      } else {
        final responseData = response.body;
        print('❌ Validation errors: $responseData');

        if (responseData != null && responseData['errors'] != null) {
          Map<String, dynamic> errors = responseData['errors'];
          String errorMessages = errors.values
              .map((e) => (e as List).join(', '))
              .join('\n');

          showCustomSnackBar(Get.context!, errorMessages, isError: true);
        } else {
          showCustomSnackBar(Get.context!, 'Registration failed', isError: true);
        }
      }
    } catch (e) {
      print('🚨 Exception during registration: $e');
      showCustomSnackBar(Get.context!, 'Something went wrong: $e', isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }



  Future<dynamic> addWholeSeller({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String gender,
    required String password,
    required String confirmPassword,
    required String shopName,
    required String address,
    required XFile? profilePhoto,
    required XFile? shopLogo,
    required XFile? shopBanner,
  }) async {
    print('🔁 Starting addWholeSeller');

    LoadingDialog.showLoading();
    update();

    var headers = {
      'Cookie': 'XSRF-TOKEN=your_xsrf_token; readycommerce_session=your_session_token',
    };

    var url = Uri.parse('${AppConstants.baseUrl}wholeseller/register');
    var request = http.MultipartRequest('POST', url);

    // Fields
    request.fields.addAll({
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'Gender': gender,
      'password': password,
      'password_confirmation': confirmPassword,
      'shop_name': shopName,
      'address' : address
    });


    if (profilePhoto != null && profilePhoto.path.isNotEmpty) {
      String ext = profilePhoto.path.split('.').last;
      print('📸 Attaching profile_photo: ${profilePhoto.path}');
      request.files.add(await http.MultipartFile.fromPath(
        'profile_photo',
        profilePhoto.path,
        contentType: MediaType('image', ext),
      ));
    }

    if (shopLogo != null && shopLogo.path.isNotEmpty) {
      String ext = shopLogo.path.split('.').last;
      print('🖼️ Attaching shop_logo: ${shopLogo.path}');
      request.files.add(await http.MultipartFile.fromPath(
        'shop_logo',
        shopLogo.path,
        contentType: MediaType('image', ext),
      ));
    }

    if (shopBanner != null && shopBanner.path.isNotEmpty) {
      String ext = shopBanner.path.split('.').last;
      print('🖼️ Attaching shop_banner: ${shopBanner.path}');
      request.files.add(await http.MultipartFile.fromPath(
        'shop_banner',
        shopBanner.path,
        contentType: MediaType('image', ext),
      ));
    }

    request.headers.addAll(headers);

    // Debug Logs
    print('🌐 Request URL: ${request.url}');
    print('📡 Request Method: ${request.method}');
    print('🧾 Request Headers: ${jsonEncode(request.headers)}');
    print('📝 Request Fields: ${jsonEncode(request.fields)}');
    print('📂 Request Files: ${request.files.map((f) => f.filename).toList()}');

    try {
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('📥 Response Status: ${response.statusCode}');
      print('📦 Response Body: $responseBody');

      if (response.statusCode == 200) {
        showCustomSnackBar(Get.context!, "Account Created Successfully you will be notified when your account gets Approved");
        Get.back();
        update();
        return jsonDecode(responseBody);
      } else {
        print('❌ API Error: ${response.reasonPhrase}');
        // Get.back();
        print('❌ API Error: ${response.reasonPhrase}');

        // Parse the response body
        final Map<String, dynamic> errorResponse = jsonDecode(responseBody);

        String errorMessage = 'Something went wrong';


        if (errorResponse.containsKey('errors') && errorResponse['errors'] is Map) {
          final firstKey = (errorResponse['errors'] as Map).keys.first;
          final firstError = errorResponse['errors'][firstKey][0];
          errorMessage = firstError;
        } else if (errorResponse.containsKey('message')) {
          errorMessage = errorResponse['message'];
        }

        showCustomSnackBar(Get.context!, errorMessage);
        update();
        return false;
      }
    } catch (e) {
      print('⚠️ Exception: $e');
      Get.back();
      update();
      return false;
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }




  Future<void> wholeSellerLoginApi(String email, String password) async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await authRepo.loginWholeSeller(email, password);
      print('📥 Raw headers: ${response.headers}');
      print('📥 Raw response: ${response.bodyString}');
      print('📡 Status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;
        print('✅ Response data: $responseData');

        final message = responseData["message"];

        if (message == "Login successfully") {
          var token = responseData['data']?['access']?['token'];
          var userId = responseData['data']?['user']?['id'];
          print('🔑 Token: $token');

          if (token != null) {
            authRepo.saveUserToken(token);
            saveUserId(userId.toString());
            await authRepo.saveLoginType(0);
            LoadingDialog.hideLoading();
            await Get.toNamed(RouteHelper.getWholeSellerDashboardRoute());
            update();
          } else {
            print('Token missing in response');
            showCustomSnackBar(Get.context!, 'Token not found in response', isError: true);
          }
        } else {
          // Message is present but not a successful login
          print(' Login failed message: $message');
          showCustomSnackBar(Get.context!, message ?? 'Login failed', isError: true);
        }
      } else {
        // Handle error with status != 200 or body has error status
        var errorMessage = 'Login failed. Please try again.';

        if (response.body != null && response.body is Map) {
          var body = response.body;

          // Case 1: Message like "Your account is not active..."
          if (body['message'] != null && body['status'] != 'error') {
            errorMessage = body['message'];
          }

          // Case 2: Validation error structure
          else if (body['status'] == 'error' &&
              body['errors'] != null &&
              body['errors'] is Map) {
            Map errors = body['errors'];
            var firstField = errors.keys.first;
            var errorList = errors[firstField];
            if (errorList is List && errorList.isNotEmpty) {
              errorMessage = errorList[0];
            }
          }

          else if (body['message'] != null) {
            errorMessage = body['message'];
          }
        }

        print('Login error: $errorMessage');
        showCustomSnackBar(Get.context!, errorMessage, isError: true);
      }
    } catch (e) {
      print('Exception during login: $e');
      showCustomSnackBar(Get.context!, 'Something went wrong: $e', isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }




  List<dynamic>? _addressList;
  List<dynamic>? get addressList => _addressList;

  Future<void> getAddressList([bool isHideLoader = false]) async {
    try {

      if (!isHideLoader) LoadingDialog.showLoading();
      update();

      print("🔥 Calling getAddressList API...");
      Response response = await authRepo.getAddressList();

      print("📥 Full response getAddressList: ${response.bodyString}");
      print("📡 Status code getAddressList: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseData = response.body;

        // ✅ Assign entire data map to _cart
        _addressList = responseData["data"]["addresses"];

        print("🎯 Total Shops in getAddressList: ${_addressList}");
      } else {
        print("❌ Non-200 response getAddressList");
        var responseData = response.body;
        // showCustomSnackBar(
        //   Get.context!,
        //   responseData["message"] ?? 'Error fetching getCartList',
        //   isError: true,
        // );
      }
    } catch (e) {
      print("🚨 Exception getAddressList: $e");
      // showCustomSnackBar(Get.context!, 'Something went wrong: $e',
      //     isError: true);
    } finally {
      if (!isHideLoader) LoadingDialog.hideLoading();
      // LoadingDialog.hideLoading();
      update(); // This will notify GetBuilder listeners
    }



  }

  int? _selectedAddressIndex;
  int? get selectedAddressIndex => _selectedAddressIndex;

  void selectAddress(int index) {
    _selectedAddressIndex = index;
    update(); // triggers GetBuilder to rebuild
  }
  Future<void> addAddressApi({
    required String name,
    required String phone,
    required String area,
    required String flatNo,
    required String postCode,
    required String address,
    required String addressType,
    required String addressLine2,
    required String longitude,
    required String latitude,
  }) async {
    try {
      LoadingDialog.showLoading();
      update();

      // Printing request body fields before making the API call
      print("📤 Request body fields:");
      print("Name: $name");
      print("Phone: $phone");
      print("Area: $area");
      print("Flat No: $flatNo");
      print("Postal Code: $postCode");
      print("Address: $address");
      print("Address Type: $addressType");
      print("Address Line 2: $addressLine2");
      print("Longitude: $longitude");
      print("Latitude: $latitude");

      Response response = await authRepo.addAddressRepo(
        name: name,
        phone: phone,
        area: area,
        flatNo: flatNo,
        postCode: postCode,
        address: address,
        addressType: addressType,
        longitude: longitude,
        latitude: latitude,
        addressLine2: addressLine2,
      );

      print('📥 Raw headers addAddressApi: ${response.headers}');
      print('📥 Raw response addAddressApi: ${response.bodyString}');
      print('📡 Status code addAddressApi: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;
        print('✅ Response data addAddressApi: $responseData');
        if (responseData["message"] == "address created successfully") {
          LoadingDialog.hideLoading();
          await getAddressList();
          showCustomSnackBar(Get.context!, "Address Added Successfully.");
          update();
        } else {
          print("❌ Failed to create address. Response message: ${responseData["message"]}");
        }
      } else {
        print("❌ Error: Status code ${response.statusCode}");
      }
    } catch (e) {
      print('🚨 Exception during address creation: $e');
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }

  // Future<void> deleteAddress({required String addressId}) async {
  //   try {
  //
  //     LoadingDialog.showLoading();
  //     update();
  //
  //     print("🔥 Calling deleteAddress API...");
  //     Response response = await authRepo.deleteAddress(id: addressId);
  //
  //     print("📥 Full response deleteAddress: ${response.bodyString}");
  //     print("📡 Status code deleteAddress: ${response.statusCode}");
  //
  //     if (response.statusCode == 200) {
  //       var responseData = response.body;
  //       print('✅ Response data addAddressApi: $responseData');
  //       if (responseData["message"] == "address deleted successfully") {
  //         LoadingDialog.hideLoading();
  //         await getAddressList();
  //         showCustomSnackBar(Get.context!, "Address Deleted Successfully.");
  //         update();
  //       } else {
  //         print("❌ Failed to create deleteAddress. Response message: ${responseData["message"]}");
  //       }
  //
  //
  //       print("🎯 Total Shops in deleteAddress: ${_addressList}");
  //
  //
  //     } else {
  //       print("❌ Non-200 response deleteAddress");
  //       var responseData = response.body;
  //       // showCustomSnackBar(
  //       //   Get.context!,
  //       //   responseData["message"] ?? 'Error fetching getCartList',
  //       //   isError: true,
  //       // );
  //     }
  //   } catch (e) {
  //     print("🚨 Exception deleteAddress: $e");
  //     // showCustomSnackBar(Get.context!, 'Something went wrong: $e',
  //     //     isError: true);
  //   } finally {
  //   LoadingDialog.hideLoading();
  //     // LoadingDialog.hideLoading();
  //     update(); // This will notify GetBuilder listeners
  //   }
  //
  //
  //
  // }

  Future<void> deleteAddressApi({required String addressId}) async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await authRepo.deleteAddress(id : addressId);

      print('📡 Status Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 && response.body != null) {
        final message = response.body['message']?.toString() ?? '';

        if (message == "address deleted successfully") {
          await getAddressList();
          showCustomSnackBar(Get.context!, "Address Deleted Successfully.", isError: false);
        } else {
          showCustomSnackBar(Get.context!, message, isError: true);
        }
      } else {
        showCustomSnackBar(Get.context!, "Address can not be deleted because it has orders.", isError: true);
      }
    } catch (e) {
      print('🚨 Exception during deleteAddressApi: $e');
      showCustomSnackBar(Get.context!, "Error: $e", isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }


}












