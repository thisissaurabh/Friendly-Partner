import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/images.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
class LoadingDialog {
  static void showLoading({String? message}) {
    Get.dialog(
      const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: _LoadingWidget(),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    Get.back();
  }
}

class _LoadingWidget extends StatefulWidget {
  const _LoadingWidget();

  @override
  __LoadingWidgetState createState() => __LoadingWidgetState();
}

class __LoadingWidgetState extends State<_LoadingWidget> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startFadeAnimation();
  }

  void _startFadeAnimation() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _opacity = _opacity == 0.0 ? 1.0 : 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSize20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius10)),
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: SvgPicture.asset(
          Images.logo, // Your logo asset
          height: 80,
          width: 80,
        ),
      ),
    );
  }
}






class LoadingGif {
  static void showLoading({required String lottie ,String? message}) {
    Get.dialog(
      Dialog(insetPadding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize40),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSize40),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius10)
            ),
            child: Center(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(lottie,height: 100,width: 100,),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Text(textAlign: TextAlign.center,
                      message!,style: robotoRegular,),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    Get.back();
  }
}

