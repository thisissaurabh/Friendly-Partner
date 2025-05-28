import 'package:flutter/material.dart';
import 'package:friendly_partner/app/whole_seller/home/retailer/components/retailer_search_screen.dart';
import 'package:friendly_partner/app/whole_seller/retailers/retailer_details.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_searchfield.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/data/repo/whole_seller.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

import '../../../../data/repo/home_repo.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/images.dart';
import '../../../../utils/sizeboxes.dart';
import '../components/recent_retailer_card.dart';
class RetailersScreen extends StatelessWidget {
  const RetailersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final controller = Get.put(WholeSellerController(wholeSellerRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getConnectedRetailsListApi();
    });
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Retailers",isHideCart: true,),
        body: GetBuilder<WholeSellerController>(builder: (controller) {
          final list = controller.connectedRetailersList;
          final isListEmpty = list == null || list.isEmpty;

          if (isListEmpty) {
            return Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Images.icNoRetailer,height: 160,),
                Text("No Retailers Added Yet",style: robotoMedium,)
              ],
            ));
          }

          return  Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              children: [
                CustomSearchfield(tap: () {
                  Get.to(() => RetailerSearchScreen());
                },),
                sizedBoxDefault(),

                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: list.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (_, i) {
                      return SizedBox(
                        width: Get.size.width,
                        child: RecentRetailerCard(
                          storeName: list[i]['store']['name'] ?? "Retailer",
                          location: list[i]['store']['address'] ?? "N/A",
                          onViewPressed: () {
                            Get.to(() => RetailerDetails(retailerId: list[i]['retailer_id'].toString()));
                  
                          },
                          logo: '', phone:list[i]['retailer_id'].toString(),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        sizedBoxDefault(),
                  ),
                )




              ],
            ),
          );
        })


      
      ),
    );
  }
}
