import 'dart:async';

import 'package:friendly_partner/data/apis/api_client.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartRepo {
  final ApiClient apiClient;

  CartRepo({
    required this.apiClient,
  });

  Future<Response> addToCarturl({
    required String? productId,
  }) async {
    return await apiClient.postData(AppConstants.cartstoreUrl, {
      "product_id": productId,
    });
  }

  Future<Response> addToCartIncrementurl({
    required String? productId,
  }) async {
    return await apiClient.postData(AppConstants.addIncrementCart, {
      "product_id": productId,
    });
  }

  Future<Response> minusRemoveIncrement({
    required String? productId,
  }) async {
    return await apiClient.postData(AppConstants.removeIncrementCart, {
      "product_id": productId,
    });
  }

  Future<Response> getCartList() async {
    return await apiClient.getData(AppConstants.cartUrl, method: "GET");
  }

  Future<Response> deleteCartUrl({required String productId}) async {
    return await apiClient.postData(AppConstants.cartDeleteUrl, {
      "product_id" : productId
    });

  }

  Future<Response> checkoutCartList() async {
    return await apiClient.getData(AppConstants.cartCheckoutUrl, );
  }


  Future<Response> getCheckPinCode({required String pincode}) async {
    return await apiClient.postData(AppConstants.checkPinCodeUrl, {
      "pincode" : pincode
    });

  }




}
