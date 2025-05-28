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

class MyWholeSellerProfileScreen extends StatefulWidget {

  const MyWholeSellerProfileScreen({
    super.key,
  });

  @override
  State<MyWholeSellerProfileScreen> createState() => _MyWholeSellerProfileScreenState();
}

class _MyWholeSellerProfileScreenState extends State<MyWholeSellerProfileScreen> {
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _storeAddressController = TextEditingController();
  final _phoneController = TextEditingController();
  String profilePhoto = '';

  final formKey = GlobalKey<FormState>();
  final shopFormKey = GlobalKey<FormState>();
  final repo = Get.put(ProfileRepo(apiClient: Get.find()));
  final controller = Get.put(ProfileController(profileRepo: Get.find()));
  final control = Get.put(HelperController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getWholeSellerProfileData();

    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {




    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(
            title: "My Profile",
            isBackButtonExist: true,
            isHideCart: true,
          ),
          body: GetBuilder<ProfileController>(builder: (profileControl) {
            return GetBuilder<HelperController>(builder: (helperControl) {
              _firstNameController.text =
                  Get.find<ProfileController>().wholeSellerProfileData?['user']?['first_name'] ?? '';
              _secondNameController.text =
                  Get.find<ProfileController>().wholeSellerProfileData?['user']?['last_name'] ?? 'Friendly Partner';
              _emailController.text =
                  Get.find<ProfileController>().wholeSellerProfileData?['user']?['email'] ?? '';
              _phoneController.text =
                  Get.find<ProfileController>().wholeSellerProfileData?['user']?['phone'] ?? '';
              _storeNameController.text =
                  Get.find<ProfileController>().wholeSellerProfileData?['user']?['shop']?['name'] ?? '';
              _storeAddressController.text =
                  Get.find<ProfileController>().wholeSellerProfileData?['user']?['shop']?['address'] ?? '';
              profilePhoto = Get.find<ProfileController>().wholeSellerProfileData?['user']
              ?['profile_photo'] ??
                  '';
              return


              DefaultTabController(
              length: 2,
              child: Column(
              children: [
              const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
              Tab(text: 'Personal Details'),
              Tab(text: 'Shop Details'),
              ],
              ),
              Expanded(
              child: TabBarView(
              children: [
              /// Personal Details Tab
              Form(
              key: formKey,
              child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
              children: [
              _buildProfileImage(profileControl, context),
              sizedBox20(),
              DecoratedContainers(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
              children: [
              Expanded(
              child: UnderlineTextField(
              showTitle: true,
              hintText: 'First Name',
              controller: _firstNameController,
              validator: helperControl.validateName,
              ),
              ),
              sizedBoxW15(),
              Expanded(
              child: UnderlineTextField(
              showTitle: true,
              hintText: 'Last Name',
              controller: _secondNameController,
              validator: helperControl.validateName,
              ),
              ),
              ],
              ),
              sizedBoxDefault(),
              UnderlineTextField(
              showTitle: true,
              hintText: 'Email',
              controller: _emailController,
              validator: helperControl.validateEmail,
              ),
              sizedBoxDefault(),
              UnderlineTextField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              showTitle: true,
              hintText: 'Phone',
              controller: _phoneController,
              validator: helperControl.validatePhone,
              ),
              ],
              ),
              ),
                CustomButtonWidget(
                  isBold: false,
                  buttonText: "Update",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      profileControl.updateWholeSellerProfile(
                        phone: _phoneController.text,
                        profilePhoto: profileControl.pickedImage != null
                            ? File(profileControl.pickedImage!.path)
                            : null,
                        email: _emailController.text,
                        firstName: _firstNameController.text.trim(),
                        lastName: _secondNameController.text.trim(),
                      );
                    }
                  },
                ),
              ],
              ),
              ),
              ),

              /// Shop Details Tab
              Form(key: shopFormKey,
                child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                children: [
                DecoratedContainers(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("STORE DETAILS", style: robotoRegular),
                sizedBox20(),
                UnderlineTextField(
                showTitle: true,
                hintText: 'Store Name',
                controller: _storeNameController,
                validator: helperControl.validateName,
                ),
                sizedBoxDefault(),
                UnderlineTextField(
                showTitle: true,
                hintText: 'Store Location',
                controller: _storeAddressController,
                validator: helperControl.validateName,
                ),
                ],
                ),
                ),
                sizedBox30(),
                  CustomButtonWidget(
                    isBold: false,
                    buttonText: "Update",
                    onPressed: () {
                      if (shopFormKey.currentState!.validate()) {
                        profileControl.updateWholeSellerShop(
                            name: _storeNameController.text, address: _storeAddressController.text

                        );
                      }
                    },
                  ),

                sizedBox20(),
                ],
                ),
                ),
              ),
              ],
              ),
              ),
              ],
              ),
              );

            });
          })),
    );
  }
  Widget _buildProfileImage(ProfileController profileControl, BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: 150,
            width: 150,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 0.5,
                color: Theme.of(context).highlightColor,
              ),
              color: Theme.of(context).hintColor,
            ),
            child: profileControl.pickedImage != null
                ? Image.file(
              File(profileControl.pickedImage!.path),
              fit: BoxFit.cover,
            )
                : CustomNetworkImageWidget(
              imagePadding: Dimensions.paddingSize40,
              height: 150,
              width: 150,
              image: '${AppConstants.onlyBaseUrl}$profilePhoto',
              placeholder: Images.svgProfile,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: InkWell(
              onTap: () => profileControl.pickImage(isRemove: false),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1, color: Theme.of(context).primaryColor),
                ),
                child: Center(
                  child: Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
