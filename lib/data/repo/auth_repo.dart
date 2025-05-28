import 'dart:async';

import 'package:friendly_partner/data/apis/api_client.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<bool> saveUserToken(
    String token,
  ) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<bool> clearSharedData() async {
    await sharedPreferences.remove(AppConstants.token);
    return true;
  }

  Future<void> saveLoginType(int loginType) async {
    await sharedPreferences.setInt(AppConstants.loginType, loginType);
  }

  int getLoginType() {
    return sharedPreferences.getInt(AppConstants.loginType) ?? 0; // Default to 0 if not set
  }


  Future<Response> login(
    String? username,
    String? password,
  ) async {
    return await apiClient.postData(
        AppConstants.retailerLogin, {"phone": username, "password": password});
  }

  Future<Response> register({
   required String? name,
    required String? email,
    required String? password,
  }) async {
    return await apiClient.postData(
        AppConstants.retailerRegister, {"name": name,"email": email, "password": password});
  }



  Future<Response> loginWholeSeller(
      String? username,
      String? password,
      ) async {
    return await apiClient.postData(
        AppConstants.wholeSellerLogin, {"email": username, "password": password});
  }

  Future<Response> addAddressRepo({
    required String? name,
    required String? phone,
    required String? area,
    required String? flatNo,
    required String? postCode,
    required String? address,
    required String? addressType,
    required String? addressLine2,
    required String? longitude,
    required String? latitude,
  }) async {
    return await apiClient.postData(
        AppConstants.addAddressUrl, {
      'name': name,
      'phone': phone,
      'area': area,
      'flat_no': flatNo,
      'post_code': postCode,
      'address_line':address,
      'address_type': addressType,
      'address_line2' : addressLine2,

      'longitude': longitude,
      'latitude': latitude
    });
  }

  Future<Response> getAddressList() async {
    return await apiClient.getData(AppConstants.addressListUrl, method: "GET");
  }
  Future<Response> deleteAddress({required String id}) async {
    return await apiClient.getData('${AppConstants.address}/$id/delete', method: "DELETE");
  }


}
