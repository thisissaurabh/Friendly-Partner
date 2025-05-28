import 'package:flutter/material.dart';
import 'package:friendly_partner/app/whole_seller/product/product.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../data/repo/home_repo.dart';
import '../../../data/repo/profile_repo.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/images.dart';
import '../../../utils/sizeboxes.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/styles.dart';
import '../../screens/auth/location_pick_screen.dart';
import '../../screens/cart/cart.dart';
import '../../widgets/custom_notification_button.dart';
import '../../widgets/custom_searchfield.dart';
import '../../widgets/decorated_containers.dart';
import 'components/recent_retailers_list.dart';
class WholeSellerHome extends StatelessWidget {
  const WholeSellerHome({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Get.put(HomeRepo(apiClient: Get.find()));
    final controller = Get.put(HomeController(homeRepo: Get.find()));
    final p = Get.put(ProfileRepo(apiClient: Get.find()));
    final pro = Get.put(ProfileController(profileRepo: Get.find()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HomeController>().getWholeSellerHomeData();
      pro.getWholeSellerProfileData();

    });

    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(title: "Dashboard",isBackButtonExist: false,isHideCart: true,),
        body: GetBuilder<HomeController>(builder: (homeControl) {
          final list = homeControl.wholeSellerHomeData;
          final isListEmpty = list == null || list.isEmpty;

          if (isListEmpty) {
            return SizedBox.shrink();
          }

          return SingleChildScrollView(
            child:Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                children: [
                  // DecoratedContainers(
                  //     color: Theme.of(context).primaryColor,
                  //     child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Flexible(
                  //               child: Text(
                  //                 "Your Monthly Plan",style: robotoMedium.copyWith(fontSize: Dimensions.fontSize14,
                  //                   color: Theme.of(context).cardColor),),
                  //             ),
                  //             Flexible(
                  //               child: Text(
                  //                 "ACTIVE",style: robotoRegular.copyWith(fontSize: Dimensions.fontSize14,
                  //                   color: greenColor),),
                  //             )
                  //           ],
                  //         ),
                  //         Divider(color: Colors.white,),
                  //
                  //         RichText(
                  //           maxLines: 2,
                  //           overflow: TextOverflow.ellipsis,
                  //           textAlign: TextAlign.start,
                  //           text: TextSpan(
                  //             children: [
                  //               TextSpan(
                  //                 text: 'Account Holder Name : ',
                  //                 style: robotoRegular.copyWith(
                  //                   fontSize: Dimensions.fontSize12,
                  //                   color: Theme.of(context).hintColor,
                  //                 ),
                  //               ),
                  //               TextSpan(
                  //                 text:  'Username',
                  //                 style: robotoRegular.copyWith(
                  //                   fontSize: Dimensions.fontSize14,
                  //                   color: Colors.white,
                  //                 ), // Different color for "resend"
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         sizedBoxDefault(),
                  //         RichText(
                  //           maxLines: 2,
                  //           overflow: TextOverflow.ellipsis,
                  //           textAlign: TextAlign.start,
                  //           text: TextSpan(
                  //             children: [
                  //               TextSpan(
                  //                 text: 'Amount Paid : ',
                  //                 style: robotoRegular.copyWith(
                  //                   fontSize: Dimensions.fontSize12,
                  //                   color: Theme.of(context).hintColor,
                  //                 ),
                  //               ),
                  //               TextSpan(
                  //                 text:  '₹ 299',
                  //                 style: robotoRegular.copyWith(
                  //                   fontSize: Dimensions.fontSize14,
                  //                   color: Colors.white,
                  //                 ), // Different color for "resend"
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //
                  //       ],
                  //     )),
                  // sizedBoxDefault(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: DecoratedContainers(
                            isBorder: true,
                            child: Column(
                              children: [
                                Text(list['totalProduct'].toString(),style: robotoBold.copyWith(color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSize24),),
                                sizedBox10(),
                                Text("Total Products",style: robotoRegular.copyWith(color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSize14),)
                              ],
                            )),
                      ),
                      // sizedBoxW15(),
                      // Expanded(
                      //   child: DecoratedContainers(
                      //       isBorder: true,
                      //       child: Column(
                      //         children: [
                      //           Text("50",style: robotoBold.copyWith(color: Theme.of(context).primaryColor,
                      //               fontSize: Dimensions.fontSize24),),
                      //           sizedBox10(),
                      //           Text("Products Sold",style: robotoRegular.copyWith(color: Theme.of(context).primaryColor,
                      //               fontSize: Dimensions.fontSize14),)
                      //         ],
                      //       )),
                      // )
                    ],),
                  sizedBoxDefault(),
                  CustomButtonWidget(buttonText: "+ Add Product",onPressed: () {
                    Get.to(() => AddProducts());
                    // Get.to(()
                  },
                    transparent: true,
                    textColor: Theme.of(context).primaryColor,
                    borderSideColor:  Theme.of(context).primaryColor,),
                  sizedBoxDefault(),
                  RecentRetailersList(recentRetailers: list['recent_retails_partner'] as List,),
                ],
              ),
            ),
          );
        })
      ),
    );
  }
}
