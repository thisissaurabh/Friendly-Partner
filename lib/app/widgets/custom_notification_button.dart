import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendly_partner/controllers/cart_controller.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:get/get.dart';

class CustomNotificationButton extends StatelessWidget {
  final Function() tap;
  final IconData? icon;
  final Color? color;
  const CustomNotificationButton(
      {super.key, required this.tap, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon ?? CupertinoIcons.bell,
        size: 28,
        color: color ?? Theme.of(context).primaryColor,
      ),
      onPressed: tap,
    );
  }
}


class CustomCartNotification extends StatelessWidget {
  final Function() tap;
  final IconData? icon;
  final Color? color;

  const CustomCartNotification({
    super.key,
    required this.tap,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (control) {
      final cartItems = control.cart?["cart_items"] ?? [];
      int totalCount = 0;
      for (var shop in cartItems) {
        final products = shop["products"] ?? [];
        for (var product in products) {
          final quantity = product["quantity"];
          if (quantity is int) {
            totalCount += quantity;
          } else if (quantity is double) {
            totalCount += quantity.toInt();
          } else {
            totalCount += 0;
          }
        }
      }

      return GestureDetector(
        onTap: tap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: Icon(
                icon ?? CupertinoIcons.shopping_cart,
                size: 28,
                color: color ?? Theme.of(context).primaryColor,
              ),
              onPressed: tap,
            ),
            if (totalCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      '$totalCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}