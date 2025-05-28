import 'dart:async';
import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/auth/location_pick_screen.dart';
import 'package:friendly_partner/app/widgets/gradient_background_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/helper/route_helper.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:get/get.dart';
import '../../../utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _route();
    super.initState();
  }

  void _route() {
    final AuthController authController = Get.find<AuthController>();
    Timer(const Duration(seconds: 1), () async {
      if (authController.isLoggedIn()) {
        if(authController.isWholeSellerLogin()) {
          final String? savedAddress = authController.getSaveAddress();
          if (savedAddress != null && savedAddress.isNotEmpty) {
            Get.offNamed(RouteHelper.getWholeSellerDashboardRoute());
          } else {
            Get.to(() => LocationPickerScreen());
          }


        } else {
          final String? savedAddress = authController.getSaveAddress();
          if (savedAddress != null && savedAddress.isNotEmpty) {
            Get.offNamed(RouteHelper.getDashboardRoute());
          } else {
            Get.offNamed(RouteHelper.getDashboardRoute());
            // Get.to(() => LocationPickerScreen());
          }
        }


      } else {
        Get.offNamed(RouteHelper.getSigningRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: GradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSize75),
            child: SvgPicture.asset(
              Images.logo,
            ),
          ),
        ),
      ),
    );
  }
}
