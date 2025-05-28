import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/home/components/connected_wholesellers_card.dart';
import 'package:friendly_partner/app/screens/partners/connected_wholeseller_screen.dart';
import 'package:friendly_partner/app/screens/stores/store_products.dart';
import 'package:friendly_partner/helper/route_helper.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

import '../../../../utils/images.dart';

class ConnectedWholesellers extends StatelessWidget {
  final bool? ishideHeading;
  final bool? isHorizontalPaddinghide;
  final bool? isBackButton;
  final List<dynamic> connectedWholeSeller;
  ConnectedWholesellers(
      {super.key,
      this.ishideHeading = false,
      this.isHorizontalPaddinghide = false,
      this.isBackButton = false,
      required this.connectedWholeSeller});

  @override
  Widget build(BuildContext context) {

    final validStores = connectedWholeSeller
        .where((element) => element['store'] != null)
        .toList();
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.paddingSize5,
          horizontal:
              isHorizontalPaddinghide! ? 0 : Dimensions.paddingSizeDefault),
      child: Column(
        children: [
          ishideHeading!
              ? SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Connected Wholesalers",
                      style: robotoRegular.copyWith(
                          color: Theme.of(context).highlightColor),
                    ),
                    connectedWholeSeller.length >= 6
                        ? TextButton(
                            onPressed: () {
                              Get.to(() => ConnectedWholesellerScreen(
                                    ishideHeading: ishideHeading,
                                    isHorizontalPaddinghide:
                                        isHorizontalPaddinghide,
                                    isBackButton: true,
                                  ));
                            },
                            child: Text(
                              "See All",
                              style: robotoRegular.copyWith(
                                  color: Theme.of(context).primaryColor),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
          sizedBoxDefault(),
          validStores.isEmpty ?
          SizedBox(
            height: 180,
            child:    Center(child: Text("No Connected Shop Found"))
          ) :
          GridView.builder(
            physics:
                const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // childAspectRatio:
              //     1 / 0.6, // Adjust as needed for card proportions
              crossAxisSpacing: 15,
              mainAxisExtent: 200,
              mainAxisSpacing: 15,
            ),
            itemCount: connectedWholeSeller.length > 4
                ? 4
                : connectedWholeSeller.length,

            itemBuilder: (context, index) {
              return
                StoreCard(storeName: connectedWholeSeller[index]['store'] != null
                      ? connectedWholeSeller[index]['store']['name'] ?? "N/A"
                      : "N/A".toUpperCase(),
                  location: connectedWholeSeller[index]['store']['address'] ?? "N/A",
                  onViewPressed: () {
                    Get.to(() => StoreProductsScreen(
                      title: connectedWholeSeller[index]['store'] != null
                          ? connectedWholeSeller[index]['store']['name'] ?? "N/A"
                          : "N/A",
                      id: connectedWholeSeller[index]['store_id'].toString(),
                    ));
                  },
                );

            },
          ),
        ],
      ),
    );
  }
}
