import 'dart:io';
import 'package:friendly_partner/controllers/home_controller.dart';
import 'package:friendly_partner/controllers/profile_controller.dart';
import 'package:http/http.dart' as http;
import 'package:friendly_partner/app/screens/dashboard/dashboard.dart';
import 'package:friendly_partner/app/widgets/custom_snackbar.dart';
import 'package:friendly_partner/app/widgets/loading_dialog.dart';
import 'package:friendly_partner/data/repo/auth_repo.dart';
import 'package:friendly_partner/data/repo/home_repo.dart';
import 'package:friendly_partner/data/repo/whole_seller.dart';
import 'package:friendly_partner/helper/route_helper.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'auth_controller.dart';
class WholeSellerController extends GetxController {
  final WholeSellerRepo wholeSellerRepo;

  WholeSellerController({
    required this.wholeSellerRepo,
  });
  Future<void> connectWholeSellerApi(
      {required shopId, required String accessToken}) async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await wholeSellerRepo.connectWholeSellerRepo(
          shopId: shopId, accessToken: accessToken, retailerId:  Get.find<ProfileController>().profileData!['user']!['id'].toString());
      print('📥 Raw headers: ${response.headers}');
      print('📥 Raw response: ${response.bodyString}');
      print('📡 Status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;
        print('✅ Response data: $responseData');
        String message = responseData['message'] ?? '';
        showCustomSnackBar(Get.context!, message, isError: false);
        await Get.find<WholeSellerController>().getSearchShopApi(searchQuery: "");
        // await Get.find<HomeController>().getNonConnectedWholeSellerShopApi();
        Get.back();
        await Future.delayed(Duration(milliseconds: 100));
        Get.back(); // Close the previous one
        Get.back(); // Close the previous one
        update();
      } else {
        showCustomSnackBar(Get.context!, 'Unexpected error occurred.',
            isError: true);
      }
    } catch (e) {
      print('🚨 Exception connectWholeSellerApi: $e');
      showCustomSnackBar(Get.context!, 'Something went wrong: $e',
          isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }

  Map<String, dynamic>? _shopProducts;
  Map<String, dynamic>? get shopProducts => _shopProducts;

  Future<void> getShopProducts({required String shopId}) async {
    print('Fetching getShopProducts ================>');
    LoadingDialog.showLoading();

    try {
      Response response = await wholeSellerRepo.getShopProducts(shopId: shopId);

      if (response.statusCode == 200) {
        final data = response.body;
        _shopProducts = data['data']['shopproduct'];

        print('Check getShopProducts : ${_shopProducts}');
      } else {
        print("Failed to load data getShopProducts: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred getShopProducts: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }

  List<dynamic>? _searchShopList;
  List<dynamic>? get searchShopList => _searchShopList;

  Future<void> getSearchShopApi({required String searchQuery}) async {
    try {
      print("📥 Full response _searchShopList: ${searchQuery}");
      // LoadingDialog.showLoading();
      // update();

      Response response =
          await wholeSellerRepo.getSearchShop(searchQuery: searchQuery, retailerId: Get.find<ProfileController>().profileData!['user']!['id'].toString());

      print("📥 Full response _searchShopList: ${response.bodyString}");
      print("📡 Status code _searchShopList: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["shop"] != null) {
          List<dynamic> trainerDataList = responseData["data"]["shop"];
          print("🎯 _searchShopList Length : ${trainerDataList.length}");
          _searchShopList = trainerDataList;

          update();
        } else {
          print("🚫 No shop data in response");
          _searchShopList = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body");
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
      // LoadingDialog.hideLoading();
      // update();
    }
  }

  Map<String, dynamic>? _productDetails;
  Map<String, dynamic>? get productDetails => _productDetails;

  Future<void> getProductDetails({required String productId}) async {
    print('Fetching getProductDetails ================>');
    LoadingDialog.showLoading();

    try {
      Response response =
          await wholeSellerRepo.getProductDetails(productId: productId);

      if (response.statusCode == 200) {
        final data = response.body;
        _productDetails = data['data']['product'];

        print('Check getProductDetails : ${_productDetails}');
      } else {
        print("Failed to load data getProductDetails: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred getProductDetails: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }

  List<dynamic>? _connectedWholeSellers;
  List<dynamic>? get connectedWholeSellers => _connectedWholeSellers;

  Future<void> getConnectedWholesellers() async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await wholeSellerRepo.getConnectedWholeSellers(id: Get.find<AuthController>().getUserid().toString());

      print(
          "📥 Full response getConnectedWholesellers: ${response.bodyString}");
      print(
          "📡 Status code _searchShogetConnectedWholesellerspList: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["connectedWoleseller"] != null) {
          List<dynamic> trainerDataList =
              responseData["data"]["connectedWoleseller"];
          print(
              "🎯 getConnectedWholesellers Length : ${trainerDataList.length}");
          _connectedWholeSellers = trainerDataList;

          update();
        } else {
          print("🚫 No shop data in response getConnectedWholesellers");
          _connectedWholeSellers = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body getConnectedWholesellers");
        final message = response.body?["message"] ?? "Error Api";
        showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print("🚨 Exception getConnectedWholesellers: $e");
      showCustomSnackBar(
          Get.context!, 'Something went wrong getConnectedWholesellers: $e',
          isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }

  List<dynamic>? _ordersList;
  List<dynamic>? get ordersList => _ordersList;

  Future<void> getOrdersListApi() async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await wholeSellerRepo.getOrderListRepo();

      print("📥 Full response getOrdersListApi: ${response.bodyString}");
      print("📡 Status code getOrdersListApi: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["orders"] != null) {
          List<dynamic> trainerDataList = responseData["data"]["orders"];
          print("🎯 getOrdersListApi Length : ${trainerDataList.length}");
          _ordersList = trainerDataList;

          update();
        } else {
          print("🚫 No shop data in response getOrdersListApi");
          _ordersList = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body getOrdersListApi");
        final message = response.body?["message"] ?? "Error Api";
        showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print("🚨 Exception getOrdersListApi:  $e");
      showCustomSnackBar(
          Get.context!, 'Something went wrong getOrdersListApi: $e',
          isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }


  List<dynamic>? _wholeSellerOrdersList;
  List<dynamic>? get wholeSellerOrdersList => _wholeSellerOrdersList;

  Future<void> getWholeSellerOrderListApi() async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await wholeSellerRepo.getWholeSellerOrderListRepo();

      print("📥 Full response getWholeSellerOrderListApi: ${response.bodyString}");
      print("📡 Status code getWholeSellerOrderListApi: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["orders"] != null) {
          List<dynamic> trainerDataList = responseData["data"]["orders"];
          print("🎯 getOrdersListApi Length : ${trainerDataList.length}");
          _wholeSellerOrdersList = trainerDataList;

          update();
        } else {
          print("🚫 No shop data in response getWholeSellerOrderListApi");
          _wholeSellerOrdersList = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body getWholeSellerOrderListApi");
        final message = response.body?["message"] ?? "Error Api";
        showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print("🚨 Exception getWholeSellerOrderListApi:  $e");
      showCustomSnackBar(
          Get.context!, 'Something went wrong getWholeSellerOrderListApi: $e',
          isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }


  Map<String, dynamic>? _orderDetails;
  Map<String, dynamic>? get orderDetails => _orderDetails;

  Future<void> getWholeSellerOrderDetails({required String ordersId}) async {
    print('Fetching getWholeSellerOrderDetails ================>');
    LoadingDialog.showLoading();

    try {
      Response response =
      await wholeSellerRepo.getWholeSellerOrderDetailsRepo(ordersId: ordersId);

      if (response.statusCode == 200) {
        final data = response.body;
        _orderDetails = data['data']['order'];

        print('Check getWholeSellerOrderDetails : ${_orderDetails}');
      } else {
        print("Failed to load data getWholeSellerOrderDetails: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred getWholeSellerOrderDetails: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }



  Future<void> addProduct({
    required String name,
    required String description,
    required String shortDescription,
    required String category,
    required List<int> subCategory,

    // required String subCategory,
    required String brand,
    required String code,
    // required String color,
    required List<String> colorList,
    required String price,
    required String discountPrice,
    required String quantity,
    required String minOrderQuantity,
    required String metaTitle,
    required String metaDescription,
    File? thumbnail,
    List<File>? additionThumbnails,
    // File? additionThumbnail,
    File? previousThumbnail,
  }) async {
    final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.addProduct}');
    var request = http.MultipartRequest('POST', uri);

    LoadingDialog.showLoading(); // Show once
    update();


    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['short_description'] = shortDescription;
    request.fields['category'] = category;
    for (int id in subCategory) {
      request.fields['sub_category[]'] = id.toString();
    }
    // request.fields['sub_category'] = subCategory;
    request.fields['brand'] = brand;
    request.fields['code'] = code;
    // request.fields['color'] = color;
    for (var c in colorList) {
      request.fields['color[]'] = c;
    }
    request.fields['price'] = price;
    request.fields['discount_price'] = discountPrice;
    request.fields['quantity'] = quantity;
    request.fields['min_order_quantity'] = minOrderQuantity;
    request.fields['meta_title'] = metaTitle;
    request.fields['meta_description'] = metaDescription;

    request.fields.forEach((key, value) {
      print('Fields : $key: $value');
    });


    // Add file if provided
    if (thumbnail != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'thumbnail',
          thumbnail.path,
          filename: path.basename(thumbnail.path),
        ),
      );
    }

    // Add file if provided
    if (additionThumbnails != null && additionThumbnails.isNotEmpty) {
      for (var file in additionThumbnails) {
        request.files.add(await http.MultipartFile.fromPath(
          'additionThumbnail[]', // <-- as array
          file.path,
          filename: path.basename(file.path),
        ));
      }
    }


    // Add file if provided
    if (previousThumbnail != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'previousThumbnail',
          previousThumbnail.path,
          filename: path.basename(previousThumbnail.path),
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
        Get.find<HomeController>().getWholeSellerHomeData();
        showCustomSnackBar(Get.context!, "Product Added Successfully");
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


  Future<void> updateProduct({
    required String productId,
    required String name,
    required String description,
    required String shortDescription,
    required String category,
    required List<int> subCategory,
    required String brand,
    required String code,
    // required List<String> colorList,
    required String price,
    required String discountPrice,
    required String quantity,
    required String minOrderQuantity,
    // required String metaTitle,
    // required String metaDescription,
    File? thumbnail,
    List<File>? additionThumbnails,
  }) async {
    final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.updateProduct}/${productId}/update');
    var request = http.MultipartRequest('POST', uri);

    LoadingDialog.showLoading(); // Show once
    update();


    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['short_description'] = shortDescription;
    request.fields['category'] = category;
    for (int id in subCategory) {
      request.fields['sub_category[]'] = id.toString();
    }
    // request.fields['sub_category'] = subCategory;
    request.fields['brand'] = brand;
    request.fields['code'] = code;
    // request.fields['color'] = color;
    // for (var c in colorList) {
    //   request.fields['color[]'] = c;
    // }
    request.fields['price'] = price;
    request.fields['discount_price'] = discountPrice;
    request.fields['quantity'] = quantity;
    request.fields['min_order_quantity'] = minOrderQuantity;
    // request.fields['meta_title'] = metaTitle;
    // request.fields['meta_description'] = metaDescription;

    request.fields.forEach((key, value) {
      print('Fields : $key: $value');
    });


    // Add file if provided
    if (thumbnail != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'thumbnail',
          thumbnail.path,
          filename: path.basename(thumbnail.path),
        ),
      );
    }

    // Add file if provided
    if (additionThumbnails != null && additionThumbnails.isNotEmpty) {
      for (var file in additionThumbnails) {
        print('Adding additional thumbnail: ${file.path} | filename: ${path.basename(file.path)}');

        request.files.add(await http.MultipartFile.fromPath(
          'additionThumbnail[]', // <-- as array
          file.path,
          filename: path.basename(file.path),
        ));
      }
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
        showCustomSnackBar(Get.context!, "Product Updated Successfully");

        Get.back();
        Get.back();
        await Get.find<WholeSellerController>().getWholeSellerAllProducts();
        update();


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


  List<dynamic>? _connectedRetailersList;
  List<dynamic>? get connectedRetailersList => _connectedRetailersList;

  Future<void> getConnectedRetailsListApi() async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await wholeSellerRepo.getConnectedRetailersRepo(shopId:Get.find<ProfileController>().wholeSellerProfileData!['user']!['shop']['id'].toString());

      print("📥 Full response getConnectedRetailsListApi: ${response.bodyString}");
      print("📡 Status code getConnectedRetailsListApi: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["retailPartner"] != null) {
          List<dynamic> trainerDataList = responseData["data"]["retailPartner"];
          print("🎯 getConnectedRetailsListApi Length : ${trainerDataList.length}");
          _connectedRetailersList = trainerDataList;

          update();
        } else {
          print("🚫 No shop data in response getConnectedRetailsListApi");
          _connectedRetailersList = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body getConnectedRetailsListApi");
        final message = response.body?["message"] ?? "Error Api";
        showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print("🚨 Exception getConnectedRetailsListApi: $e");
      showCustomSnackBar(
          Get.context!, 'Something went wrong getConnectedRetailsListApi: $e',
          isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }




  List<dynamic>? _searchRetailersList;
  List<dynamic>? get searchRetailersList => _searchRetailersList;

  Future<void> getSearchRetailersApi({required String searchQuery}) async {
    try {
      print("📥 Full response getSearchRetailersApi: $searchQuery");
      // LoadingDialog.showLoading();
      // update();

      Response response =
      await wholeSellerRepo.getSearchRetailer(searchQuery: searchQuery);

      print("📥 Full response getSearchRetailersApi: ${response.bodyString}");
      print("📡 Status code getSearchRetailersApi: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["retailPartner"] != null) {
          List<dynamic> trainerDataList = responseData["data"]["retailPartner"];
          print("🎯 getSearchRetailersApi Length : ${trainerDataList.length}");
          _searchRetailersList = trainerDataList;

          update();
        } else {
          print("🚫 No getSearchRetailersApi data in response");
          _searchRetailersList = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body");
        final message =
            response.body?["message"] ?? "Error fetching search results";
        // showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print("🚨 Exception getSearchRetailersApi: $e");
      // showCustomSnackBar(
      //     Get.context!, 'Something went wrong getSearchRetailersApi: $e',
      //     isError: true);
    } finally {
      update();
      // LoadingDialog.hideLoading();
      // update();
    }
  }




  Future<void> updateOrderConfirmStatusApi({required String orderId}) async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await wholeSellerRepo.orderStatusConfirmRepo(orderId: orderId);
      print('📥 Raw headers updateOrderConfirmStatusApi: ${response.headers}');
      print('📥 Raw response updateOrderConfirmStatusApi: ${response.bodyString}');
      print('📡 Status code updateOrderConfirmStatusApi: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;
        print('✅ Response data updateOrderConfirmStatusApi: $responseData');
        LoadingDialog.hideLoading();

       await Get.find<WholeSellerController>().getWholeSellerOrderDetails(ordersId: orderId);
        update();


      } else {

      }
    } catch (e) {
      print('Exception during  updateOrderConfirmStatusApi: $e');
      // showCustomSnackBar(Get.context!, 'Something went  updateOrderConfirmStatusApi: $e', isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }


  Future<void> updateOrderCancelStatusApi({required String orderId}) async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await wholeSellerRepo.orderStatusCancelRepo(orderId: orderId);
      print('📥 Raw headers updateOrderCancelStatusApi: ${response.headers}');
      print('📥 Raw response updateOrderCancelStatusApi: ${response.bodyString}');
      print('📡 Status code updateOrderCancelStatusApi: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;
        print('✅ Response data updateOrderCancelStatusApi: $responseData');
        LoadingDialog.hideLoading();

        await Get.find<WholeSellerController>().getWholeSellerOrderDetails(ordersId: orderId);
        update();


      } else {

      }
    } catch (e) {
      print('Exception during  updateOrderCancelStatusApi: $e');
      // showCustomSnackBar(Get.context!, 'Something went  updateOrderConfirmStatusApi: $e', isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }



  Map<String, dynamic>? _retailerDetails;
  Map<String, dynamic>? get retailerDetails => _retailerDetails;

  Future<void> getRetailerDetails({required String retailerId}) async {
    print('Fetching _retailerDetails ================>');
    LoadingDialog.showLoading();

    try {
      Response response = await wholeSellerRepo.getRetailerDetailsRepo(id: retailerId);

      if (response.statusCode == 200) {
        final data = response.body;
        final list = data['data']['retailsDetails'];
        if (list is List && list.isNotEmpty) {
          _retailerDetails = list[0];
          print('Check _retailerDetails : ${_retailerDetails}');
        }
      } else {
        print("Failed to load data _retailerDetails: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred _retailerDetails: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }



  List<dynamic>? _categoryList;
  List<dynamic>? get categoryList => _categoryList;

  Future<void> getCategoryListApi() async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await wholeSellerRepo.getCategories();

      print("📥 Full response getCategoryListApi: ${response.bodyString}");
      print("📡 Status code getCategoryListApi: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["categories"] != null) {
          List<dynamic> trainerDataList = responseData["data"]["categories"];
          print("🎯 getCategoryListApi Length : ${trainerDataList.length}");
          _categoryList = trainerDataList;
          print('Category LEnght :${_categoryList!.length}');

          update();
        } else {
          print("🚫 No shop data in response getCategoryListApi");
          _categoryList = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body getCategoryListApi");
        final message = response.body?["message"] ?? "Error Api";
        showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print("🚨 Exception getCategoryListApi: $e");

    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }

  List<dynamic>? _brandList;
  List<dynamic>? get brandList => _brandList;

  Future<void> getBrandListApi() async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await wholeSellerRepo.getBrandRepo();

      print("📥 Full response getBrandListApi: ${response.bodyString}");
      print("📡 Status code getBrandListApi: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["brands"] != null) {
          List<dynamic> trainerDataList = responseData["data"]["brands"];
          print("🎯 getBrandListApi Length : ${trainerDataList.length}");
          _brandList = trainerDataList;
          print('getBrandListApi LEnght :${_brandList!.length}');

          update();
        } else {
          print("🚫 No shop data in response getBrandListApi");
          _brandList = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body getBrandListApi");
        final message = response.body?["message"] ?? "Error Api";
        showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print("🚨 Exception getBrandListApi: $e");

    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }



  List<dynamic>? _subCategoryList;
  List<dynamic>? get subCategoryList => _subCategoryList;

  Future<void> getSubCategoryListApi({required String categoryId}) async {
    try {

      print("📥 Full response id getSubCategoryListApi: ${categoryId}");
      LoadingDialog.showLoading();

      update();

      Response response = await wholeSellerRepo.getSubCategories(categoryId: categoryId);


      print("📥 Full response getSubCategoryListApi: ${response.bodyString}");
      print("📡 Status code getSubCategoryListApi: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["sub_categories"] != null) {
          List<dynamic> data = responseData["data"]["sub_categories"];
          print("🎯 getSubCategoryListApi Length : ${data.length}");
          _subCategoryList = data;
          print('Category LEnght :${_subCategoryList!.length}');

          update();
        } else {
          print("🚫 No shop data in response getSubCategoryListApi");
          _subCategoryList = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body getSubCategoryListApi");
        final message = response.body?["message"] ?? "Error Api";
        showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print("🚨 Exception getSubCategoryListApi: $e");

    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }

  List<dynamic>? _allWholeSellerProductsList;
  List<dynamic>? get allWholeSellerProductsList => _allWholeSellerProductsList;

  Future<void> getWholeSellerAllProducts() async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await wholeSellerRepo.getAllWholeProductsRepo();

      print("📥 Full response getWholeSellerAllProducts: ${response.bodyString}");
      print("📡 Status code getWholeSellerAllProducts: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["products"] != null) {
          List<dynamic> trainerDataList = responseData["data"]["products"];
          print("🎯 getCategoryListApi Length : ${trainerDataList.length}");
          _allWholeSellerProductsList = trainerDataList;
          print('getWholeSellerAllProducts LEnght :${_allWholeSellerProductsList!.length}');

          update();
        } else {
          print("🚫 No shop data in response getWholeSellerAllProducts");
          _categoryList = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body getWholeSellerAllProducts");
        final message = response.body?["message"] ?? "Error Api";
        showCustomSnackBar(Get.context!, message, isError: true);
      }
    } catch (e) {
      print("🚨 Exception getCategoryListApi: $e");

    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }





  Future<void> postProductStatusChange({required String productId}) async {
    print('Fetching postProductStatusChange ================>');
    LoadingDialog.showLoading();

    try {
      Response response = await wholeSellerRepo.postProductStatusChangeRepo(productId: productId);

      if (response.statusCode == 200) {
        final data = response.body;
        if (data['message'] == "Status updated successfully") {
          getWholeSellerAllProducts();
        }
      } else {
        showCustomSnackBar(Get.context!, "Action denied: Your product is still in the verification process. Status changes are not allowed at this stage.");
      }
    } catch (e) {
      print("Exception occurred postProductStatusChange: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }



  Future<void> addProductApi({
    required String name,
    required String description,
    required String shortDescription,
    required String category,
    required List<int> subCategory,

    // required String subCategory,
    required String brand,
    required String code,
    // required String color,
    required List<String> colorList,
    required String price,
    required String discountPrice,
    required String quantity,
    required String minOrderQuantity,
    required String metaTitle,
    required String metaDescription,
    File? thumbnail,
    List<File>? additionThumbnails,
    // File? additionThumbnail,
    File? previousThumbnail,
  }) async {
    final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.addProduct}');
    var request = http.MultipartRequest('POST', uri);

    LoadingDialog.showLoading(); // Show once
    update();


    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['short_description'] = shortDescription;
    request.fields['category'] = category;
    for (int id in subCategory) {
      request.fields['sub_category[]'] = id.toString();
    }
    // request.fields['sub_category'] = subCategory;
    request.fields['brand'] = brand;
    request.fields['code'] = code;
    // request.fields['color'] = color;
    for (var c in colorList) {
      request.fields['color[]'] = c;
    }
    request.fields['price'] = price;
    request.fields['discount_price'] = discountPrice;
    request.fields['quantity'] = quantity;
    request.fields['min_order_quantity'] = minOrderQuantity;
    request.fields['meta_title'] = metaTitle;
    request.fields['meta_description'] = metaDescription;

    request.fields.forEach((key, value) {
      print('Fields : $key: $value');
    });


    // Add file if provided
    if (thumbnail != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'thumbnail',
          thumbnail.path,
          filename: path.basename(thumbnail.path),
        ),
      );
    }

    // Add file if provided
    if (additionThumbnails != null && additionThumbnails.isNotEmpty) {
      for (var file in additionThumbnails) {
        request.files.add(await http.MultipartFile.fromPath(
          'additionThumbnail[]', // <-- as array
          file.path,
          filename: path.basename(file.path),
        ));
      }
    }


    // Add file if provided
    if (previousThumbnail != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'previousThumbnail',
          previousThumbnail.path,
          filename: path.basename(previousThumbnail.path),
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
        showCustomSnackBar(Get.context!, "Product Added Successfully");
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



  Future<void> addSupportTicket({
    required String issueType,
    required String subject,
    required String message,
    required String email,
    required String phone,
    List<File>? attachments,
  }) async {
    final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.storeSupportTicker}');
    var request = http.MultipartRequest('POST', uri);

    LoadingDialog.showLoading(); // Show once
    update();
    request.fields['issue_type'] = issueType;
    request.fields['subject'] = subject;
    request.fields['message'] = message;
    request.fields['email'] = email;
    request.fields['phone'] = phone;


    request.fields.forEach((key, value) {
      print('Fields : $key: $value');
    });

    if (attachments != null && attachments.isNotEmpty) {
      for (var file in attachments) {
        request.files.add(await http.MultipartFile.fromPath(
          'attachments[]', // <-- as array
          file.path,
          filename: path.basename(file.path),
        ));
      }
    }

    request.headers.addAll({
      'Authorization': 'Bearer ${Get.find<AuthController>().getUserToken()}',
      'Accept': 'application/json',
    });

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Success: $responseData');
        Get.back();
        Get.back();
        await getSupportTicketList();


        showCustomSnackBar(Get.context!, "Ticket Created Successfully");
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

  Map<String, dynamic>? _supportTicketList;
  Map<String, dynamic>? get supportTicketList => _supportTicketList;

  Future<void> getSupportTicketList() async {
    print('Fetching _supportTicketList ================>');
    LoadingDialog.showLoading();

    try {
      Response response = await wholeSellerRepo.getSupportTicketRepo();

      if (response.statusCode == 200) {
        final data = response.body;
        final list = data['data'];
        _supportTicketList = list;

      } else {
        print("Failed to load data _supportTicketList: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred _supportTicketList: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }
  Future<void> shopSettingApi(
      {required String deliveryTime, required String openingTime , required String closingTime}) async {
    try {
      LoadingDialog.showLoading();
      update();

      Response response = await wholeSellerRepo.postWholeSellerStoreSettingRepo(
          deliveryTime: deliveryTime,
          openingTime: openingTime,
          closingTime: closingTime
        );
      print('📥 Raw headers shopSettingApi: ${response.headers}');
      print('📥 Raw response shopSettingApi: ${response.bodyString}');
      print('📡 Status code shopSettingApi: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;
        print('✅ Response data shopSettingApi: $responseData');

        String message = responseData['message'] ?? '';

        if (message == 'Connected Successfully !') {
          showCustomSnackBar(Get.context!, message, isError: false);
          // You can add navigation or success logic here
        } else {
          showCustomSnackBar(Get.context!, message, isError: true);
        }
      } else {
        showCustomSnackBar(Get.context!, 'Unexpected error occurred.',
            isError: true);
      }
    } catch (e) {
      print('🚨 Exception connectWholeSellerApi: $e');
      showCustomSnackBar(Get.context!, 'Something went wrong: $e',
          isError: true);
    } finally {
      LoadingDialog.hideLoading();
      update();
    }
  }

  Map<String, dynamic>? _wholeSellerDetails;
  Map<String, dynamic>? get wholeSellerDetails => _wholeSellerDetails;

  Future<void> getWholeSellerShopDetails({required String id}) async {
    print('Fetching getWholeSellerDetails ================>');
    LoadingDialog.showLoading();

    try {
      Response response = await wholeSellerRepo.getWholeSellerDetailsRepo(id: id);

      if (response.statusCode == 200) {
        final data = response.body;
        _wholeSellerDetails = data['data']; // ✅ Correct assignment here

        print('Check getWholeSellerDetails : ${_wholeSellerDetails}');
      } else {
        print("Failed to load data getWholeSellerDetails: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred getWholeSellerDetails: $e");
    }
    LoadingDialog.hideLoading();
    update();
  }


  Map<String, dynamic>? _wholeSellerProductDetails;
  Map<String, dynamic>? get wholeSellerProductDetails => _wholeSellerProductDetails;

  Future<void> getWholeSellerProductDetails({required String productId}) async {
    print('Fetching _wholeSellerProductDetails ================>');
    LoadingDialog.showLoading();

    try {
      Response response =
      await wholeSellerRepo.getWholeSellerProductDetails(id: productId);

      if (response.statusCode == 200) {
        final data = response.body;
        _wholeSellerProductDetails = data['data']['product'];

        print('Check _wholeSellerProductDetails : ${_wholeSellerProductDetails}');
      } else {
        print("Failed to load data _wholeSellerProductDetails: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred _wholeSellerProductDetails: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }

  Map<String, dynamic>? _retailerOrderDetails;
  Map<String, dynamic>? get retailerOrderDetails => _retailerOrderDetails;

  Future<void> getRetailerOrderDetails({required String productId}) async {
    print('Fetching _retailerOrderDetails ================>');
    LoadingDialog.showLoading();

    try {
      Response response =
      await wholeSellerRepo.getRetailerOrderDetails(orderId: productId);

      if (response.statusCode == 200) {
        final data = response.body;
        _retailerOrderDetails = data['data']['order'];

        print('Check _retailerOrderDetails : ${_retailerOrderDetails}');
      } else {
        print("Failed to load data _retailerOrderDetails: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred _retailerOrderDetails: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }



  Map<String, dynamic>? _searchShopProducts;
  Map<String, dynamic>? get searchShopProducts => _searchShopProducts;

  Future<void> getSearchShopProducts({required String shopId,required String search,}) async {
    print('Fetching _searchShopProducts ================> ${shopId} dc ${search}' );
    LoadingDialog.showLoading();

    try {
      Response response = await wholeSellerRepo.getShopSearchProducts(shopId: shopId, search: search);

      if (response.statusCode == 200) {
        final data = response.body;
        _searchShopProducts = data['data']['shopproduct'];
        update();

        print('Check _searchShopProducts : ${_searchShopProducts}');
      } else {
        print("Failed to load data _searchShopProducts: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred _searchShopProducts: $e");
    }

    LoadingDialog.hideLoading();
    update();
  }


  List<dynamic>? _searchConnectedShopList;
  List<dynamic>? get searchConnectedShopList => _searchConnectedShopList;

  Future<void> getConnectSearchShopApi({required String searchQuery}) async {
    try {
      print("📥 Full response _searchShopList: ${searchQuery}");
      // LoadingDialog.showLoading();
      // update();

      Response response =
      await wholeSellerRepo.getConnectedSearchShop(searchQuery: searchQuery, retailerId: Get.find<ProfileController>().profileData!['user']!['id'].toString());

      print("📥 Full response _searchShopList: ${response.bodyString}");
      print("📡 Status code _searchShopList: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        var responseData = response.body;

        if (responseData["data"] != null &&
            responseData["data"]["shop"] != null) {
          List<dynamic> trainerDataList = responseData["data"]["shop"];
          print("🎯 _searchShopList Length : ${trainerDataList.length}");
          _searchConnectedShopList = trainerDataList;

          update();
        } else {
          print("🚫 No shop data in response");
          _searchConnectedShopList = []; // or handle empty case
        }
      } else {
        print("❌ Non-200 response or null body");
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
      // LoadingDialog.hideLoading();
      // update();
    }
  }




}
