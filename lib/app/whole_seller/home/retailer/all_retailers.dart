import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:get/get.dart';
import '../../../../controllers/home_controller.dart';
import '../../../../data/repo/home_repo.dart';
import '../components/recent_retailers_list.dart';

class SeeAllRetailers extends StatelessWidget {
  const SeeAllRetailers({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Get.put(HomeRepo(apiClient: Get.find()));
    final controller = Get.put(HomeController(homeRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HomeController>().getWholeSellerHomeData();

    });
    return Scaffold(
      appBar: CustomAppBar(title: "All Connected Retailers",isBackButtonExist: true,isHideCart: true,),
      body: GetBuilder<HomeController>(builder: (homeControl) {
        final list = homeControl.wholeSellerHomeData;
        final isListEmpty = list == null || list.isEmpty;

        if (isListEmpty) {
          return SizedBox.shrink();
        }
        return   Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: RecentRetailersList(recentRetailers: list['recent_retails_partner'] as List,isSeeAll: true,),
        );
      })



    );
  }
}
