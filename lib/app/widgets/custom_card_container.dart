import 'package:flutter/material.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:get/get.dart';

class CustomCardContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final bool? isDisableBorder;
  final Color? color;
  const CustomCardContainer(
      {super.key,
      required this.child,
      this.width,
      this.isDisableBorder = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Get.size.width,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: color ?? Colors.white ,
        border: Border.all(
            width: 0.3,
            color: isDisableBorder!
                ? Colors.transparent
                : Theme.of(context).highlightColor.withOpacity(0.30)),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
