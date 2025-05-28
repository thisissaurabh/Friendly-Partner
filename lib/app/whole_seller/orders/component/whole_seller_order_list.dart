import 'package:flutter/material.dart';
import 'package:friendly_partner/app/whole_seller/orders/component/order_details.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/app/widgets/decorated_containers.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:get/get.dart';
class WholeSellerOrderList extends StatelessWidget {
  final String title;
  final List<dynamic> orders;
  const WholeSellerOrderList({super.key, required this.orders, required this.title});

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
                        CustomNetworkImageWidget(
                          height: 100,width: 100,
                            image: "${AppConstants.onlyBaseUrl}${orders[i]['products'][0]['thumbnail'] ?? 'Unknown Store'}",
                        ),
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
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => OrderDetails(orderId:   orders[i]['id'].toString(),));
                                    },
                                    child: DecoratedContainers(
                                      padding: Dimensions.paddingSize8,
                                      color: Theme.of(context).disabledColor,
                                        child: Icon(Icons.arrow_right_alt,color:Colors.white ,)),
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
                                      text: orders[i]['order_placed'] ?? 'N/A',
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSize14,
                                        color: Theme.of(context).disabledColor,
                                      ), // Different color for "resend"
                                    ),
                                  ],
                                ),
                              ),
                              sizedBox5(),
                              RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Delivery Date: ',
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSize13,
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: orders[i]['delivery_date'] ?? 'N/A',
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSize14,
                                        color: Theme.of(context).disabledColor,
                                      ), // Different color for "resend"
                                    ),
                                  ],
                                ),
                              ),
                              sizedBox5(),
                              RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Amount : ',
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSize13,
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: orders[i]['amount'].toString(),
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSize14,
                                        color: Theme.of(context).disabledColor,
                                      ), // Different color for "resend"
                                    ),
                                  ],
                                ),
                              ),

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
}
