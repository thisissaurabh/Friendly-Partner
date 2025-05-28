import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/home/components/connected_wholesellers.dart';
import 'package:friendly_partner/app/screens/home/components/newest_store_card.dart';
import 'package:friendly_partner/app/screens/stores/product_details_screen.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/app/widgets/custom_searchfield.dart';
import 'package:friendly_partner/controllers/cart_controller.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/data/repo/cart_repo.dart';
import 'package:friendly_partner/data/repo/whole_seller.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

class StoreProductsScreen extends StatelessWidget {
  final String title;
  final String id;
  const StoreProductsScreen({super.key, required this.title, required this.id});

  @override
  Widget build(BuildContext context) {
    final repo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final controller =
        Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
    final cartRepo = Get.put(CartRepo(apiClient: Get.find()));
    final control = Get.put(CartController(cartRepo: Get.find()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WholeSellerController>().getShopProducts(shopId: id);
    });
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: title,
          isBackButtonExist: true,
        ),
        body: GetBuilder<WholeSellerController>(
          builder: (controller) {
            final data = controller.shopProducts;
            final products = data?['products'] as List<dynamic>?;
            if (products == null || products.isEmpty) {
              return Center(
                child: Text(
                  "No Data Available",
                  style: robotoRegular.copyWith(color: Colors.black),
                ),
              );
            }
            return GetBuilder<CartController>(
              builder: (cartControl) {
                return SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(
                      children: [
                        CustomProductSearchfield(shopId: id, shopName: title,),
                        sizedBox10(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: robotoRegular,
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       "Filter",
                            //       style: robotoRegular.copyWith(
                            //           color: Theme.of(context).primaryColor),
                            //     ),
                            //     sizedBoxW5(),
                            //     Icon(
                            //       Icons.tune,
                            //       color: Theme.of(context).primaryColor,
                            //       size: 18,
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                        sizedBoxDefault(),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: products.length,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(16),
                          itemBuilder: (_, i) {
                            final product = products[i];
                            final productId = product['id'].toString();
                            final productName = product['name'] ?? 'Unknown';
                            final productPrice =
                                product['discount_price']?.toString() ?? '0';
                            final productThumbnail = product['thumbnail'] ?? '';
                            final quantity = cartControl.getQuantity(productId);

                            return SizedBox(
                              width: Get.size.width,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => ProductDetailsScreen(
                                        title: productName,
                                        productId: productId,
                                      ));
                                },
                                child: CustomCardContainer(
                                  child: Row(
                                    children: [
                                      CustomNetworkImageWidget(
                                          height: 80,
                                          width: 80,
                                          image: '${AppConstants.onlyBaseUrl}${productThumbnail}'),
                                      sizedBoxW10(),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              productName,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: robotoMedium.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeDefault),
                                            ),
                                            sizedBox10(),
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

                                            // RichText(
                                            //   maxLines: 2,
                                            //   overflow: TextOverflow.ellipsis,
                                            //   textAlign: TextAlign.start,
                                            //   text: TextSpan(
                                            //     children: [
                                            //       TextSpan(
                                            //         text: 'Price for one: ',
                                            //         style:
                                            //             robotoRegular.copyWith(
                                            //           fontSize:
                                            //               Dimensions.fontSize12,
                                            //           color: Theme.of(context)
                                            //               .highlightColor,
                                            //         ),
                                            //       ),
                                            //       TextSpan(
                                            //         text: '₹ $productPrice',
                                            //         style:
                                            //             robotoSemiBold.copyWith(
                                            //           fontSize:
                                            //               Dimensions.fontSize15,
                                            //           color: Theme.of(context)
                                            //               .primaryColor,
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      sizedBoxW7(),
                                      quantity == 0
                                          ? CustomSquareButton(
                                              icon: Icons.add,
                                              tap: () {
                                                cartControl.addToCartApi(productId: productId);
                                              },
                                            )
                                          : Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.remove),
                                                  onPressed: () {
                                                    cartControl.minusRemoveIncrementApi(productId: productId);
                                                    // cartControl.decrement(productId);
                                                  },
                                                ),
                                                Text('$quantity'),
                                                IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: () {
                                                    cartControl
                                                        .cartIncrementApi(productId: productId);

                                                  },
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => sizedBoxDefault(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
