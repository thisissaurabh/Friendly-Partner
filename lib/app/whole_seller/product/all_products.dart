import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:get/get.dart';

import '../../../data/repo/whole_seller.dart';
import '../../../utils/styles.dart';
import 'edit_product.dart';
class AllWholeSellerProducts extends StatelessWidget {
  const AllWholeSellerProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final wholeC = Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WholeSellerController>().getWholeSellerAllProducts();
    });
    return SafeArea(
      child: Scaffold(
        appBar: CustomBackAppBar(title: "All Products",isBackButtonExist: true,),
        body: GetBuilder<WholeSellerController>(builder: (allProductController) {
          final list = allProductController.allWholeSellerProductsList;

          if (list == null || list.isEmpty) {
            return Center(
              child: Text(
                "No Products Available",
                style: robotoRegular.copyWith(color: Colors.black),
              ),
            );
          }

          return  Column(
            children: [
              sizedBoxDefault(),

              Text('You have a total of ${list.length} products in your store',
              style: robotoSemiBold.copyWith(
                color: Theme.of(context).primaryColor
              ),),
           Expanded(
             child: ListView.separated(
               shrinkWrap: true,
                       padding: const EdgeInsets.all(16),
                       itemCount: list.length,
                       itemBuilder: (context, index) {
              final product = list[index];

              return CustomCardContainer(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image section
                      CustomNetworkImageWidget(
                        image: product['thumbnail'].toString().startsWith('http')
                            ? product['thumbnail']
                            : '${AppConstants.onlyBaseUrl}${product['thumbnail']}',
                        height: 90,
                        width: 90,
                      ),
                      const SizedBox(width: 12),
                      // Info section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              product['name'] ?? '',
                              style: robotoMedium.copyWith(fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            // Brand
                            if (product['brand'] != null)
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                'Brand: ${product['brand']}',
                                style: robotoRegular.copyWith(fontSize: 14),
                              ),

                            const SizedBox(height: 4),

                            // Price row
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '₹${product['discount_price']}',
                                    style: robotoBold.copyWith(fontSize: 14, color: Colors.green),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    '₹${product['price']}',
                                    style: robotoRegular.copyWith(
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Active/Inactive button
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: OutlinedButton(
                                    onPressed: () {
                                     allProductController.postProductStatusChange(productId: product['id'].toString());
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: product['is_active'] ? Colors.green : Colors.red,
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    child: Text(
                                      product['is_active'] ? 'Active' : 'Inactive',
                                      style: TextStyle(
                                        color: product['is_active'] ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Get.to(() => UpdateProduct(product: list[index],));

                                    },
                                    style: OutlinedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor,

                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    child: Text(
                                       'Edit',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                ,
              );
                       }, separatorBuilder: (BuildContext context, int index) => sizedBox10(),
                      ),
           ),



                    ],
          );
        })


      ),
    );
  }
}
