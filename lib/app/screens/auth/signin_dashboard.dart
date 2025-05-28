import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/auth/signup_dashboard.dart';
import 'package:friendly_partner/app/screens/auth/signup_screen.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_textfield.dart';
import 'package:friendly_partner/app/widgets/gradient_background_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/data/repo/auth_repo.dart';
import 'package:friendly_partner/helper/route_helper.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';
import '../../../utils/images.dart';

class SigningDashboard extends StatelessWidget {
  SigningDashboard({super.key});

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<AuthController>(builder: (authControl) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    sizedBox20(),
                    SvgPicture.asset(
                      height: 150,
                      width: 150,
                      Images.logo,
                    ),
                    sizedBox20(),
                    Text(
                      "SIGN IN",
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSize32,
                          color: Theme.of(context).primaryColor),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSize75,
                          vertical: Dimensions.paddingSize10),
                      child: Image.asset(Images.icArrowLine),
                    ),
                    sizedBox10(),
                    const Text(
                      "SIGN IN AS",
                      // Adjust style as needed
                    ),
                    sizedBox10(),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButtonWidget(
                            fontSize: Dimensions.fontSize15,
                            borderSideColor:
                            authControl.selectedButton == 'Wholesaler'
                                ? Colors.white
                                : Theme.of(context).highlightColor,
                            textColor:
                            authControl.selectedButton == 'Wholesaler'
                                ? Colors.white
                                : Theme.of(context).highlightColor,
                            onPressed: () {
                              authControl.selectButton("Wholesaler");
                            },

                            buttonText: "Wholesaler",
                            color: authControl
                                .selectedButton == // Access the value
                                'Wholesaler'
                                ? Theme.of(context).primaryColor
                                : Colors.transparent, // Provide a default color
                          ),
                        ),
                        sizedBoxW10(),
                        Expanded(
                          child: CustomButtonWidget(
                            fontSize: Dimensions.fontSize15,
                            borderSideColor:
                            authControl.selectedButton == 'Retailer'
                                ? Colors.white
                                : Theme.of(context).highlightColor,
                            textColor: authControl.selectedButton == 'Retailer'
                                ? Colors.white
                                : Theme.of(context).highlightColor,
                            onPressed: () {
                              authControl.selectButton("Retailer");
                            },

                            buttonText: "Retailer",
                            color: authControl.selectedButton == 'Retailer'
                                ? Theme.of(context).primaryColor
                                : Colors.transparent, // Provide a default color
                          ),
                        ),
                      ],
                    ),
                    sizedBox10(),
                    CustomTextField(
                      showTitle: true,
                      hintText: "EMAIL ADDRESS",
                      controller: emailController,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email';
                        }

                        return null;
                      },
                    ),
                    sizedBox20(),
                    CustomTextField(
                      showTitle: true,
                      hintText: "PASSWORD",
                      controller: passwordController,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    sizedBox30(),
                    CustomButtonWidget(
                      color: Theme.of(context).disabledColor,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if( authControl.selectedButton == 'Wholesaler') {
                            authControl.wholeSellerLoginApi(emailController.text.trim(),
                                passwordController.text.trim());


                          } else {
                            authControl.loginApi(emailController.text.trim(),
                                passwordController.text.trim());
                          }

                        }
                      },
                      borderSideColor: Theme.of(context).disabledColor,
                      buttonText: "Sign in",
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => SignupDashboard());
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'New to Friendly Partner ?  ',
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSize13,
                                  color: Theme.of(context).highlightColor,
                                ),
                              ),
                              TextSpan(
                                text: ' Sign Up',
                                style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSize14,
                                  color: Theme.of(context).primaryColor,
                                ), // Different color for "resend"
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
