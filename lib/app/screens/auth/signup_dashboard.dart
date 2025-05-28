import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_textfield.dart';
import 'package:friendly_partner/app/widgets/gradient_background_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/helper_controller.dart';
import 'package:friendly_partner/data/repo/auth_repo.dart';
import 'package:friendly_partner/helper/route_helper.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:get/get.dart';
import '../../../utils/images.dart';
import '../../widgets/decorations.dart';

class SignupDashboard extends StatelessWidget {
  SignupDashboard({super.key});

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final shopNameController = TextEditingController();
  final addressController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final RxString gender = 'male'.obs;
  @override
  Widget build(BuildContext context) {
    final repo = Get.put(AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
    final controller = Get.put(AuthController(authRepo: Get.find(), sharedPreferences: Get.find()));
    final c = Get.put(HelperController());
    return SafeArea(
      child: Scaffold(
        body: GradientBackground(
          child: GetBuilder<AuthController>(
            builder: (authControl) {
              return GetBuilder<HelperController>(builder: (control) {
                return  SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(
                        Dimensions.paddingSizeDefault),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizedBox20(),
                          Center(
                            child: SvgPicture.asset(
                              height: 150,
                              width: 150,
                              Images.logo,
                            ),
                          ),
                          sizedBox20(),
                          Center(
                            child: Text(
                              "SIGN UP",
                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSize32,
                                  color: Theme
                                      .of(context)
                                      .primaryColor),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSize75,
                                vertical: Dimensions.paddingSize10),
                            child: Image.asset(Images.icArrowLine),
                          ),
                          sizedBox10(),
                          const Text(
                            "SIGN UP AS",
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
                                      : Theme
                                      .of(context)
                                      .highlightColor,
                                  textColor:
                                  authControl.selectedButton == 'Wholesaler'
                                      ? Colors.white
                                      : Theme
                                      .of(context)
                                      .highlightColor,
                                  onPressed: () {
                                    authControl.selectButton("Wholesaler");
                                  },

                                  buttonText: "Wholesaler",
                                  color: authControl
                                      .selectedButton == // Access the value
                                      'Wholesaler'
                                      ? Theme
                                      .of(context)
                                      .primaryColor
                                      : Colors
                                      .transparent, // Provide a default color
                                ),
                              ),
                              sizedBoxW10(),
                              Expanded(
                                child: CustomButtonWidget(
                                  fontSize: Dimensions.fontSize15,
                                  borderSideColor:
                                  authControl.selectedButton == 'Retailer'
                                      ? Colors.white
                                      : Theme
                                      .of(context)
                                      .highlightColor,
                                  textColor:
                                  authControl.selectedButton == 'Retailer'
                                      ? Colors.white
                                      : Theme
                                      .of(context)
                                      .highlightColor,
                                  onPressed: () {
                                    authControl.selectButton("Retailer");
                                  },

                                  buttonText: "Retailer",
                                  color: authControl.selectedButton ==
                                      'Retailer'
                                      ? Theme
                                      .of(context)
                                      .primaryColor
                                      : Colors
                                      .transparent, // Provide a default color
                                ),
                              ),
                            ],
                          ),

                          sizedBox20(),
                          authControl
                              .selectedButton ==
                              'Wholesaler' ?
                          Column(
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Center(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 100, width: 100,
                                                        clipBehavior: Clip.hardEdge,
                                                        decoration: BoxDecoration(

                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Theme.of(context)
                                                                .primaryColor
                                                                .withOpacity(0.40),
                                                          ),
                                                          color: Theme.of(context)
                                                              .primaryColor
                                                              .withOpacity(0.1),
                                                        ),
                                                        // alignment: Alignment.center,
                                                        child: control.pickedPhotoImage !=
                                                            null
                                                            ? Image.file(
                                                          File(
                                                            control
                                                                .pickedPhotoImage!.path,
                                                          ),
                                                          height: 90,
                                                          width: 90,
                                                          fit: BoxFit.cover,
                                                        )
                                                            : Stack(
                                                          children: [
                                                            Container(
                                                                height: 100,
                                                                width: 100,
                                                                clipBehavior:
                                                                Clip.hardEdge,
                                                                decoration:
                                                                BoxDecoration(
                                                                  shape:
                                                                  BoxShape.circle,
                                                                  color: Theme.of(
                                                                      context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                      0.1),
                                                                ),
                                                                child: Icon(
                                                                    Icons.person)),
                                                            // Image.asset(Images.profilePlaceholder,)
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        top: 0,
                                                        left: 0,
                                                        child: InkWell(
                                                          onTap: (){
                                                            control.pickPhotoImage(isRemove: false);
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.black
                                                                  .withOpacity(0.3),

                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Theme.of(context)
                                                                      .primaryColor),
                                                            ),
                                                            child: Container(
                                                              margin:
                                                              const EdgeInsets.all(25),
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Colors.white),

                                                              ),
                                                              child: const Icon(
                                                                  Icons.camera_alt,
                                                                  color: Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        sizedBox10(),
                                        Column(
                                          children: [
                                            Text("Add Profile Image"),
                                            Text("500x500*",style: robotoRegular.copyWith(
                                              color: redColor
                                            ),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Center(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 100, width: 100,
                                                        clipBehavior: Clip.hardEdge,
                                                        decoration: BoxDecoration(

                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Theme.of(context)
                                                                .primaryColor
                                                                .withOpacity(0.40),
                                                          ),
                                                          color: Theme.of(context)
                                                              .primaryColor
                                                              .withOpacity(0.1),
                                                        ),
                                                        // alignment: Alignment.center,
                                                        child: control.pickedLogoImage !=
                                                            null
                                                            ? Image.file(
                                                          File(
                                                            control
                                                                .pickedLogoImage!.path,
                                                          ),
                                                          height: 90,
                                                          width: 90,
                                                          fit: BoxFit.cover,
                                                        )
                                                            : Stack(
                                                          children: [
                                                            Container(
                                                                height: 100,
                                                                width: 100,
                                                                clipBehavior:
                                                                Clip.hardEdge,
                                                                decoration:
                                                                BoxDecoration(

                                                                  color: Theme.of(
                                                                      context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                      0.1),
                                                                ),
                                                                child: Icon(
                                                                    Icons.shopping_cart_rounded)),
                                                            // Image.asset(Images.profilePlaceholder,)
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        top: 0,
                                                        left: 0,
                                                        child: InkWell(
                                                          onTap: (){
                                                            control.pickLogoImage(isRemove: false);
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.black
                                                                  .withOpacity(0.3),

                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Theme.of(context)
                                                                      .primaryColor),
                                                            ),
                                                            child: Container(
                                                              margin:
                                                              const EdgeInsets.all(25),
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Colors.white),

                                                              ),
                                                              child: const Icon(
                                                                  Icons.camera_alt,
                                                                  color: Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        sizedBox10(),
                                        Column(
                                          children: [
                                            Text("Add Shop Image"),
                                            Text("500x500*",style: robotoRegular.copyWith(
                                                color: redColor
                                            ),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              sizedBoxDefault(),
                              sizedBoxDefault(),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      capitalization: TextCapitalization.words,
                                      showTitle: true,
                                      hintText: "FIRST NAME",
                                      controller: firstNameController,
                                      validation: (value) {
                                        if (value == null || value
                                            .trim()
                                            .isEmpty) {
                                          return 'Name is required';
                                        }

                                        final nameRegex = RegExp(
                                            r"^[A-Za-z ]+$");
                                        if (!nameRegex.hasMatch(value.trim())) {
                                          return 'Name can only contain letters and spaces';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                  sizedBoxW15(),
                                  Expanded(
                                    child: CustomTextField(
                                      capitalization: TextCapitalization.words,
                                      showTitle: true,
                                      hintText: "LAST NAME",
                                      controller: lastNameController,
                                      validation: (value) {
                                        if (value == null || value
                                            .trim()
                                            .isEmpty) {
                                          return 'Name is required';
                                        }

                                        final nameRegex = RegExp(
                                            r"^[A-Za-z ]+$");
                                        if (!nameRegex.hasMatch(value.trim())) {
                                          return 'Name can only contain letters and spaces';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),

                                ],
                              ),
                              sizedBoxDefault(),
                              CustomTextField(
                                showTitle: true,
                                maxLength: 10,

                                inputType: TextInputType.number,
                                hintText: "PHONE NUMBER",
                                controller: phoneController,
                                validation: control.validatePhone,
                              ),

                              // sizedBoxDefault(),
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
                              sizedBoxDefault(),
                              Obx(() =>
                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "GENDER",
                                        // Adjust style as needed
                                      ),
                                      sizedBox10(),
                                      DropdownButtonFormField<String>(
                                        decoration:  DropDownDecoration(),
                                        value: gender.value,
                                        items: ['male', 'female']
                                            .map((value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) => gender
                                            .value = newValue ?? 'male',
                                      ),
                                    ],
                                  )),
                              sizedBoxDefault(),

                              CustomTextField(
                                showTitle: true,
                                hintText: "SHOP NAME",
                                controller: shopNameController,
                                validation: control.validateName,
                              ),
                              sizedBoxDefault(),
                              CustomTextField(
                                maxLines: 5,
                                showTitle: true,
                                hintText: "Address",
                                controller: addressController,
                                validation: control.validateName,
                              ),
                              sizedBoxDefault(),

                              Center(
                                child: SizedBox(
                                  height: 100,
                                  width:Get.size.width,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 100, width: Get.size.width,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(

                                                  border: Border.all(
                                                    width: 0.5,
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.40),
                                                  ),
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.1),
                                                ),
                                                // alignment: Alignment.center,
                                                child: control.pickedBannerImage !=
                                                    null
                                                    ? Image.file(
                                                  File(
                                                    control
                                                        .pickedBannerImage!.path,
                                                  ),
                                                  height: 90,
                                                  width: Get.size.width,
                                                  fit: BoxFit.cover,
                                                )
                                                    : Stack(
                                                  children: [
                                                    Container(
                                                        height: 100,
                                                        width: Get.size.width,
                                                        clipBehavior:
                                                        Clip.hardEdge,
                                                        decoration:
                                                        BoxDecoration(

                                                          color: Theme.of(
                                                              context)
                                                              .primaryColor
                                                              .withOpacity(
                                                              0.1),
                                                        ),
                                                        child: Icon(
                                                            Icons.shop)),
                                                    // Image.asset(Images.profilePlaceholder,)
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                top: 0,
                                                left: 0,
                                                child: InkWell(
                                                  onTap: (){
                                                    control.pickBannerImage(isRemove: false);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Theme.of(context)
                                                              .primaryColor),
                                                    ),
                                                    child: Container(
                                                      margin:
                                                      const EdgeInsets.all(25),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Colors.white),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                          Icons.camera_alt,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              sizedBox10(),
                              Text("Add Shop Banner"),


                            ],
                          )

                              :


                          Column(
                            children: [
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
                              sizedBoxDefault(),
                              CustomTextField(
                                capitalization: TextCapitalization.words,
                                showTitle: true,
                                hintText: "FULL NAME",
                                controller: nameController,
                                validation: (value) {
                                  if (value == null || value
                                      .trim()
                                      .isEmpty) {
                                    return 'Name is required';
                                  }

                                  final nameRegex = RegExp(r"^[A-Za-z ]+$");
                                  if (!nameRegex.hasMatch(value.trim())) {
                                    return 'Name can only contain letters and spaces';
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),
                          sizedBoxDefault(),


                          CustomTextField(
                            showTitle: true,
                            hintText: "PASSWORD",
                            isPassword: true,
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
                          sizedBoxDefault(),
                          CustomTextField(
                            showTitle: true,
                            isPassword: true,
                            hintText: "CONFIRM PASSWORD",
                            controller: confirmPasswordController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm password is required';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              } else if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          sizedBox30(),
                          authControl
                              .selectedButton ==
                              'Wholesaler' ?
                          CustomButtonWidget(
                            color: Theme
                                .of(context)
                                .disabledColor,
                            onPressed: () {
                              print("donme");

                              if (formKey.currentState!.validate()) {
                                authControl.addWholeSeller(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  email: emailController.text.trim(),
                                  gender: gender.toString(),
                                  password: passwordController.text.trim(),
                                  confirmPassword: confirmPasswordController.text.trim(),
                                  shopName: shopNameController.text.trim(),
                                  profilePhoto:  control.pickedPhotoImage !=
                                      null &&
                                      control.pickedPhotoImage!
                                          .path.isNotEmpty
                                      ? control.pickedPhotoImage
                                      : null,
                                  shopLogo: control.pickedLogoImage !=
                                      null &&
                                      control.pickedLogoImage!
                                          .path.isNotEmpty
                                      ? control.pickedLogoImage
                                      : null,
                                  shopBanner:  control.pickedBannerImage !=
                                      null &&
                                      control.pickedBannerImage!
                                          .path.isNotEmpty
                                      ? control.pickedBannerImage
                                      : null, address: addressController.text.trim(),
                                );


                              }
                            },
                            borderSideColor: Theme
                                .of(context)
                                .disabledColor,
                            buttonText: "Sign up",
                          ) :
                          CustomButtonWidget(
                            color: Theme
                                .of(context)
                                .disabledColor,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                authControl.registerApi(name: nameController
                                    .text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim()
                                );

                              }
                            },
                            borderSideColor: Theme
                                .of(context)
                                .disabledColor,
                            buttonText: "Sign up",
                          ),

                          Center(
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(RouteHelper.getSigningRoute());
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Already have an account ? ',
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSize13,
                                        color: Theme
                                            .of(context)
                                            .highlightColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Sign In',
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSize14,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
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
              });
            }
          ),
        ),
      ),
    );
  }
}
