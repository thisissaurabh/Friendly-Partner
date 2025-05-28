import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:get/get.dart';
import '../../../data/repo/whole_seller.dart';
import '../../../utils/styles.dart';
import '../../widgets/verify_wholeseller.dart';

class WholeSellerShopDetails extends StatelessWidget {
  final String title;
  final String id;
  const WholeSellerShopDetails({super.key, required this.title, required this.id});

  @override
  Widget build(BuildContext context) {
    final repo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final controller =
    Get.put(WholeSellerController(wholeSellerRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WholeSellerController>().getWholeSellerShopDetails(id: id);
    });

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: title,isBackButtonExist: true,),
        body: GetBuilder<WholeSellerController>(builder: (controller) {
          final data = controller.wholeSellerDetails;
          final shops = data?['shop'] as List<dynamic>?;
      
          if (shops == null || shops.isEmpty) {
            return SizedBox();
          }
      
          final shop = shops.first;
          return Stack(
            children: [
              SizedBox(height: Get.size.height,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
      
                      // Shop logo and name
                      Row(
                        children: [
                          CustomNetworkImageWidget(
                            height: 100,width: 100,
                            image:   '${AppConstants.onlyBaseUrl}/${shop['logo']}',),
      
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              shop['name'] ?? '',
                              style: robotoBold.copyWith(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Address : ${shop['address'] ?? ''}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSize14,
                        color: Theme.of(context).disabledColor.withOpacity(0.70)),
                      ),
                      sizedBoxDefault(),
      
                      // Shop stats
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          _StatTile(title: 'Total Products', value: '${shop['total_products']}'),
                          // _StatTile(title: 'Categories', value: '${shop['total_categories']}'),
                          // _StatTile(title: 'Rating', value: '${shop['rating']}'),
                          // _StatTile(title: 'Reviews', value: '${shop['total_reviews']}'),
                          // _StatTile(title: 'Connected', value: '${shop['connected_count']}'),
                        ],
                      ),
                      sizedBoxDefault(),
                      shop['connected_count'] == 0 ?
                      CustomButtonWidget(
                        buttonText: "Connect Now",
                        onPressed: () {
                          Get.dialog(VerifyWholesellerDialog(shopId: shop['id'],));
                        },) : const SizedBox(),
      
      
      
                    ],
                  ),
                ),
              ),
              // Positioned(bottom: Dimensions.paddingSizeDefault,left: Dimensions.paddingSizeDefault,
              //   right: Dimensions.paddingSizeDefault,
              //   child: shop['connected_count'] == 0 ?
              //   CustomButtonWidget(
              //     buttonText: "Connect Now",
              //     onPressed: () {
              //       Get.dialog(VerifyWholesellerDialog(shopId: shop['id'],));
              //     },) : const SizedBox(),
              // ),
            ],
          );
        }),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;

  const _StatTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.size.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${title} : ', style: robotoRegular.copyWith(color: Colors.grey.shade600)),
              Text(value, style: robotoBold.copyWith(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
