import 'dart:convert';
import 'dart:io';
import 'package:friendly_partner/app/widgets/custom_snackbar.dart';
import 'package:friendly_partner/app/widgets/loading_dialog.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/data/repo/profile_repo.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'package:http_parser/http_parser.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileRepo profileRepo;

  ProfileController({
    required this.profileRepo,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  void pickImage({required bool isRemove}) async {
    if (isRemove) {
      _pickedImage = null;
    } else {
      _pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }

  Map<String, dynamic>? _profileData;
  Map<String, dynamic>? get profileData => _profileData;

  Future<void> getProfileData() async {
    print('Fetching getProfileData ================>');
    LoadingDialog.showLoading();

    try {
      Response response = await profileRepo.getProfileRepo();

      if (response.statusCode == 200) {
        final data = response.body;
        _profileData = data['data'];

        // ignore: unnecessary_brace_in_string_interps
        print('Check Retails getProfileData: ${_profileData}');
      } else {
        print("Failed to load getProfileData: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred getProfileData: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String email,
    File? profilePhoto,
  }) async {
    final uri = Uri.parse('${AppConstants.baseUrl}update-profile');
    var request = http.MultipartRequest('POST', uri);

    LoadingDialog.showLoading(); // Show once
    update();

    // Add fields
    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['email'] = email;

    // Add file if provided
    if (profilePhoto != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_photo',
          profilePhoto.path,
          filename: path.basename(profilePhoto.path),
        ),
      );
    }

    // Add headers
    request.headers.addAll({
      'Authorization': 'Bearer ${Get.find<AuthController>().getUserToken()}',
      'Accept': 'application/json',
    });

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Success: $responseData');
        Get.back(); // hide loader
        await getProfileData();
        showCustomSnackBar(Get.context!, "Profile Updated Successfully");
      } else {
        print('Failed with status: ${response.statusCode}');
        print(await response.stream.bytesToString());
        Get.back(); // hide loader
      }
    } catch (e) {
      print('Exception during updateProfile: $e');
      Get.back(); // hide loader
    } finally {
      update();
    }
  }




  Map<String, dynamic>? _wholeSellerProfileData;
  Map<String, dynamic>? get wholeSellerProfileData => _wholeSellerProfileData;

  Future<void> getWholeSellerProfileData() async {
    print('Fetching getWholeSellerProfileData ================>');
    LoadingDialog.showLoading();

    try {
      Response response = await profileRepo.getWholeSellerProfileRepo();

      if (response.statusCode == 200) {
        final data = response.body;
        _wholeSellerProfileData = data['data'];

        print('Check Retails getWholeSellerProfileData: ${_wholeSellerProfileData}');
      } else {
        print("Failed to load getWholeSellerProfileData: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred getWholeSellerProfileData: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }



  Future<void> updateWholeSellerProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    File? profilePhoto,
  }) async {
    final uri = Uri.parse('${AppConstants.baseUrl}wholeseller/user-update');
    var request = http.MultipartRequest('POST', uri);

    LoadingDialog.showLoading(); // Show once
    update();

    // Add fields
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['phone'] = phone;
    request.fields['email'] = email;

    // Add file if provided
    if (profilePhoto != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_photo',
          profilePhoto.path,
          filename: path.basename(profilePhoto.path),
        ),
      );
    }

    // Add headers
    request.headers.addAll({
      'Authorization': 'Bearer ${Get.find<AuthController>().getUserToken()}',
      'Accept': 'application/json',
    });

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Success: $responseData');
        Get.back(); // hide loader
        Get.back(); // hide loader
        showCustomSnackBar(Get.context!, "Profile Updated Successfully");
      } else {
        print('Failed with status: ${response.statusCode}');
        print(await response.stream.bytesToString());
        Get.back(); // hide loader
      }
    } catch (e) {
      print('Exception during updateProfile: $e');
      Get.back(); // hide loader
    } finally {
      update();
    }
  }

  Future<void> updateWholeSellerShop({
    required String name,
    required String address,

    File? profilePhoto,
  }) async {
    final uri = Uri.parse('${AppConstants.baseUrl}wholeseller/shop-update');
    var request = http.MultipartRequest('POST', uri);
    LoadingDialog.showLoading(); // Show once
    update();

    // Add fields
    request.fields['name'] = name;
    request.fields['address'] = address;



    // Add headers
    request.headers.addAll({
      'Authorization': 'Bearer ${Get.find<AuthController>().getUserToken()}',
      'Accept': 'application/json',
    });

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Success: $responseData');
        Get.back(); // hide loader
        Get.back(); // hide loader
        showCustomSnackBar(Get.context!, "Updated Successfully");
      } else {
        print('Failed with status updateWholeSellerShop: ${response.statusCode}');
        print(await response.stream.bytesToString());
        Get.back(); // hide loader
      }
    } catch (e) {
      print('Exception during updateWholeSellerShop : $e');
      Get.back(); // hide loader
    } finally {
      update();
    }
  }





}
