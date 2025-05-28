import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_textfield.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/data/apis/api_client.dart';
import 'package:friendly_partner/data/repo/auth_repo.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/images.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';
import '../../data/repo/whole_seller.dart';
import '../../utils/dimensions.dart';
import 'custom_button.dart';
import 'package:get/get.dart';
class VerifyWholesellerDialog extends StatelessWidget {
  final int shopId;
  VerifyWholesellerDialog({
    super.key,
    required this.shopId,
  });

  final _accessToken = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repo = Get.put(WholeSellerRepo(apiClient:  Get.find()));
    final controller = Get.put(WholeSellerController(wholeSellerRepo: Get.find()));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius10),
      ),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetBuilder<WholeSellerController>(
        builder: (_) {
          return SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSize20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  sizedBox20(),
                  Text(
                    "Verify Wholesaler ID",
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSize20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSize30,
                      vertical: Dimensions.paddingSize10,
                    ),
                    child: Image.asset(Images.icArrowLine),
                  ),
                  CustomTextField(
                    showTitle: true,
                    controller: _accessToken,
                    hintText: "Add Access Token of Wholeseller",
                  ),
                  sizedBox30(),
                  CustomButtonWidget(
                    buttonText: "Proceed",
                    onPressed: () {
                      controller.connectWholeSellerApi(
                        shopId: shopId.toString(),
                        accessToken: _accessToken.text.trim(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
