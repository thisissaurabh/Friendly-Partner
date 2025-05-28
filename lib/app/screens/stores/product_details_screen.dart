import 'package:flutter/material.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:friendly_partner/app/widgets/add_to_cart_dialog.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/app/widgets/decorated_containers.dart';
import 'package:friendly_partner/controllers/cart_controller.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

import '../../../utils/app_constants.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String title;
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.title,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WholeSellerController>().getProductDetails(productId: productId);
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        isBackButtonExist: true,
      ),
      body: GetBuilder<WholeSellerController>(
        builder: (controller) {
          final product = controller.productDetails;

          if (product == null || product.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<String> imageUrls = (product['thumbnails'] as List?)
              ?.map((e) => '${AppConstants.onlyBaseUrl}${e['thumbnail']}')
              .whereType<String>()
              .toList() ??
              [];
          print('Image Url : ${imageUrls}');
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                if (imageUrls.isEmpty)
                  const SizedBox.shrink()
                else
                  FanCarouselImageSlider.sliderType2(
                    indicatorActiveColor: Theme.of(context).primaryColor,
                    imagesLink: imageUrls,
                    isAssets: false,
                    autoPlay: false,
                    sliderHeight: 250,
                    currentItemShadow: const [],
                    sliderDuration: const Duration(milliseconds: 200),
                    imageRadius: Dimensions.radius20,
                    slideViewportFraction: 1,
                    initalPageIndex: 0, // Make sure this stays within bounds
                  ),
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? '',
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSize20,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      sizedBox10(),
                      Text(
                        (product['short_description'] ?? '')
                            .replaceAll(RegExp(r'<[^>]*>'), ''), // Removes all HTML tags
                        style: robotoRegular.copyWith(
                          color: Theme.of(context).highlightColor,
                        ),
                      ),

                      // Text(
                      //   product['short_description'] ?? '',
                      //   style: robotoRegular.copyWith(
                      //     color: Theme.of(context).highlightColor,
                      //   ),
                      // ),
                      sizedBox10(),
                      Text(
                        (product['description'] ?? '')
                            .replaceAll(RegExp(r'<[^>]*>'), ''), // Removes all HTML tags
                        style: robotoRegular.copyWith(
                          color: Theme.of(context).highlightColor,
                        ),
                      ),
                      // Text(
                      //   product['description'] ?? '',
                      //   style: robotoRegular.copyWith(
                      //     color: Theme.of(context).highlightColor,
                      //   ),
                      // ),
                      sizedBox20(),
                      Text(
                        "Brand: ${product['brand'] ?? 'N/A'}",
                        style: robotoMedium,
                      ),
                      sizedBox10(),
                      Text(
                        "Available Quantity: ${product['quantity']}",
                        style: robotoMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: GetBuilder<WholeSellerController>(
        builder: (controller) {
          final product = controller.productDetails;

          if (product == null || product.isEmpty) return const SizedBox();

          final price = product['discount_price'] ?? product['price'];

          return GetBuilder<CartController>(builder: (cartControl) {
            final quantity = cartControl.getQuantity(productId);
            return Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(color: Theme.of(context).highlightColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Amount:",
                          style: robotoRegular.copyWith(
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "₹ ${price.toString()}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSize24,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  sizedBox10(),

                  quantity == 0
                      ? GestureDetector(
                          onTap: () {
                            cartControl.addToCartApi(productId: productId);
                          },
                          child: Container(
                            height: 50,
                            width: Get.size.width,
                            decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius10)),
                            child: Center(
                              child: Text(
                                'Add To Cart',
                                style: robotoSemiBold.copyWith(
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context).disabledColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  cartControl.minusRemoveIncrementApi(productId: productId);
                                },
                              ),
                              Text(
                                '$quantity',
                                style: robotoSemiBold.copyWith(
                                    color: Colors.white),
                              ),
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  cartControl
                                      .cartIncrementApi(productId: productId);
                                },
                              ),
                            ],
                          ),
                        )
                  // CustomButtonWidget(
                  //   borderSideColor: Colors.black,
                  //   buttonText: "Add to Cart",
                  //   onPressed: () {
                  //     Get.dialog(AddToCartDialog());
                  //   },
                  //   color: Colors.black,
                  // ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
