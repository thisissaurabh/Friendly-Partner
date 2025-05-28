import 'dart:convert';

import 'package:friendly_partner/data/apis/api_client.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class HomeRepo {
  final ApiClient apiClient;
  HomeRepo({required this.apiClient});

  Future<Response> getRetailerHomeRepo({required String retailerId}) async {
    return await apiClient.getData(
        '${AppConstants.retailerHomeUrl}?retailer_id=$retailerId',
        method: "GET");
  }

  Future<Response> getNonConnectedWholeSellerHomeRepo() async {
    return await apiClient.getData(
        '${AppConstants.nonConnectedWholeSellerUrl}',
        method: "GET");
  }



  Future<Response> getWholeSellerHomeRepo() async {
    return await apiClient.getData(
        AppConstants.wholeSellerHomeUrl,
        method: "GET");
  }
}
