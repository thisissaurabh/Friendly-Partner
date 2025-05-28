import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/home/components/connected_wholesellers_card.dart';
import 'package:friendly_partner/app/screens/home/components/newest_store_card.dart';
import 'package:friendly_partner/app/screens/stores/store_products.dart';
import 'package:friendly_partner/app/screens/stores/stores_screen.dart';
import 'package:friendly_partner/app/screens/stores/whole_seller_details.dart';
import 'package:friendly_partner/app/widgets/verify_wholeseller.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

class NewestStore extends StatelessWidget {
  final List<dynamic> newestStore;
  const NewestStore({super.key, required this.newestStore});

  @override
  Widget build(BuildContext context) {
    print('NEw: ${newestStore}');
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.paddingSize5,
          horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Newest Stores",
                style: robotoRegular.copyWith(
                    color: Theme.of(context).highlightColor),
              ),
              // TextButton(
              //   onPressed: () {
              //     Get.to(() => StoresScreen(
              //           title: 'Newest Stores', newestStore: newestStore,
              //         ));
              //   },
              //   child: Text(
              //     "See All",
              //     style: robotoRegular.copyWith(
              //         color: Theme.of(context).primaryColor),
              //   ),
              // )
              newestStore.length >= 6
                  ?
              TextButton(
                      onPressed: () {
                        Get.to(() => StoresScreen(
                              title: 'Newest Stores', newestStore:newestStore,
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
          // sizedBoxDefault(),
          newestStore.isEmpty ?
              SizedBox(  height: 180,
                  child: Center(child: Text("No Shop Available Yet"))) :
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: newestStore.length,
              itemBuilder: (context, index) {
                print('${newestStore[index]['name']}');
                return SizedBox(
                  width: 260,
                  child: NewestStoreCard(
                    storeName: newestStore[index]['name'],
                    location: newestStore[index]['address'] ?? "N/A",
                    onViewPressed: () {
                      // Get.to(() => StoreProductsScreen(
                      //   title: newestStore[index]['name'],
                      //   id: newestStore[index]['id'].toString(),
                      // ));

                      Get.to(() => WholeSellerShopDetails(
                        title: newestStore[index]['name'],
                        id: newestStore[index]['id'].toString(),
                      ));
                    },
                    rating: newestStore[index]['total_reviews'],
                    logo: newestStore[index]['logo'],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  sizedBoxW15(),
            ),
          ),
        ],
      ),
    );
  }
}
