// import 'package:flutter/material.dart';
// import 'package:friendly_partner/app/widgets/custom_button.dart';
// import 'package:friendly_partner/app/widgets/custom_textfield.dart';
// import 'package:friendly_partner/app/widgets/gradient_background_widget.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:friendly_partner/controllers/auth_controller.dart';
// import 'package:friendly_partner/helper/route_helper.dart';
// import 'package:friendly_partner/utils/dimensions.dart';
// import 'package:friendly_partner/utils/sizeboxes.dart';
// import 'package:friendly_partner/utils/styles.dart';
// import 'package:get/get.dart';
// import '../../../utils/images.dart';
//
// class SignupScreen extends StatelessWidget {
//   SignupScreen({super.key});
//
//   final formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: GradientBackground(
//           child: GetBuilder<AuthController>(
//             builder: (authControl) {
//               return SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
//                   child: Form(
//                     key: formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         sizedBox20(),
//                         Center(
//                           child: SvgPicture.asset(
//                             height: 150,
//                             width: 150,
//                             Images.logo,
//                           ),
//                         ),
//                         sizedBox20(),
//                         Center(
//                           child: Text(
//                             "SIGN UP",
//                             style: robotoBold.copyWith(
//                                 fontSize: Dimensions.fontSize32,
//                                 color: Theme.of(context).primaryColor),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: Dimensions.paddingSize75,
//                               vertical: Dimensions.paddingSize10),
//                           child: Image.asset(Images.icArrowLine),
//                         ),
//                         sizedBox10(),
//                         const Text(
//                           "SIGN UP AS",
//                           // Adjust style as needed
//                         ),
//                         sizedBox10(),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CustomButtonWidget(
//                                 fontSize: Dimensions.fontSize15,
//                                 borderSideColor:
//                                     authControl.selectedButton == 'Wholesaler'
//                                         ? Colors.white
//                                         : Theme.of(context).highlightColor,
//                                 textColor:
//                                     authControl.selectedButton == 'Wholesaler'
//                                         ? Colors.white
//                                         : Theme.of(context).highlightColor,
//                                 onPressed: () {
//                                   authControl.selectButton("Wholesaler");
//                                 },
//
//                                 buttonText: "Wholesaler",
//                                 color: authControl
//                                             .selectedButton == // Access the value
//                                         'Wholesaler'
//                                     ? Theme.of(context).primaryColor
//                                     : Colors
//                                         .transparent, // Provide a default color
//                               ),
//                             ),
//                             sizedBoxW10(),
//                             Expanded(
//                               child: CustomButtonWidget(
//                                 fontSize: Dimensions.fontSize15,
//                                 borderSideColor:
//                                     authControl.selectedButton == 'Retailer'
//                                         ? Colors.white
//                                         : Theme.of(context).highlightColor,
//                                 textColor:
//                                     authControl.selectedButton == 'Retailer'
//                                         ? Colors.white
//                                         : Theme.of(context).highlightColor,
//                                 onPressed: () {
//                                   authControl.selectButton("Retailer");
//                                 },
//
//                                 buttonText: "Retailer",
//                                 color: authControl.selectedButton == 'Retailer'
//                                     ? Theme.of(context).primaryColor
//                                     : Colors
//                                         .transparent, // Provide a default color
//                               ),
//                             ),
//                           ],
//                         ),
//                         sizedBox20(),
//                         CustomTextField(
//                           capitalization: TextCapitalization.words,
//                           showTitle: true,
//                           hintText: "FULL NAME",
//                           controller: nameController,
//                           validation: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return 'Name is required';
//                             }
//
//                             final nameRegex = RegExp(r"^[A-Za-z ]+$");
//                             if (!nameRegex.hasMatch(value.trim())) {
//                               return 'Name can only contain letters and spaces';
//                             }
//
//                             return null;
//                           },
//                         ),
//                         sizedBoxDefault(),
//                         CustomTextField(
//                           showTitle: true,
//                           hintText: "EMAIL ADDRESS",
//                           controller: emailController,
//                           validation: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Email is required';
//                             }
//                             final emailRegex =
//                                 RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//                             if (!emailRegex.hasMatch(value)) {
//                               return 'Enter a valid email';
//                             }
//                             return null;
//                           },
//                         ),
//                         sizedBoxDefault(),
//                         CustomTextField(
//                           showTitle: true,
//                           hintText: "PASSWORD",
//                           isPassword: true,
//                           controller: passwordController,
//                           validation: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Password is required';
//                             } else if (value.length < 6) {
//                               return 'Password must be at least 6 characters';
//                             }
//                             return null;
//                           },
//                         ),
//                         sizedBoxDefault(),
//                         CustomTextField(
//                           showTitle: true,
//                           isPassword: true,
//                           hintText: "CONFIRM PASSWORD",
//                           controller: confirmPasswordController,
//                           validation: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Confirm password is required';
//                             } else if (value.length < 6) {
//                               return 'Password must be at least 6 characters';
//                             } else if (value != passwordController.text) {
//                               return 'Passwords do not match';
//                             }
//                             return null;
//                           },
//                         ),
//                         sizedBox30(),
//                         CustomButtonWidget(
//                           color: Theme.of(context).disabledColor,
//                           onPressed: () {
//                             if (formKey.currentState!.validate()) {
//                               authControl.registerApi(name: nameController.text.trim(),
//                                   email: emailController.text.trim(), password: passwordController.text.trim()
//                               );
//                             }
//                           },
//                           borderSideColor: Theme.of(context).disabledColor,
//                           buttonText: "Sign up",
//                         ),
//                         Center(
//                           child: TextButton(
//                             onPressed: () {
//                               Get.toNamed(RouteHelper.getSigningRoute());
//                             },
//                             child: RichText(
//                               text: TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: 'Already have an account ? ',
//                                     style: robotoRegular.copyWith(
//                                       fontSize: Dimensions.fontSize13,
//                                       color: Theme.of(context).highlightColor,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: ' Sign In',
//                                     style: robotoMedium.copyWith(
//                                       fontSize: Dimensions.fontSize14,
//                                       color: Theme.of(context).primaryColor,
//                                     ), // Different color for "resend"
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
