import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/home/components/connected_wholesellers_card.dart';
import 'package:friendly_partner/app/screens/home/components/newest_store_card.dart';
import 'package:friendly_partner/app/screens/stores/store_products.dart';
import 'package:friendly_partner/app/screens/stores/stores_screen.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

class NearestStores extends StatelessWidget {
  NearestStores({
    super.key,
  });

  List<String> name = [
    "Store Name 1",
    "Store Name 2",
    "Store Name 3",
    "Store Name 4"
  ];
  List<String> location = [
    "Location of store here - Lorem Ipsum 1",
    "Location of store here - Lorem Ipsum 2",
    "Location of store here - Lorem Ipsum 3",
    "Location of store here - Lorem Ipsum 4"
  ];

  @override
  Widget build(BuildContext context) {
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
                "Nearest Stores",
                style: robotoRegular.copyWith(
                    color: Theme.of(context).highlightColor),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => StoresScreen(
                        title: 'Nearest Stores', newestStore: [],
                      ));
                },
                child: Text(
                  "See All",
                  style: robotoRegular.copyWith(
                      color: Theme.of(context).primaryColor),
                ),
              )
            ],
          ),
          // sizedBoxDefault(),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: name.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 260,
                  child: NewestStoreCard(
                    storeName: name[index],
                    location: location[index],
                    onViewPressed: () {
                      Get.to(() => StoreProductsScreen(
                            title: name[index],
                            id: '',
                          ));
                      // Handle view button press for the specific store
                      print('View button pressed for ${name[index]}');
                    },
                    rating: '3',
                    logo: '',
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
