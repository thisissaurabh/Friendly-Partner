import 'package:flutter/material.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final bool isBold;
  final Color? borderSideColor;
  const CustomButtonWidget({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.transparent = false,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.radius = 10,
    this.icon,
    this.color,
    this.textColor,
    this.isLoading = false,
    this.isBold = true,
    this.borderSideColor,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : transparent
              ? Colors.transparent
              : color ?? Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width! : Dimensions.webMaxWidth,
          height != null ? height! : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: borderSideColor ??
              Theme.of(context).primaryColor, // Specify the color of the border
          width: 1, // Specify the width of the border
        ),
      ),
    );

    return Center(
        child: SizedBox(
            width: width ?? Dimensions.webMaxWidth,
            child: Padding(
              padding: margin == null ? const EdgeInsets.all(0) : margin!,
              child: TextButton(
                onPressed: isLoading ? null : onPressed as void Function()?,
                style: flatButtonStyle,
                child: isLoading
                    ? Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSize10),
                              Text('Loading',
                                  style: robotoMedium.copyWith(
                                      color: Colors.white)),
                            ]),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text(buttonText,
                                textAlign: TextAlign.center,
                                style: !isBold
                                    ? robotoBold.copyWith(
                                        color: textColor ??
                                            (transparent
                                                ? Theme.of(context).primaryColor
                                                : Colors.white),
                                        fontSize:
                                            fontSize ?? Dimensions.fontSize18,
                                      )
                                    : robotoRegular.copyWith(
                                        color: textColor ??
                                            (transparent
                                                ? Theme.of(context).primaryColor
                                                : Colors.white),
                                        fontSize:
                                            fontSize ?? Dimensions.fontSize18,
                                      )),
                            icon != null
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Icon(
                                      icon,
                                      color: transparent
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).cardColor,
                                      size: Dimensions.fontSizeDefault,
                                    ),
                                  )
                                : const SizedBox(),
                          ]),
              ),
            )));
  }
}

class CustomSquareButton extends StatelessWidget {
  final IconData icon;
  final Function() tap;
  final Color? color;
  final Color? iconColor;
  const CustomSquareButton(
      {super.key,
      required this.icon,
      required this.tap,
      this.color,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        decoration: BoxDecoration(
            color: color ?? Colors.black, // black background
            borderRadius: BorderRadius.circular(8) // circular button
            ),
        padding: const EdgeInsets.all(8), // padding inside the black circle
        child: Icon(
          size: 20,
          icon,
          color: iconColor ?? Colors.white, // icon color
        ),
      ),
    );
  }
}
