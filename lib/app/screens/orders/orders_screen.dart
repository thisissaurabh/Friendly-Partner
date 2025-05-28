// import 'package:flutter/material.dart';
// import 'package:friendly_partner/app/screens/orders/orders_list.dart';
// import 'package:friendly_partner/app/widgets/custom_appbar.dart';
// import 'package:friendly_partner/controllers/orders_controller.dart';
// import 'package:friendly_partner/controllers/whole_seller_controller.dart';
// import 'package:friendly_partner/data/repo/whole_seller.dart';
// import 'package:friendly_partner/utils/dimensions.dart';
// import 'package:friendly_partner/utils/sizeboxes.dart';
// import 'package:friendly_partner/utils/styles.dart';
// import 'package:get/get.dart';
//
// import '../../../utils/images.dart';
//
// class OrdersScreen extends StatelessWidget {
//   final bool? isBackButton;
//   OrdersScreen({super.key, this.isBackButton = false});
//
//   final OrdersController controller = Get.put(OrdersController());
//
//   final List<String> tabs = ["Pending","Confirmed","Processing","Delivered","Cancelled",];
//
//   @override
//   Widget build(BuildContext context) {
//     final cartRepo = Get.put(WholeSellerRepo(apiClient: Get.find()));
//     final wholeC = Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.find<WholeSellerController>().getOrdersListApi();
//     });
//     return SafeArea(
//       child: Scaffold(
//           appBar: CustomAppBar(
//             title: "Orders",
//             isBackButtonExist: isBackButton!,
//           ),
//           body: GetBuilder<WholeSellerController>(builder: (c) {
//             final list = c.ordersList;
//
//             if (list == null || list.isEmpty) {
//               return Center(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(Images.icNoOrder,height: 160,),
//                     sizedBox10(),
//                     Text(
//                       "No Orders Available",
//                       style: robotoRegular.copyWith(color: Colors.black),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             return Column(
//               children: [
//                 Container(
//                   color: Colors.grey[200], // Background color of the tab bar
//                   child: SingleChildScrollView(scrollDirection: Axis.horizontal,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: tabs.asMap().entries.map((entry) {
//                         int index = entry.key;
//                         String tab = entry.value;
//                         return GestureDetector(
//                           // onTap: () => controller.goToTab(index),
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 right: Dimensions.paddingSizeDefault,
//                                 left: Dimensions.paddingSizeDefault,
//                                 bottom: Dimensions.paddingSize10),
//                             child: GetBuilder<OrdersController>(
//                               builder: (c) => Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       border: Border(
//                                         bottom: BorderSide(
//                                           color: c.currentIndex == index
//                                               ? Theme.of(context).primaryColor
//                                               : Colors.transparent,
//                                           width: 2,
//                                         ),
//                                       ),
//                                     ),
//                                     padding: const EdgeInsets.only(
//                                         bottom: 5), // add padding to match space
//                                     child: Text(
//                                       tab,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color: c.currentIndex == index
//                                             ? Colors.black
//                                             : Colors.grey[600],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: PageView(
//                     controller: controller.pageController,
//                     onPageChanged: (index) {
//                       controller.goToTab(index);
//                     },
//                     children: [
//                       OrdersList(
//                         title: 'Pending',
//                         orders: list
//                             .where((e) => e['order_status'] == 'Pending')
//                             .toList(),
//                       ),
//                       OrdersList(
//                         title: 'Confirm',
//                         orders: list
//                             .where((e) => (e['order_status']
//                             ==
//                             'Confirm'))
//                             .toList(),
//                       ),
//                       OrdersList(
//                         title: 'Processing',
//                         orders: list
//                             .where((e) => (
//                             e['order_status'] ==
//                                 'Processing' ||
//
//                                 e['order_status'] ==
//                                     'Pickup' ||
//                                 e['order_status'] ==
//                                     'On The Way'))
//                             .toList(),
//                       ),
//                       OrdersList(
//                         title: 'Delivered',
//                         orders: list
//                             .where((e) =>
//                         e['order_status'] ==
//                             'Delivered')
//                             .toList(),
//                       ),
//                       OrdersList(
//                         title: 'Cancelled',
//                         orders: list
//                             .where((e) =>
//                         e['order_status'] ==
//                             'Cancelled')
//                             .toList(),
//                       ),
//
//
//             // OrdersList(
//             //             title: 'Pending',
//             //             orders: list
//             //                 .where((e) =>
//             //             e['order_status']?.toString().toLowerCase() ==
//             //                 'Pending')
//             //                 .toList(),
//             //           ),
//             //           OrdersList(
//             //             title: 'Confirmed',
//             //             orders: list
//             //                 .where((e) =>
//             //             e['order_status']?.toString().toLowerCase() ==
//             //                 'Confirm')
//             //                 .toList(),
//             //           ),
//             //           OrdersList(
//             //             title: 'Processing',
//             //             orders: list
//             //                 .where((e) =>
//             //             e['order_status']?.toString().toLowerCase() ==
//             //                 'Processing')
//             //                 .toList(),
//             //           ),
//             //           OrdersList(
//             //             title: 'On The Way',
//             //             orders: list
//             //                 .where((e) =>
//             //             e['order_status']?.toString().toLowerCase() ==
//             //                 'On The Way')
//             //                 .toList(),
//             //           ),
//             //           OrdersList(
//             //             title: 'Delivered',
//             //             orders: list
//             //                 .where((e) =>
//             //             e['order_status']?.toString().toLowerCase() ==
//             //                 'Delivered')
//             //                 .toList(),
//             //           ),
//             //
//             //           OrdersList(
//             //             title: 'Cancelled',
//             //             orders: list
//             //                 .where((e) =>
//             //                     e['order_status']?.toString().toLowerCase() ==
//             //                     'Cancelled')
//             //                 .toList(),
//             //           ),
//
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           })),
//     );
//   }
//
// }


import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/orders/orders_list.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/controllers/orders_controller.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/data/repo/whole_seller.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';
import '../../../utils/images.dart';


class OrdersScreen extends StatelessWidget {
  final bool? isBackButton;
  OrdersScreen({super.key, this.isBackButton = false});

  final OrdersController controller = Get.put(OrdersController());
  final List<String> tabs = ["Pending", "Confirmed", "Processing", "Delivered", "Cancelled"];

  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final wholeC = Get.put(WholeSellerController(wholeSellerRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      wholeC.getOrdersListApi();
    });

    return DefaultTabController(
      length: tabs.length,
      initialIndex: controller.currentIndex,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              CustomAppBar(
                title: "Orders",
                isBackButtonExist: isBackButton!,
              ),
              Container(
                color: Colors.grey[200],
                child: TabBar(
                  isScrollable: true,
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[600],
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                  onTap: (index) {
                    controller.goToTab(index);
                  },
                ),
              ),
              Expanded(
                child: GetBuilder<WholeSellerController>(
                  builder: (c) {
                    final list = c.ordersList;

                    if (list == null || list.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Images.icNoOrder, height: 160),
                            sizedBox10(),
                            Text(
                              "No Orders Available",
                              style: robotoRegular.copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }

                    return TabBarView(
                      children: [
                        OrdersList(
                          title: 'Pending',
                          orders: list.where((e) => e['order_status'] == 'Pending').toList(),
                        ),
                        OrdersList(
                          title: 'Confirmed',
                          orders: list.where((e) => e['order_status'] == 'Confirm').toList(),
                        ),
                        OrdersList(
                          title: 'Processing',
                          orders: list.where((e) =>
                          e['order_status'] == 'Processing' ||
                              e['order_status'] == 'Pickup' ||
                              e['order_status'] == 'On The Way').toList(),
                        ),
                        OrdersList(
                          title: 'Delivered',
                          orders: list.where((e) => e['order_status'] == 'Delivered').toList(),
                        ),
                        OrdersList(
                          title: 'Cancelled',
                          orders: list.where((e) => e['order_status'] == 'Cancelled').toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
