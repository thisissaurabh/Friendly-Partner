import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/stores/store_products.dart';
import 'package:friendly_partner/app/screens/stores/whole_seller_details.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/app/widgets/custom_textfield.dart';
import 'package:friendly_partner/controllers/home_controller.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/data/repo/home_repo.dart';
import 'package:friendly_partner/data/repo/whole_seller.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_searchfield.dart';

class AllStores extends StatelessWidget {
  AllStores({super.key});

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final repo = Get.put(HomeRepo(apiClient: Get.find()));
    final controller =
    Get.put(HomeController(homeRepo: Get.find()));
    final r = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final c =
    Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
   WidgetsBinding.instance.addPostFrameCallback((_){
     controller.getNonConnectedWholeSellerShopApi();
     c.getSearchShopApi(searchQuery: "");
    });
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "All Stores",
          isBackButtonExist: false,
        ),
        body: SingleChildScrollView(
            child: GetBuilder<WholeSellerController>(builder: (c) {
              final shopList = c.searchShopList;
              return Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    CustomSearchfield(),
                    // CustomTextField(
                    //   hintText: "Search Shop",
                    //   controller: _searchController,
                    //   onChanged: (val) {
                    //     controller.getSearchShopApi(searchQuery: val);
                    //   },
                    //   onSubmit: (val) {
                    //     controller.getSearchShopApi(searchQuery: val);
                    //   },
                    // ),
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
                            print('${AppConstants.onlyBaseUrl}${shop['media_logo']['src']}');
                            // Get.to(() => StoreProductsScreen(
                            //   title: shop['name'] ?? 'N/A',
                            //   id: shop['id'].toString(),
                            // ));
                          },
                          child: CustomCardContainer(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CustomNetworkImageWidget(
                                        height: 70,
                                        radius: Dimensions.radius5,
                                        width: 70,
                                        image: '${AppConstants.onlyBaseUrl}${shop['logo'] ?? "N/A"}', // or use your own local placeholder asset
                                      ),
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
                                  ),
                                  sizedBoxDefault(),
                                  CustomButtonWidget(
                                    icon: Icons.arrow_forward,
                                    height: 40,
                                    color: Theme.of(context).disabledColor,
                                    buttonText: "View Store",
                                    onPressed: () {
                                      Get.to(() => WholeSellerShopDetails(title: shop['name'].toString(), id:  shop['id'].toString(),));
                                    },
                                    fontSize: Dimensions.fontSize14,
                                  )
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
