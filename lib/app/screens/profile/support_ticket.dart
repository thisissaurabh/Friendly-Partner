import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';

import 'package:friendly_partner/app/widgets/custom_textfield.dart';
import 'package:friendly_partner/controllers/helper_controller.dart';

import 'package:friendly_partner/controllers/profile_controller.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';

import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';

import 'package:get/get.dart';

import '../../../data/repo/whole_seller.dart';

class CreateSupportTicketScreen extends StatelessWidget {
  CreateSupportTicketScreen({
    super.key,
  });

  final _issueController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final wholeC = Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
    final c = Get.put(HelperController());
    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(
            title: "Support Ticket",
            isBackButtonExist: true,
          ),


          body: GetBuilder<WholeSellerController>(builder: (control) {
            return GetBuilder<HelperController>(builder: (helperControl) {
              return Form(
                key: formKey,
                child: Stack(
                  children: [
                    Container(height: Get.size.height,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(
                            children: [
                              CustomTextField(
                                showTitle: true,
                                hintText: "Issue",
                                controller: _issueController,
                                validation: helperControl.validate,
                              ),
                              sizedBoxDefault(),

                              CustomTextField(
                                showTitle: true,
                                hintText: "Message",
                                controller: _messageController,
                                validation: helperControl.validate,
                              ),
                              sizedBoxDefault(),
                              CustomTextField(
                                showTitle: true,
                                hintText: "Email",
                                validation: helperControl.validateEmail,
                                controller: _emailController,
                              ),
                              sizedBoxDefault(),
                              CustomTextField(
                                showTitle: true,
                                maxLength: 10,
                                inputType: TextInputType.number,
                                hintText: "Phone",
                                controller: _phoneController,
                                validation: helperControl.validatePhone,
                              ),
                              sizedBoxDefault(),
                              CustomTextField(
                                showTitle: true,
                                maxLines: 4,
                                hintText: "Subject",
                                controller: _subjectController,
                                validation: helperControl.validate,
                              ),
                              sizedBox100(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: Dimensions.paddingSizeDefault,
                      left: Dimensions.paddingSizeDefault,
                      right: Dimensions.paddingSizeDefault,
                      child: CustomButtonWidget(
                        buttonText: "Submit",
                        onPressed: () {
                          if(formKey.currentState!.validate()) {
                            control.addSupportTicket(issueType: _issueController.text.trim(),
                                subject: _subjectController.text.trim(),
                                message: _messageController.text.trim(),
                                email: _emailController.text.trim(),
                                phone: _phoneController.text.trim());

                          }

                        },

                      ),
                    ),
                  ],
                ),
              );
            });



          })),
    );
  }
}
