import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/search/search_screen.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

class CustomSearchfield extends StatelessWidget {
  final Function()? tap;
  const CustomSearchfield({super.key,  this.tap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap ?? () {
        Get.to(() => SearchScreen());
      },
      child: Container(
        height: 45,
        padding:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize5),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSize5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)
          ],
        ),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "  Search  ",
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSize13,
                        color: Theme.of(context)
                            .highlightColor), // Different color for "resend"
                  ),
                ],
              ),
            ),
            const Spacer(),
            Icon(
              Icons.search,
              color: Theme.of(context).highlightColor,
            )
          ],
        ),
      ),
    );
  }
}





class CustomProductSearchfield extends StatelessWidget {
  final Function()? tap;
  final String shopId;
  final String shopName;
  const CustomProductSearchfield({super.key,  this.tap, required this.shopId, required this.shopName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap ?? () {
        Get.to(() => SearchShopProductScreen(shopId: shopId, shopName: shopName,));
      },
      child: Container(
        height: 45,
        padding:
        const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize5),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSize5),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5)
          ],
        ),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "  Search  ",
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSize13,
                        color: Theme.of(context)
                            .highlightColor), // Different color for "resend"
                  ),
                ],
              ),
            ),
            const Spacer(),
            Icon(
              Icons.search,
              color: Theme.of(context).highlightColor,
            )
          ],
        ),
      ),
    );
  }
}


class CustomConnectedSearchfield extends StatelessWidget {
  final Function()? tap;
  const CustomConnectedSearchfield({super.key,  this.tap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap ?? () {
        Get.to(() => ConnectedShopSearchScreen());
      },
      child: Container(
        height: 45,
        padding:
        const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize5),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSize5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)
          ],
        ),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "  Search Connected Shops ",
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSize13,
                        color: Theme.of(context)
                            .highlightColor), // Different color for "resend"
                  ),
                ],
              ),
            ),
            const Spacer(),
            Icon(
              Icons.search,
              color: Theme.of(context).highlightColor,
            )
          ],
        ),
      ),
    );
  }
}



