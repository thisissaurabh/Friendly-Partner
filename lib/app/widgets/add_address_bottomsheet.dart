import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_textfield.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/helper_controller.dart';
import 'package:friendly_partner/controllers/user_map_controller.dart';
import 'package:friendly_partner/data/repo/auth_repo.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import '../../utils/dimensions.dart';

class AddAddressBottomSheet extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final RxString addressType = 'Home'.obs;
  final TextEditingController flatNoController =
  TextEditingController();
  final TextEditingController postalCodeController =
  TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();



  final formKey = GlobalKey<FormState>();

  AddAddressBottomSheet({super.key}) {
    Get.put(UserMapController(), permanent: false);
    Get.put(HelperController(), permanent: false);

  }

  @override
  Widget build(BuildContext context) {
    final helperController = Get.find<HelperController>();
    final userMapController = Get.find<UserMapController>();
    final authController = Get.find<AuthController>();

    // Initialize address2Controller here (not inside build)
    address2Controller.text = userMapController.addressLine2;
    // final repo = Get.put(UserMapController());
    //
    // final c = Get.put(HelperController());
    return SafeArea(
      child: Form(
          key: formKey,
          child: GetBuilder<AuthController>(builder: (controller) {
            return GetBuilder<HelperController>(builder: (helpController) {
              return GetBuilder<UserMapController>(builder: (mapControl) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    address2Controller.text =   Get.find<UserMapController>().addressLine2 ;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Dimensions.radius10),
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: mapControl.isLoading.value
                          ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,))
                          : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Add Address", style: robotoMedium),
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CustomTextField(
                                    controller: nameController,
                                    capitalization: TextCapitalization.words,
                                    hintText: "Contact Person Name",
                                    validation: helpController.validateName,
                                  ),
                                  sizedBox10(),
                                  CustomTextField(
                                    maxLength: 10,
                                    inputType: TextInputType.number,
                                    controller: phoneController,
                                    hintText: "Contact Person Phone No",
                                    validation: helpController.validatePhone,
                                  ),
                                  sizedBox10(),
                                  CustomTextField(
                                    controller: areaController,
                                    hintText: "Area",
                                    validation: helpController.validate,
                                  ),
                                  sizedBox10(),
                                  CustomTextField(
                                    controller: flatNoController,
                                    hintText: "Flat No",
                                    validation: helpController.validate,
                                  ),
                                  sizedBox10(),
                                  CustomTextField(
                                    maxLength: 6,
                                    inputType: TextInputType.number,
                                    controller: postalCodeController,
                                    hintText: "Postal Code",
                                    validation: helpController.validate,
                                  ),
                                  sizedBox10(),
                                  CustomTextField(

                                    controller: addressController,
                                    hintText: "Home Address",
                                    validation: helpController.validate,
                                  ),
                                  sizedBox10(),
                                  CustomTextField(
                                    controller: address2Controller,
                                    hintText: "Address 2",
                                    validation: helpController.validate,
                                  ),
                                  Obx(
                                        () => Wrap(
                                      spacing: 10,
                                      children: ['Home', 'office', 'other'].map((value) {
                                        return ChoiceChip(
                                          selectedColor: Theme.of(context).primaryColor,
                                          label: Text(
                                            value,
                                            style: robotoRegular.copyWith(
                                              color: addressType.value == value
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          selected: addressType.value == value,
                                          onSelected: (_) {
                                            addressType.value = value;
                                            setState(() {}); // optional: only if you add non-GetX logic
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  sizedBoxDefault(),
                                  CustomButtonWidget(
                                    buttonText: "+ Add",
                                    onPressed: () {
                                      if(formKey.currentState!.validate()) {
                                        controller.addAddressApi(
                                          name: nameController.text.trim(),
                                          phone: phoneController.text.trim(),
                                          area: areaController.text.trim(),
                                          flatNo: flatNoController.text.trim(),
                                          postCode: postalCodeController.text.trim(),
                                          address: addressController.text.trim(),
                                          addressType: addressType.toString(),
                                          addressLine2: address2Controller.text.trim(),
                                          longitude: mapControl.long.toString(),
                                          latitude: mapControl.lat.toString(),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );

              });
            });
          })

          ),
    );
  }
}
