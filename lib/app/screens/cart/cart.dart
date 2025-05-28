import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/cart/checkout.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/cart_controller.dart';
import 'package:friendly_partner/data/repo/cart_repo.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:get/get.dart';

import '../../../utils/images.dart';
import '../../widgets/loading_dialog.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(CartRepo(apiClient: Get.find()));
    final controller = Get.put(CartController(cartRepo: Get.find()));

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Cart",
          isHideCart: true,
          isBackButtonExist: true,
        ),
        body: GetBuilder<CartController>(
          builder: (controller) {

            if (controller.cart == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.cart!['cart_items'] == null ||
                controller.cart!['cart_items'].isEmpty) {
              return  Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Images.icEmptyCart,height: 160,width: 160,),
                  Text('Your cart is empty.',style: robotoBold.copyWith(
                    color: Colors.black,
                  ),),
                ],
              ));
            } else {
              final cartItems = controller.cart!['cart_items'] as List;
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final shop = cartItems[index];
                  final products = shop['products'] as List;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                             EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              shop['shop_name'] ??
                                  'Shop Name Not Available'.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),

                          ],
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, productIndex) {
                          final product = products[productIndex];


                          return CustomCardContainer(
                            isDisableBorder: true,
                            child: Row(
                              children: [
                                CustomNetworkImageWidget(
                                    width: 80,
                                    height: 80,
                                    image: '${AppConstants.onlyBaseUrl}${product['thumbnail'].toString()}'
                                ),
                                const SizedBox(width: 16),
                                Expanded(flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'] ??
                                            'Product Name Not Available',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          'Quantity: ${product['quantity'] ?? 'N/A'}'),
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
                                                text: '${product['discount_price']} ',
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
                                      // Text(
                                      //     'Price: ₹${product['price']?.toStringAsFixed(2) ?? 'N/A'}'),
                                      // if (product['discount_price'] != null)
                                      //   Text(
                                      //     'Discounted Price: ₹${product['discount_price']?.toStringAsFixed(2)}',
                                      //     style: const TextStyle(
                                      //         color: Colors.green),
                                      //   ),
                                    ],
                                  ),
                                ),
                                Expanded(child:
                                IconButton(onPressed: () {
                                    controller.deleteCartApi(productId: product['id'].toString());
                                }, icon: Icon(Icons.remove_circle,
                                color: redColor,)))
                                // Expanded(child: TextButton(onPressed: () {
                                //   print( product['id'].toString());
                                //   controller.deleteCartApi(productId: product['id'].toString());
                                // }, child: Text("Remove",style: robotoRegular.copyWith(
                                //   color: redColor
                                // ),)))
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            sizedBox10(),
                      ),
                      const Divider(),
                    ],
                  );
                },
              );
            }
          },
        ),
        bottomNavigationBar: GetBuilder<CartController>(
          builder: (controller) {
            double totalPrice = 0;
            List<int> shopIds = [];

            if (controller.cart != null &&
                controller.cart!['cart_items'] != null) {
              final cartItems = controller.cart!['cart_items'] as List;
              for (var shop in cartItems) {
                if (shop['shop_id'] != null && !shopIds.contains(shop['shop_id'])) {
                  shopIds.add(shop['shop_id']);
                }

                final products = shop['products'] as List;
                for (var product in products) {
                  totalPrice += (product['discount_price'] ?? 0) * (product['quantity'] ?? 1);

                  // totalPrice +=
                  //     (product['discount_price'] ?? product['price'] ?? 0) *
                  //         (product['quantity'] ?? 1);
                }
              }
            }
            return GetBuilder<AuthController>(builder: (controller) {
              return   SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      shopIds.isEmpty ?
                          SizedBox() :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TOTAL PRICE:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('₹${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      sizedBox10(),
                      shopIds.isEmpty ?
                      SizedBox() :
                      CustomButtonWidget(
                        buttonText: "Checkout",
                        onPressed: () async {
                          if(shopIds.isEmpty ) {
                            LoadingGif.showLoading(message: "Cart Is Empty Please Add Products To Continue", lottie: Images.lottieFailed);
                            await Future.delayed(const Duration(seconds: 3));
                            LoadingGif.hideLoading();


                          } else {
                            Get.to(() => CheckoutScreen(shopIds: shopIds,));
                          }

                        },
                      )
                    ],
                  ),
                ),
              );
            });


          },
        ),
      ),
    );
  }
}
