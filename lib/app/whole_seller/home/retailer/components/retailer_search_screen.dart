import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';

import '../../../../../controllers/whole_seller_controller.dart';
import '../../../../../data/repo/whole_seller.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_constants.dart';
import '../../../../../utils/dimensions.dart';
import '../../../../../utils/sizeboxes.dart';
import '../../../../../utils/styles.dart';
import '../../../../widgets/custom_card_container.dart';
import '../../../../widgets/custom_network_image.dart';
import '../../../../widgets/custom_textfield.dart';

class RetailerSearchScreen extends StatelessWidget {
   RetailerSearchScreen({super.key});
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final repo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final controller =
    Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
    controller.getSearchRetailersApi(searchQuery: "");
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Search Retailers",isBackButtonExist: true,isHideCart: true,),
        body: SingleChildScrollView(
            child: GetBuilder<WholeSellerController>(builder: (controller) {
              final shopList = controller.searchRetailersList;
              return Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "Search Shop",
                      controller: _searchController,
                      onChanged: (val) {
                        controller.getSearchRetailersApi(searchQuery: val);
                      },
                      onSubmit: (val) {
                        controller.getSearchRetailersApi(searchQuery: val);
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
                            // Get.to(() => StoreProductsScreen(
                            //   title: shop['name'] ?? 'N/A',
                            //   id: shop['id'].toString(),
                            // ));
                          },
                          child: CustomCardContainer(
                              child: Row(
                                children: [
                                  CustomNetworkImageWidget(
                                    height: 70,
                                    radius: Dimensions.radius5,
                                    width: 70,
                                    image: shop['store']['media_logo'] != null &&
                                        shop['store']['media_logo']['src'] != null
                                        ? "${AppConstants.shopImagebaseUrl}${shop['store']['media_logo']['src']}"
                                        : "https://via.placeholder.com/50", // or use your own local placeholder asset
                                  ),
                                  sizedBoxW10(),
                                  Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            shop['store']['name'] ?? 'N/A',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: robotoSemiBold,
                                          ),
                                          sizedBox4(),
                                          Text(
                                            shop['store']['address'] ?? 'N/A',
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
