import 'dart:convert';

import 'package:friendly_partner/data/apis/api_client.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ProfileRepo {
  final ApiClient apiClient;
  ProfileRepo({required this.apiClient});

  Future<Response> getProfileRepo() async {
    return await apiClient.getData(AppConstants.profile, method: "GET");
  }

  Future<Response> getWholeSellerProfileRepo() async {
    return await apiClient.getData(AppConstants.wholeSellerProfileUrl, method: "GET");
  }



}
