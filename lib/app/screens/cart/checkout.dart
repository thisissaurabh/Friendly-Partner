import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/app/widgets/custom_textfield.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/cart_controller.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

import '../../../data/repo/cart_repo.dart';
import '../../widgets/address_list_bottomsheet.dart';

class CheckoutScreen extends StatelessWidget {
  final List<dynamic> shopIds;
   CheckoutScreen({super.key, required this.shopIds});
  final _noteController = TextEditingController(text: "");
  String _selectedPaymentMethod = 'cod';
  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(CartRepo(apiClient: Get.find()));
    final controller = Get.put(CartController(cartRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCheckoutCart(shopIds: shopIds);
    });

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Place Order", isBackButtonExist: true, isHideCart: true),
        body: GetBuilder<CartController>(builder: (controller) {
          final data = controller.cartCheckout;
          final isDataEmpty = data == null || data.isEmpty;

          if (isDataEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final checkout = data['checkout'];
          final checkoutItems = data['checkout_items'] as List<dynamic>;

          return


            Stack(
              children: [
                SizedBox(height: Get.size.height,
                  child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Checkout Summary
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text("Order Summary", style: robotoBold),
                              const SizedBox(height: 8),
                              _buildSummaryRow("Total Amount (After discount)", checkout['total_amount']),
                              _buildSummaryRow("Delivery Charge", checkout['delivery_charge']),
                              _buildSummaryRow("Coupon Discount", checkout['coupon_discount']),
                              _buildSummaryRow("Tax", checkout['order_tax_amount']),
                              const Divider(),
                              _buildSummaryRow("Payable Amount", checkout['payable_amount'], bold: true),
                            ],
                          ),
                        ),
                      ),
                      sizedBoxDefault(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Payment Method", style: robotoBold),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Cash on Delivery (COD)"),
                        value: 'cod',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          _selectedPaymentMethod = value!;
                        },
                      ),
                      sizedBoxDefault(),


                      /// Items from each shop
                      ...checkoutItems.map((shop) {
                        final shopName = shop['shop_name'];
                        final products = shop['products'] as List<dynamic>;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(shopName, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            ...products.map((product) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  leading: CustomNetworkImageWidget(
                                    height: 50,width: 50,
                                      image: '${AppConstants.onlyBaseUrl}${product['thumbnail']}'),
                                  title: Text(product['name'] ?? ''),
                                  subtitle: Text("Total Quantity : ${product['quantity']}"),
                                  trailing: Text("₹${product['discount_price'] ?? product['price']}"),
                                ),
                              );
                            }).toList()
                          ],
                        );
                      }).toList(),
                      sizedBox100(),
                      sizedBox100(),
                      sizedBox100(),
                      sizedBox100(),
                      sizedBox100(),

                    ],
                  ),
                            ),
                ),
                Positioned(bottom: Dimensions.paddingSizeDefault,
                  left: 0,right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: SingleChildScrollView(
                        child: GetBuilder<AuthController>(builder: (authControl) {
                          return  Column(
                            children: [
                              Container(
                                color: Theme.of(context).cardColor,
                                child: CustomTextField(
                                  hintText: 'Add Delivery Note',
                                  controller: _noteController,
                                  capitalization: TextCapitalization.words,
                                  maxLines: 3,
                                ),
                              ),
                              sizedBox10(),
                              CustomButtonWidget(buttonText: "Place Order",
                                onPressed: () {
                                  Get.bottomSheet(AddressListBottomSheet(note: _noteController.text.trim(),
                                    shopIds: shopIds,));
                                },
                                color: Theme.of(context).primaryColor,),
                            ],
                          );
                        })

                    ),
                  ),
                ),
              ],
            );
        }),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        //   child: SingleChildScrollView(
        //     child: GetBuilder<AuthController>(builder: (authControl) {
        //     return  Column(
        //       children: [
        //         CustomTextField(
        //           hintText: 'Add Delivery Note',
        //           controller: _noteController,
        //           capitalization: TextCapitalization.words,
        //           maxLines: 3,
        //         ),
        //         sizedBox10(),
        //
        //         CustomButtonWidget(buttonText: "Place Order",
        //             onPressed: () {
        //                Get.bottomSheet(AddressListBottomSheet(note: _noteController.text.trim(),
        //                  shopIds: shopIds,));
        //             },
        //             color: Theme.of(context).primaryColor,),
        //       ],
        //     );
        //     })
        //
        //   ),
        // ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, dynamic value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: bold ? robotoMedium : robotoRegular

          ),
          Flexible(
            child: Text(maxLines: 2,overflow: TextOverflow.ellipsis,
                "₹${value.toStringAsFixed(2)}",
                style: bold ? robotoMedium : robotoRegular
            ),
          ),
        ],
      ),
    );
  }
}
