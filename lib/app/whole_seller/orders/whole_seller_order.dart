import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/orders/orders_list.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/controllers/orders_controller.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/data/repo/whole_seller.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

import 'component/whole_seller_order_list.dart';

class WholeSellerOrder extends StatelessWidget {
  final bool? isBackButton;
  WholeSellerOrder({super.key, this.isBackButton = false});

  final OrdersController controller = Get.put(OrdersController());

  final List<String> tabs = ["Pending","Confirmed", "Processing","Cancelled", "Delivered"];

  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final wholeC = Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WholeSellerController>().getWholeSellerOrderListApi();
    });
    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(
            title: "Orders",
            isHideCart: true,
            isBackButtonExist: isBackButton!,
          ),
          body: GetBuilder<WholeSellerController>(builder: (c) {
            final list = c.wholeSellerOrdersList;

            if (list == null || list.isEmpty) {
              return Center(
                child: Text(
                  "No Orders Available",
                  style: robotoRegular.copyWith(color: Colors.black),
                ),
              );
            }

            return Column(
              children: [
                Container(
                  color: Colors.grey[200], // Background color of the tab bar
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8), // optional vertical padding
                      child: Row(
                        children: tabs.asMap().entries.map((entry) {
                          int index = entry.key;
                          String tab = entry.value;
                          return GestureDetector(
                            onTap: () => controller.goToTab(index),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                              ),
                              child: GetBuilder<OrdersController>(
                                builder: (c) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: c.currentIndex == index
                                                ? Theme.of(context).primaryColor
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        tab,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: c.currentIndex == index
                                              ? Colors.black
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                // Container(
                //   color: Colors.grey[200], // Background color of the tab bar
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: tabs.asMap().entries.map((entry) {
                //       int index = entry.key;
                //       String tab = entry.value;
                //       return GestureDetector(
                //         // onTap: () => controller.goToTab(index),
                //         child: Padding(
                //           padding: const EdgeInsets.only(
                //               right: Dimensions.paddingSizeDefault,
                //               left: Dimensions.paddingSizeDefault,
                //               bottom: Dimensions.paddingSize10),
                //           child: GetBuilder<OrdersController>(
                //             builder: (c) => Column(
                //               mainAxisSize: MainAxisSize.min,
                //               children: [
                //                 Container(
                //                   decoration: BoxDecoration(
                //                     border: Border(
                //                       bottom: BorderSide(
                //                         color: c.currentIndex == index
                //                             ? Theme.of(context).primaryColor
                //                             : Colors.transparent,
                //                         width: 2,
                //                       ),
                //                     ),
                //                   ),
                //                   padding: const EdgeInsets.only(
                //                       bottom: 5), // add padding to match space
                //                   child: Text(
                //                     tab,
                //                     style: TextStyle(
                //                       fontWeight: FontWeight.w500,
                //                       color: c.currentIndex == index
                //                           ? Colors.black
                //                           : Colors.grey[600],
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: (index) {
                      controller.goToTab(index);
                    },
                    children: [
                      WholeSellerOrderList(
                        title: 'Pending',
                        orders: list
                            .where((e) => e['order_status'] == 'Pending')
                            .toList(),
                      ),
                      WholeSellerOrderList(
                        title: 'Confirm',
                        orders: list
                            .where((e) => (e['order_status']
                             ==
                            'Confirm'))
                            .toList(),
                      ),
                      WholeSellerOrderList(
                        title: 'Processing',
                        orders: list
                            .where((e) => (
                            e['order_status'] ==
                                'Processing' ||

                            e['order_status'] ==
                                'Pickup' ||
                            e['order_status'] ==
                                'On The Way'))
                            .toList(),
                      ),
                      WholeSellerOrderList(
                        title: 'Confirm',
                        orders: list
                            .where((e) => (e['order_status']
                            ==
                            'confirm' ||
                            e['order_status'] ==
                                'Processing' ||

                            e['order_status'] ==
                                'Pickup' ||
                            e['order_status'] ==
                                'On The Way'))
                            .toList(),
                      ),
                      WholeSellerOrderList(
                        title: 'Cancelled',
                        orders: list
                            .where((e) =>
                        e['order_status'] ==
                            'Cancelled')
                            .toList(),
                      ),
                      WholeSellerOrderList(
                        title: 'Delivered',
                        orders: list
                            .where((e) =>
                        e['order_status'] ==
                            'Delivered')
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          })),
    );
  }
}
