import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/stores/store_products.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_searchfield.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/data/repo/whole_seller.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:friendly_partner/app/screens/home/components/connected_wholesellers_card.dart';
import 'package:get/get.dart';

import '../../../utils/images.dart';

class ConnectedWholesellerScreen extends StatelessWidget {
  final bool? ishideHeading;
  final bool? isHorizontalPaddinghide;
  final bool? isBackButton;

  const ConnectedWholesellerScreen({
    Key? key,
    this.ishideHeading = false,
    this.isHorizontalPaddinghide = false,
    this.isBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final controller =
        Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WholeSellerController>().getConnectedWholesellers();
    });

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Connected Wholesalers",
          isBackButtonExist: isBackButton!,
        ),
        body: GetBuilder<WholeSellerController>(
          builder: (control) {
            final list = control.connectedWholeSellers;

            if (list == null || list.isEmpty) {
              return Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Images.icNoRetailer,height: 160,),
                  Text("No Connected Shops Added Yet",style: robotoMedium,)
                ],
              ));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    CustomConnectedSearchfield(),
                    const SizedBox(height: 16),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        mainAxisExtent: 200,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        final store = item['store'];

                        final storeName = store?['name'] ?? 'Unknown Store';
                        final location = store?['address'] ?? 'N/A';
                        final storeId = item['store_id']?.toString() ?? '';
                        final logoUrl = store?['media_logo']?['src'] ?? '';

                        return StoreCard(
                          storeName: storeName,
                          location: location,
                          onViewPressed: () {
                            Get.to(() => StoreProductsScreen(
                                  title: storeName,
                                  id: storeId,
                                ));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
