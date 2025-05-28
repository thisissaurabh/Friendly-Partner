import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/dashboard/dashboard.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';
import '../../../utils/images.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/theme/light_theme.dart';
import 'order_details.dart';
class OrderSuccessful extends StatelessWidget {
  final String orderId;
  const OrderSuccessful({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset( Images.lottieSuccess,height: 180,width: 180,),
            Text("Order Successful !",style: robotoBold.copyWith(
              fontSize: Dimensions.fontSize20
            ),),
            Text("Your order has placed successfully.",style: robotoBold.copyWith(
                fontSize: Dimensions.fontSize14,
              color: Colors.black.withOpacity(0.50)
            ),),
            sizedBoxDefault(),
            _buildDownloadButton("Home",() {
              Get.to(() => DashboardScreen());
            }),

            _buildDownloadButton("Order Details",() {
              Get.to(() => DashboardScreen(index: 3,));

            }),


          ],
        ),
      ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(String label, Function() tap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),

          ),
          onPressed: tap,

          label: Text(label),
        ),
      ),
    );
  }
}
