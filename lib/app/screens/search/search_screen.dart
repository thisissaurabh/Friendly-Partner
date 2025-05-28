import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/stores/store_products.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/app/widgets/custom_textfield.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/data/repo/whole_seller.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

import '../stores/product_details_screen.dart';
import '../stores/whole_seller_details.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final repo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final controller =
        Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
    controller.getSearchShopApi(searchQuery: "");
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Search",
          isBackButtonExist: true,
        ),
        body: SingleChildScrollView(
            child: GetBuilder<WholeSellerController>(builder: (controller) {
          final shopList = controller.searchShopList;
          return Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              children: [
                CustomTextField(
                  hintText: "Search Shop",
                  controller: _searchController,
                  onChanged: (val) {
                    controller.getSearchShopApi(searchQuery: val);
                  },
                  onSubmit: (val) {
                    controller.getSearchShopApi(searchQuery: val);
                  },
                ),
                sizedBoxDefault(),
                shopList == null
                    ? Center(child: CircularProgressIndicator())
                    : shopList.isEmpty
                        ? Center(child: Text("No shops found."))
                        : ListView.separated(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: shopList.length,
                            itemBuilder: (context, index) {
                              final shop = shopList[index];

                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => WholeSellerShopDetails(title: shop['name'].toString(), id:  shop['id'].toString(),));

                                  // Get.to(() => StoreDe(
                                  //       title: shop['name'] ?? 'N/A',
                                  //       id: shop['id'].toString(),
                                  //     ));
                                },
                                child: CustomCardContainer(
                                    child: Row(
                                  children: [
                                    CustomNetworkImageWidget(
                                      height: 70,
                                      radius: Dimensions.radius5,
                                      width: 70,
                                      image: '${AppConstants.onlyBaseUrl}${shop['logo'] ?? "N/A"}', // or use your own local placeholder asset
                                    ),
                                    // CustomNetworkImageWidget(
                                    //   height: 70,
                                    //   radius: Dimensions.radius5,
                                    //   width: 70,
                                    //   image: shop['media_logo'] != null &&
                                    //           shop['media_logo']['src'] != null
                                    //       ? "${AppConstants.shopImagebaseUrl}${shop['media_logo']['src']}"
                                    //       : "https://via.placeholder.com/50", // or use your own local placeholder asset
                                    // ),
                                    sizedBoxW10(),
                                    Flexible(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          shop['name'] ?? 'N/A',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: robotoSemiBold,
                                        ),
                                        sizedBox4(),
                                        Text(
                                          shop['address'] ?? 'No Address Added',
                                          maxLines: 2,
                                          style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSize14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // sizedBox4(),
                                        // Text(
                                        //   "Min Order Price : ₹${shop['min_order_amount']}",
                                        //   style: robotoRegular.copyWith(
                                        //       fontSize: Dimensions.fontSize14,
                                        //       color: Theme.of(context)
                                        //           .highlightColor),
                                        // ),
                                      ],
                                    ))
                                  ],
                                )

                                    // ListTile(
                                    //   // leading: Image.network(
                                    //   //   "https://yourdomain.com/${shop['media_logo']['src']}",
                                    //   //   width: 50,
                                    //   //   height: 50,
                                    //   //   fit: BoxFit.cover,
                                    //   // ),
                                    //   title: Text(shop['name'] ?? 'No Name'),
                                    //   subtitle:
                                    //       Text(shop['address'] ?? 'No Address'),
                                    //   trailing: Text(
                                    //       "Min Order Price : ₹${shop['min_order_amount']}"),
                                    //   onTap: () {
                                    //     // Handle tap if needed
                                    //   },
                                    // ),
                                    ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    sizedBox10(),
                          ),
              ],
            ),
          );
        })),
      ),
    );
  }
}


class SearchShopProductScreen extends StatelessWidget {
  final String shopId;
  final String shopName;
  SearchShopProductScreen({super.key, required this.shopId, required this.shopName});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final controller =
    Get.put(WholeSellerController(wholeSellerRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSearchShopProducts(search: "", shopId: shopId);
    });

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Search",
          isBackButtonExist: true,
        ),
        body: SingleChildScrollView(
          child: GetBuilder<WholeSellerController>(builder: (controller) {
            final shopData = controller.searchShopProducts;

            if (shopData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final shopName = shopData['name'] ?? 'N/A';
            final shopAddress = shopData['address'] ?? 'No Address Added';
            final shopDesc = shopData['description'] ?? 'N/A';
            final minOrderAmount = shopData['min_order_amount'] ?? 0.0;
            final products = shopData['products'] ?? [];
            final productPrice =
                shopData['discount_price']?.toString() ?? '0';


            return Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                children: [
                  CustomTextField(
                    hintText: "Search Shop Products",
                    controller: _searchController,
                    onChanged: (val) {
                      controller.getSearchShopProducts(
                          shopId: shopId, search: val);
                    },
                    onSubmit: (val) {
                      controller.getSearchShopProducts(
                          shopId: shopId, search: val);
                    },
                  ),
                  sizedBoxDefault(),
                  if (products.isEmpty)
                    const Center(child: Text("No products found."))
                  else
                    ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return GestureDetector(
                          onTap: () {
                            Get.to(() => ProductDetailsScreen(
                              title:  product['name'] ?? 'N/A',
                              productId: product['id'].toString(),
                            ));

                          },
                          child: CustomCardContainer(
                            child: Row(
                              children: [

                                CustomNetworkImageWidget(
                                  height: 70,
                                  radius: Dimensions.radius5,
                                  width: 70,
                                  image: product['thumbnail'] != null
                                      ? "${AppConstants.onlyBaseUrl}${product['thumbnail']}"
                                      : "https://via.placeholder.com/50",
                                ),
                                sizedBoxW10(),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'] ?? 'N/A',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: robotoSemiBold,
                                      ),
                                      // sizedBox4(),
                                      // Text(
                                      //     product['shopName'] ?? 'N/A',
                                      //   maxLines: 2,
                                      //   style: robotoRegular.copyWith(
                                      //       fontSize:
                                      //       Dimensions.fontSize14),
                                      //   overflow: TextOverflow.ellipsis,
                                      // ),
                                      // sizedBox10(),
                                      Text(
                                        'Desc : ${shopDesc}',
                                        maxLines: 2,
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                            Dimensions.fontSize14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      RichText(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          children: [
                                            if (product['price'] != null &&
                                                product['discount_price'] != null &&
                                                product['price'].toString() != product['discount_price'].toString())
                                              TextSpan(
                                                text: '₹ $productPrice  ',
                                                style: robotoSemiBold.copyWith(
                                                  fontSize: Dimensions.fontSize15,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            TextSpan(
                                              text: '₹ ${product['price']}  ',
                                              style: robotoSemiBold.copyWith(
                                                fontSize: Dimensions.fontSize13,
                                                color: Colors.grey,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),

                                      // sizedBox4(),
                                      // Text(
                                      //   "Min Order Price : ₹$minOrderAmount",
                                      //   style: robotoRegular.copyWith(
                                      //       fontSize:
                                      //       Dimensions.fontSize14,
                                      //       color: Theme.of(context)
                                      //           .highlightColor),
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          sizedBox10(),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}



class ConnectedShopSearchScreen extends StatelessWidget {
  ConnectedShopSearchScreen({super.key});

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final repo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final controller =
    Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
    controller.getConnectSearchShopApi(searchQuery: "");
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Search",
          isBackButtonExist: true,
        ),
        body: SingleChildScrollView(
            child: GetBuilder<WholeSellerController>(builder: (controller) {
              final shopList = controller.searchConnectedShopList;
              return Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "Search Connected Shop",
                      controller: _searchController,
                      onChanged: (val) {
                        controller.getConnectSearchShopApi(searchQuery: val);

                      },
                      onSubmit: (val) {
                        controller.getConnectSearchShopApi(searchQuery: val);
                      },
                    ),
                    sizedBoxDefault(),
                    shopList == null
                        ? Center(child: CircularProgressIndicator())
                        : shopList.isEmpty
                        ? Center(child: Text("No shops found."))
                        : ListView.separated(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: shopList.length,
                      itemBuilder: (context, index) {
                        final shop = shopList[index];

                        return GestureDetector(
                          onTap: () {
                            Get.to(() => StoreProductsScreen(title: shop['name'].toString(), id:  shop['id'].toString(),));
                            // Get.to(() => StoreProductsScreen(
                            //   title: storeName,
                            //   id: storeId,
                            // ));
                            // Get.to(() => StoreDe(
                            //       title: shop['name'] ?? 'N/A',
                            //       id: shop['id'].toString(),
                            //     ));
                          },
                          child: CustomCardContainer(
                              child: Row(
                                children: [
                                  CustomNetworkImageWidget(
                                    height: 70,
                                    radius: Dimensions.radius5,
                                    width: 70,
                                    image: '${AppConstants.onlyBaseUrl}${shop['logo'] ?? "N/A"}', // or use your own local placeholder asset
                                  ),
                                  // CustomNetworkImageWidget(
                                  //   height: 70,
                                  //   radius: Dimensions.radius5,
                                  //   width: 70,
                                  //   image: shop['media_logo'] != null &&
                                  //           shop['media_logo']['src'] != null
                                  //       ? "${AppConstants.shopImagebaseUrl}${shop['media_logo']['src']}"
                                  //       : "https://via.placeholder.com/50", // or use your own local placeholder asset
                                  // ),
                                  sizedBoxW10(),
                                  Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            shop['name'] ?? 'N/A',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: robotoSemiBold,
                                          ),
                                          sizedBox4(),
                                          Text(
                                            shop['address'] ?? 'No Address Added',
                                            maxLines: 2,
                                            style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSize14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // sizedBox4(),
                                          // Text(
                                          //   "Min Order Price : ₹${shop['min_order_amount']}",
                                          //   style: robotoRegular.copyWith(
                                          //       fontSize: Dimensions.fontSize14,
                                          //       color: Theme.of(context)
                                          //           .highlightColor),
                                          // ),
                                        ],
                                      ))
                                ],
                              )

                            // ListTile(
                            //   // leading: Image.network(
                            //   //   "https://yourdomain.com/${shop['media_logo']['src']}",
                            //   //   width: 50,
                            //   //   height: 50,
                            //   //   fit: BoxFit.cover,
                            //   // ),
                            //   title: Text(shop['name'] ?? 'No Name'),
                            //   subtitle:
                            //       Text(shop['address'] ?? 'No Address'),
                            //   trailing: Text(
                            //       "Min Order Price : ₹${shop['min_order_amount']}"),
                            //   onTap: () {
                            //     // Handle tap if needed
                            //   },
                            // ),
                          ),
                        );
                      },
                      separatorBuilder:
                          (BuildContext context, int index) =>
                          sizedBox10(),
                    ),
                  ],
                ),
              );
            })),
      ),
    );
  }
}

