import 'package:flutter/material.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';

class DecoratedContainers extends StatelessWidget {
  final Widget child;
  final Color? color;
  final bool? isBorder;
  final double? padding;
  final EdgeInsetsGeometry? paddingType;
  final Function()? tap;
  const DecoratedContainers({super.key, required this.child, this.color, this.isBorder = false, this.padding, this.paddingType,  this.tap});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: tap,
      child: Container(
        padding: paddingType ??  EdgeInsets.all(padding ?? Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          border: isBorder! ?
          Border.all(
            width: 0.5,
            color: Theme.of(context).primaryColor
          ) : null,
            color: color ??  profileBgColor,
            borderRadius: BorderRadius.circular(Dimensions.radius10)),
        child: child,
      ),
    );
  }
}
