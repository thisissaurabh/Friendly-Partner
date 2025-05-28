import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/cart/cart.dart';
import 'package:friendly_partner/app/widgets/custom_notification_button.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/cart_controller.dart';
import 'package:friendly_partner/data/repo/cart_repo.dart';
import 'package:friendly_partner/utils/images.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/dimensions.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final double? height;
  final bool? isHideCart;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.isBackButtonExist = false, this.height, this.isHideCart = false,
  });

  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(CartRepo(apiClient: Get.find()));
    final controller = Get.put(CartController(cartRepo: Get.find()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(Get.find<AuthController>().isRetailerLogin()) {
        // Get.find<CartController>().getCartList();
      } else {


      }

    });
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).hintColor,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        padding: EdgeInsets.all(
          Dimensions.paddingSizeDefault,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  height: 70,
                  width: 70,
                  Images.logo,
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: CustomNotificationButton(
                          tap: () {
                            // Get.toNamed(RouteHelper.getNotificationRoute());
                          },
                        ),
                      ),
                      isHideCart! ?
                          SizedBox() :
                      Flexible(
                        child: CustomCartNotification(
                          tap: () {
                            Get.to(() => CartScreen());
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            sizedBox10(),

            Row(
              children: [
                isBackButtonExist
                    ? Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.arrow_back)),
                      )
                    : SizedBox(),

                Text(
                  title!,
                  style: robotoRegular,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>  Size.fromHeight( height ??140);
}





class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;


  const CustomBackAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.isBackButtonExist = false,
  });

  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(CartRepo(apiClient: Get.find()));
    final controller = Get.put(CartController(cartRepo: Get.find()));

    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).hintColor,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        padding: EdgeInsets.all(
          Dimensions.paddingSizeDefault,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back)),
                ),
                SvgPicture.asset(
                  height: 60,
                  width: 60,
                  Images.logo,
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: CustomNotificationButton(
                          tap: () {
                            // Get.toNamed(RouteHelper.getNotificationRoute());
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
            sizedBox10(),

          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>  Size.fromHeight(100);
}
