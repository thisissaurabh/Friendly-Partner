import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendly_partner/app/whole_seller/home/components/recent_retailer_card.dart';
import 'package:friendly_partner/app/whole_seller/home/retailer/all_retailers.dart';
import 'package:friendly_partner/utils/dimensions.dart';

import '../../../../utils/sizeboxes.dart';
import '../../../../utils/styles.dart';
import 'package:get/get.dart';

import '../../../screens/home/components/newest_store_card.dart';
import '../../retailers/retailer_details.dart';
class RecentRetailersList extends StatelessWidget {
  final List<dynamic> recentRetailers;
  final bool? isSeeAll;
  const RecentRetailersList({super.key, required this.recentRetailers, this.isSeeAll = false});

  @override
  Widget build(BuildContext context) {

    return recentRetailers.isEmpty ?
        Text("No Retailers Connected Yet",style: robotoBold,) :
      Column(
      children: [
        isSeeAll! ?
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Text(
            textAlign: TextAlign.start,
            "${recentRetailers.length } Retailers Connected",
            style: robotoBold.copyWith(
                color: Theme.of(context).primaryColor),
          ),
        ) :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Retail Partners",
              style: robotoRegular.copyWith(
                  color: Theme.of(context).highlightColor),
            ),

            recentRetailers.length >= 6 ?
            TextButton(
              onPressed: () {
                Get.to(() => SeeAllRetailers());

              },
              child: Text(
                "See All",
                style: robotoRegular.copyWith(
                    color: Theme.of(context).primaryColor),
              ),
            ) : TextButton(
              onPressed: () {

              },
              child: Text(
                "",
                style: robotoRegular.copyWith(
                    color: Theme.of(context).primaryColor),
              ),
            )
            // newestStore.length >= 6
            //     ? TextButton(
            //         onPressed: () {
            //           Get.to(() => StoresScreen(
            //                 title: 'Newest Stores',
            //               ));
            //         },
            //         child: Text(
            //           "See All",
            //           style: robotoRegular.copyWith(
            //               color: Theme.of(context).primaryColor),
            //         ),
            //       )
            //     : SizedBox()

          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: recentRetailers.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, i) {
            return SizedBox(
              width: Get.size.width,
              child: RecentRetailerCard(
                storeName: recentRetailers[i]['customer']['name'] ?? "Retailer",
                location: recentRetailers[i]['customer']['address'] ?? "N/A",
                onViewPressed: () {
                  Get.to(() => RetailerDetails(retailerId:  recentRetailers[i]['retailer_id'].toString()));

                },

                logo: '', phone:recentRetailers[i]['retailer_id'].toString(),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              sizedBoxDefault(),
        )
      ],
    );
  }
}
