import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/home/components/connected_wholesellers.dart';
import 'package:friendly_partner/app/screens/home/components/newest_store_card.dart';
import 'package:friendly_partner/app/screens/stores/store_products.dart';
import 'package:friendly_partner/app/screens/stores/whole_seller_details.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_searchfield.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:get/get.dart';

class StoresScreen extends StatelessWidget {
  final String title;
  final List<dynamic> newestStore;
  const StoresScreen({super.key, required this.title, required this.newestStore});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: title,
        isBackButtonExist: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            children: [
              CustomSearchfield(),
              sizedBoxDefault(),
              ListView.separated(
                shrinkWrap: true,
                itemCount: newestStore.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) {
                  return SizedBox(
                    width: Get.size.width,
                    child: NewestStoreCard(
                      storeName: newestStore[i]['name'] ?? "Retailer",
                      location: newestStore[i]['address'] ?? "N/A",
                      onViewPressed: () {
                        Get.to(() => WholeSellerShopDetails(
                          title: newestStore[i]['name'],
                          id: newestStore[i]['id'].toString(),
                        ));
                      },
                      rating: newestStore[i]['total_reviews'],
                      logo: newestStore[i]['logo'],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    sizedBoxDefault(),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
