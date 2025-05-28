
import 'package:flutter/material.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';
import '../../utils/dimensions.dart';
import '../../utils/theme/light_theme.dart';
import 'custom_button.dart';


class ConfirmationDialog extends StatelessWidget {
  final IconData icon;
  final String? title;
  final String description;
  final String? adminText;
  final Function onYesPressed;
  final Function? onNoPressed;


  const ConfirmationDialog({super.key,
    required this.icon, this.title, required this.description, this.adminText, required this.onYesPressed,
    this.onNoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius10)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSize20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon,size: 80,
          color: Colors.red,),
          // title != null ? Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize20),
          //   child: Text(
          //     title!, textAlign: TextAlign.center,
          //     style: robotoMedium.copyWith(fontSize: Dimensions.fontSize20, color: Colors.red),
          //   ),
          // ) : const SizedBox(),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSize20),
            child: Text(description, style: robotoMedium.copyWith(fontSize: Dimensions.fontSize15), textAlign: TextAlign.center),
          ),

          adminText != null && adminText!.isNotEmpty ? Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSize20),
            child: Text('[$adminText]', style: robotoMedium.copyWith(fontSize: Dimensions.fontSize15), textAlign: TextAlign.center),
          ) : const SizedBox(),
          const SizedBox(height: Dimensions.paddingSize10),

          Row(children: [
            Expanded(child: TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent, minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius10)),
              ),
              child: Text(
                'No', textAlign: TextAlign.center,
                style: robotoBold.copyWith(color: Theme.of(context).cardColor),
              ),
            )),
            const SizedBox(width: Dimensions.paddingSize20),

            Expanded(child: CustomButtonWidget(
              color: greenColor,
              buttonText:'Yes',
              borderSideColor: greenColor,
              onPressed: () =>  onYesPressed(),
              height: 40,
            )),

          ]),


        ]),
      )),





    );
  }
}