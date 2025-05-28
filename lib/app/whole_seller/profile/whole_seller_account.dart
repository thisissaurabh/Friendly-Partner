import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/profile/my_profile_screen.dart';
import 'package:friendly_partner/app/screens/profile/support_ticket.dart';
import 'package:friendly_partner/app/whole_seller/profile/whole_seller_profile.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/helper/route_helper.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friendly_partner/utils/images.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:get/get.dart';

import '../../../controllers/profile_controller.dart';
import '../../screens/auth/signin_dashboard.dart';
import '../../screens/support/support_ticket.dart';
import '../../widgets/confirmation_dialog.dart';
import '../product/all_products.dart';

class WholeSellerAccount extends StatelessWidget {
  final bool? isBackButton;
  const WholeSellerAccount({super.key, this.isBackButton = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            isHideCart: true,
            title: "Account",
            isBackButtonExist: isBackButton!,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                children: [
                  row(
                      img: Images.svgProfile,
                      title: 'Account',
                      tap: () {

                        Get.to(() => MyWholeSellerProfileScreen());
                      }),
                  Divider(
                    color: Theme.of(context).highlightColor,
                  ),
                  // row(
                  //     img: Images.svgSupport,
                  //     title: 'Support Ticket',
                  //     tap: () {
                  //       // Get.to(() => SupportTicketScreen());
                  //       Get.to(() => AllSupportTicketScreen());
                  //     }),
                  //
                  // Divider(
                  //   color: Theme.of(context).highlightColor,
                  // ),
                  row(img: Images.svgInventory, title: 'Inventory', tap: () {
                    Get.to(() => AllWholeSellerProducts());

                  }),
                  // Divider(
                  //   color: Theme.of(context).highlightColor,
                  // ),
                  // row(img: Images.svgPlans, title: 'Plans', tap: () {}),
                  Divider(
                    color: Theme.of(context).highlightColor,
                  ),
                  row(img: Images.svgPrivacy, title: 'Privacy Policy', tap: () {}),
                  Divider(
                    color: Theme.of(context).highlightColor,
                  ),
                  row(
                      img: Images.svgTerms,
                      title: 'Terms & Conditions',
                      tap: () {}),
                  sizedBox30(),
                  CustomButtonWidget(
                    buttonText: "Log out",
                    onPressed: () {
                      Get.dialog(ConfirmationDialog(icon: Icons.exit_to_app,
                          description: "Are You Sure Logout", onYesPressed: () {
                            Get.to(() => SigningDashboard());
                          }));
                    },
                    transparent: true,
                    textColor: redColor,
                    borderSideColor: redColor,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Padding row(
      {required String img, required String title, required Function() tap}) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: GestureDetector(
        onTap: tap,
        child: Row(
          children: [
            SvgPicture.asset(
              height: 30,
              width: 30,
              img,
            ),
            sizedBoxW10(),
            Text(
              title,
              style: robotoRegular,
            )
          ],
        ),
      ),
    );
  }
}
