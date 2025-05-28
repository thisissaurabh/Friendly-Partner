import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/orders/order_details.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:get/get.dart';

import 'order_successful.dart';
class OrdersList extends StatelessWidget {
  final String title;
  final List<dynamic> orders;
  const OrdersList({super.key, required this.orders, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${orders.length.toString()} Orders',
                style: robotoRegular,
              ),
              // Row(
              //   children: [
              //     Text(
              //       "Sort By",
              //       style: robotoRegular.copyWith(
              //           color: Theme.of(context).primaryColor),
              //     ),
              //     sizedBoxW5(),
              //     Icon(
              //       Icons.import_export,
              //       color: Theme.of(context).primaryColor,
              //       size: 18,
              //     )
              //   ],
              // )
            ],
          ),
          sizedBox10(),
          Expanded(
            child: ListView.separated(
              itemCount: orders.length,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, i) {
                return CustomCardContainer(
                    child: Row(
                  children: [
                    // Image.asset(
                    //   orders,
                    //   height: 100,
                    //   width: 100,
                    // ),
                    sizedBoxW10(),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  orders[i]['order_code'] ?? 'Unknown Store',
                                  style: robotoRegular,
                                ),
                              ),
                              Text(
                                getStatusText(title),
                                style: robotoRegular.copyWith(
                                  color: getStatusColor(context, title),
                                ),
                              )

                            ],
                          ),
                          sizedBox5(),
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Order Date: ',
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSize13,
                                    color: Theme.of(context).highlightColor,
                                  ),
                                ),
                                TextSpan(
                                  text: orders[i]['placed_at'] ?? 'N/A',
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSize14,
                                    color: Theme.of(context).disabledColor,
                                  ), // Different color for "resend"
                                ),
                              ],
                            ),
                          ),
                          sizedBox10(),
                          CustomButtonWidget(height: 36,
                            radius: Dimensions.radius5,
                            buttonText: "View Details",
                          fontSize: Dimensions.fontSize12,
                          onPressed: () {
                            // Get.to(() => OrderSuccessful());
                            Get.to(() => RetailerOrderDetails(orderId: orders[i]['id'].toString()));
                          },)
                          // sizedBox5(),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         RichText(
                          //           maxLines: 2,
                          //           overflow: TextOverflow.ellipsis,
                          //           textAlign: TextAlign.start,
                          //           text: TextSpan(
                          //             children: [
                          //               TextSpan(
                          //                 text: 'Delivery Date: ',
                          //                 style: robotoRegular.copyWith(
                          //                   fontSize: Dimensions.fontSize13,
                          //                   color: Theme.of(context)
                          //                       .highlightColor,
                          //                 ),
                          //               ),
                          //               TextSpan(
                          //                 text: '10-11-12',
                          //                 style: robotoRegular.copyWith(
                          //                   fontSize: Dimensions.fontSize14,
                          //                   color:
                          //                       Theme.of(context).disabledColor,
                          //                 ), // Different color for "resend"
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //         sizedBox5(),
                          //         RichText(
                          //           maxLines: 2,
                          //           overflow: TextOverflow.ellipsis,
                          //           textAlign: TextAlign.start,
                          //           text: TextSpan(
                          //             children: [
                          //               TextSpan(
                          //                 text: 'Amount ',
                          //                 style: robotoRegular.copyWith(
                          //                   fontSize: Dimensions.fontSize13,
                          //                   color: Theme.of(context)
                          //                       .highlightColor,
                          //                 ),
                          //               ),
                          //               TextSpan(
                          //                 text: '₹ 1200',
                          //                 style: robotoRegular.copyWith(
                          //                   fontSize: Dimensions.fontSize14,
                          //                   color:
                          //                       Theme.of(context).disabledColor,
                          //                 ), // Different color for "resend"
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     Container(
                          //       decoration: BoxDecoration(
                          //           color: Colors.black, // black background
                          //           borderRadius: BorderRadius.circular(
                          //               Dimensions.radius10) // circular button
                          //           ),
                          //       padding: const EdgeInsets.all(
                          //           8), // padding inside the black circle
                          //       child: const Icon(
                          //         size: 16,
                          //         Icons.arrow_forward,
                          //         color: Colors.white, // icon color
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    )
                  ],
                ));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  sizedBox10(),
            ),
          )
        ],
      ),
    );
  }
  String getStatusText(String title) {
    switch (title.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirm':
        return 'Confirmed';
      case 'processing':
        return 'Processing';
      case 'pickup':
        return 'Pickup';
      case 'on the way':
        return 'On The Way';
      case 'cancelled':
        return 'Cancelled';
      case 'delivered':
        return 'Delivered';
      default:
        return 'Status';
    }
  }

  Color getStatusColor(BuildContext context, String title) {
    switch (title.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirm':
      case 'processing':
      case 'pickup':
      case 'on the way':
        return Theme.of(context).primaryColor;
      case 'cancelled':
        return redColor;
      case 'delivered':
        return greenColor;
      default:
        return Colors.grey;
    }
  }


}
