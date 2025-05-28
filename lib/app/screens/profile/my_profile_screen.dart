import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/app/widgets/decorated_containers.dart';
import 'package:friendly_partner/app/widgets/underline_textfield.dart';
import 'package:friendly_partner/controllers/helper_controller.dart';
import 'package:friendly_partner/controllers/profile_controller.dart';
import 'package:friendly_partner/data/repo/profile_repo.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friendly_partner/utils/images.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:get/get.dart';

class MyProfileScreen extends StatefulWidget {
  final bool? isWholeSeller;
  const MyProfileScreen({
    super.key, this.isWholeSeller = false,
  });

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _storeAddressController = TextEditingController();
  final _phoneController = TextEditingController();
  String profilePhoto = '';

  final formKey = GlobalKey<FormState>();

  final repo = Get.put(ProfileRepo(apiClient: Get.find()));
  final controller = Get.put(ProfileController(profileRepo: Get.find()));
  final control = Get.put(HelperController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProfileController>().getProfileData();
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text =
        Get.find<ProfileController>().profileData?['user']?['name'] ?? '';
    _emailController.text =
        Get.find<ProfileController>().profileData?['user']?['email'] ?? '';
    _phoneController.text =
        Get.find<ProfileController>().profileData?['user']?['phone'] ?? '';
    profilePhoto = Get.find<ProfileController>().profileData?['user']
    ?['profile_photo'] ??
        '';

    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(
            title: "My Profile",
            isBackButtonExist: true,
          ),
          body: GetBuilder<ProfileController>(builder: (profileControl) {
            return GetBuilder<HelperController>(builder: (helperControl) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                height: 150, width: 150,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 0.5,
                                    color: Theme.of(context).highlightColor,
                                  ),
                                  color: Theme.of(context).hintColor,
                                ),
                                // alignment: Alignment.center,
                                child: profileControl.pickedImage != null
                                    ? Image.file(
                                        File(
                                          profileControl.pickedImage!.path,
                                        ),
                                        height: 90,
                                        width: 90,
                                        fit: BoxFit.cover,
                                      )
                                    : Stack(
                                        children: [
                                          CustomNetworkImageWidget(
                                            imagePadding:
                                                Dimensions.paddingSize40,
                                            height: 150,
                                            width: 150,
                                            image:
                                                '${AppConstants.onlyBaseUrl}$profilePhoto',
                                            placeholder: Images.svgProfile,
                                            fit: BoxFit.cover,
                                          ),

                                        ],
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                top: 0,
                                left: 0,
                                child: InkWell(
                                  onTap: () =>
                                      profileControl.pickImage(isRemove: false),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.camera_alt,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        sizedBox20(),
                        DecoratedContainers(
                          child: Column(
                            children: [

                              Column(
                                children: [
                                  UnderlineTextField(
                                      showTitle: true,
                                      hintText: 'Your Name',
                                      controller: _nameController,
                                      validator: helperControl.validateName),
                                  sizedBoxDefault(),
                                  UnderlineTextField(
                                      showTitle: true,
                                      hintText: 'Email',
                                      controller: _emailController,
                                      validator: helperControl.validateEmail),
                                  sizedBoxDefault(),
                                  UnderlineTextField(
                                      keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      showTitle: true,
                                      hintText: 'Phone',
                                      controller: _phoneController,
                                      validator: helperControl.validatePhone),
                                ],
                              ) ,
                              sizedBox30(),
                              CustomButtonWidget(
                                isBold: false,
                                buttonText: "Update",
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    profileControl.updateProfile(
                                      name: _nameController.text,
                                      phone: _phoneController.text,
                                      profilePhoto: profileControl
                                          .pickedImage !=
                                          null
                                          ? File(
                                          profileControl.pickedImage!.path)
                                          : null,
                                      email: _emailController.text,
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        sizedBox20(),


                      ],
                    ),
                  ),
                ),
              );
            });
          })),
    );
  }
}
