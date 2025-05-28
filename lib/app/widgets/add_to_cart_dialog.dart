import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/images.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

class AddToCartDialog extends StatelessWidget {
  AddToCartDialog({
    super.key,
  });
  final _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
          EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Dimensions.paddingSize20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(Dimensions.paddingSizeDefault)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Add Product Quantity",
                  style: robotoSemiBold.copyWith(
                      fontSize: Dimensions.fontSize20,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSize25,
                    vertical: Dimensions.paddingSize10),
                child: Image.asset(Images.icArrowLine),
              ),
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                "Product Name",
                style: robotoRegular,
              ),
              Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                "Lorem Ipsum is simply",
                style: robotoRegular.copyWith(
                    color: Theme.of(context).highlightColor,
                    fontSize: Dimensions.fontSize14),
              ),
              sizedBox20(),
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                "Quantity of product",
                style: robotoRegular,
              ),
              sizedBox10(),
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: Dimensions.paddingSize5),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5, color: Theme.of(context).highlightColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: CustomSquareButton(
                        icon: Icons.remove,
                        tap: () {},
                        color: Colors.white,
                        iconColor: Theme.of(context).highlightColor,
                      ),
                    ),
                    Flexible(
                      child: Text("1"),
                    ),
                    Flexible(
                      child: CustomSquareButton(
                        icon: Icons.add,
                        tap: () {},
                        color: Theme.of(context).hintColor,
                        iconColor: Theme.of(context).highlightColor,
                      ),
                    )
                  ],
                ),
              ),
              sizedBox20(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          "₹ 1200",
                          style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSize24,
                              color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          "Total Amount",
                          style: robotoRegular.copyWith(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CustomButtonWidget(
                      borderSideColor: Colors.black,
                      buttonText: "Add to Cart",
                      onPressed: () {
                        Get.dialog(AddToCartDialog());
                      },
                      color: Colors.black,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
