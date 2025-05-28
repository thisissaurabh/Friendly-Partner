import 'dart:convert';

import 'package:friendly_partner/data/apis/api_client.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class WholeSellerRepo {
  final ApiClient apiClient;
  WholeSellerRepo({required this.apiClient});

  Future<Response> connectWholeSellerRepo({
    required String shopId,
    required String accessToken,
    required String retailerId,
  }) async {
    return await apiClient.postData(AppConstants.connectWholeSeller,
        {"shop_id": shopId, "access_token": accessToken,"retailer_id" : retailerId});
  }

  Future<Response> getShopProducts({required String shopId}) async {
    return await apiClient.getData(
        "${AppConstants.shopProducts}?shop_id=$shopId",
        method: "POST");
  }

  Future<Response> getShopSearchProducts({required String shopId, required String search}) async {
    return await apiClient.getData(
        "${AppConstants.shopProducts}?shop_id=$shopId&search=$search",
        method: "POST");
  }

  Future<Response> getSearchShop({required String retailerId,required String searchQuery}) async {
    return await apiClient.getData(
      '${AppConstants.search}?retailer_id=$retailerId&search=$searchQuery',
      method: "POST",
    );
  }
  Future<Response> getConnectedSearchShop({required String retailerId,required String searchQuery}) async {
    return await apiClient.getData(
      '${AppConstants.searchConnectedShop}?retailer_id=$retailerId&search=$searchQuery',
      method: "POST",
    );
  }

  Future<Response> getProductDetails({required String productId}) async {
    return await apiClient.getData(
      '${AppConstants.productDetails}?product_id=$productId',
      method: "GET",
    );
  }

  Future<Response> getConnectedWholeSellers({required String id}) async {
    return await apiClient.getData(
      '${AppConstants.connectedwholesellersUrl}?id=$id',
      method: "GET",
    );
  }

  Future<Response> getOrderListRepo() async {
    return await apiClient.getData(
      AppConstants.orderUrl,
      method: "GET",
    );
  }

  Future<Response> getWholeSellerOrderListRepo() async {
    return await apiClient.getData(
      AppConstants.wholeSellerOrderUrl,
      method: "GET",
    );
  }
  Future<Response> getWholeSellerOrderDetailsRepo({required String ordersId}) async {
    return await apiClient.getData(
      '${AppConstants.wholeSellerOrderDetailsUrl}?order_id=$ordersId',
      method: "GET",
    );
  }

  Future<Response> getConnectedRetailersRepo({required String shopId}) async {
    return await apiClient.getData(
      '${AppConstants.wholeSellerRetailPartnerUrl}?id=$shopId',
      method: "GET",
    );
  }

  Future<Response> getSearchRetailer({required String searchQuery}) async {
    return await apiClient.getData(
      '${AppConstants.wholeSellerSearchRetailUrl}?name=$searchQuery',
      method: "POST",
    );
  }


  Future<Response> orderStatusConfirmRepo({required String orderId}) async {
    return await apiClient.getData(
      '${AppConstants.updateOrderStatusUrl}orders/details?order_id=$orderId',
      method: "GET",

    );
  }

  Future<Response> orderStatusCancelRepo({required String orderId,}) async {
    return await apiClient.getData(
        AppConstants.updateOrderStatusUrl,
        method: "POST",
        body: {
          "order_id" : orderId,
          "order_status" : "cancel"
        }

    );
  }


  Future<Response> getRetailerDetailsRepo({required String id}) async {
    return await apiClient.getData(
      '${AppConstants.retailerDetailsUrl}?retailer_id=$id',
      method: "POST",

    );
  }


  Future<Response> getCategories() async {
    return await apiClient.getData(
      AppConstants.categoryUrl,
      method: "GET",
    );
  }


  Future<Response> getSubCategories({required String categoryId}) async {
    return await apiClient.getData(
      '${AppConstants.subCategoryUrl}?category_id=$categoryId',
      method: "GET",
    );
  }

  Future<Response> getBrandRepo() async {
    return await apiClient.getData(
      AppConstants.brandUrl,
      method: "GET",
    );
  }

  Future<Response> getAllWholeProductsRepo() async {
    return await apiClient.getData(
      AppConstants.allWholeSellerProductsUrl,
      method: "GET",
    );
  }

  Future<Response> postProductStatusChangeRepo({required String productId}) async {
    return await apiClient.getData(
      '${AppConstants.wholeSellerProductsStatusUrl}/$productId',
      method: "POST",

    );
  }
  Future<Response> postWholeSellerStoreSettingRepo({required String deliveryTime,required String openingTime,required String closingTime,}) async {
    return await apiClient.postData(
      AppConstants.wholeSellerShopSettingsUrl,
        {"estimated_delivery_time": deliveryTime, "opening_time": openingTime, "closing_time" : closingTime}


    );
  }

  Future<Response> getSupportTicketRepo() async {
    return await apiClient.getData(
      AppConstants.supportTicketUrl,
      method: "GET",
    );
  }

  Future<Response> getWholeSellerDetailsRepo({required String id}) async {
    return await apiClient.getData(
      '${AppConstants.wholeSellerDetailsUrl}?id=$id',
      method: "POST",
    );
  }


  Future<Response> getWholeSellerProductDetails({required String id}) async {
    return await apiClient.getData(
      '${AppConstants.updateProduct}/$id/show',
      method: "GET",

    );
  }

  Future<Response> getRetailerOrderDetails({required String orderId}) async {
    return await apiClient.getData(
      '${AppConstants.orderDetailsUrl}?order_id=$orderId',
      method: "GET",
    );
  }

}
