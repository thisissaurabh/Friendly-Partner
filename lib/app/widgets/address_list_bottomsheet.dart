import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/app/widgets/custom_snackbar.dart';
import 'package:friendly_partner/app/widgets/custom_textfield.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/cart_controller.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

import '../../../controllers/user_map_controller.dart';
import '../../utils/images.dart';
import 'add_address_bottomsheet.dart';
import 'loading_dialog.dart';


class AddressListBottomSheet extends StatelessWidget {
  final String note;
  final List<dynamic> shopIds;
  AddressListBottomSheet({super.key, required this.note, required this.shopIds});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(UserMapController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().getAddressList();
      Get.find<UserMapController>().getUserLocation();

    });

    return SafeArea(
      child: GetBuilder<AuthController>(builder: (controller) {
        final data = controller.addressList;
        final isListEmpty = data == null || data.isEmpty;



        return GetBuilder<CartController>(builder: (cartControl) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.radius10),
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: isListEmpty ?
                Column(
                  children: [
                    Align(alignment: Alignment.centerRight,
                        child: IconButton(onPressed: () {}, icon: Icon(Icons.close))),

                    Image.asset(Images.icAddress,height: 180,width: 180,),
                    // sizedBox10(),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSize50),
                    child: CustomButtonWidget(buttonText: "Add Address To Continue",
                    onPressed: () {
                      Get.back();
                      Get.bottomSheet(AddAddressBottomSheet());
                    },
                    ),
                  )
                  ],
                ):



            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Select Address", style: robotoMedium),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),

                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(bottom: Dimensions.paddingSize50),
                          physics: NeverScrollableScrollPhysics(),

                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            final address = data[index];
                            final addressType = (address["address_type"] ?? "").toLowerCase();

                            IconData icon;
                            Color color;

                            switch (addressType) {
                              case "home":
                                icon = Icons.home;
                                color = Colors.green;
                                break;
                              case "office":
                                icon = Icons.business;
                                color = Colors.blue;
                                break;
                              default:
                                icon = Icons.location_on;
                                color = Colors.grey;
                            }
                            final isDefault = address["is_default"] == true;
                            return CustomCardContainer(
                              color :  controller.selectedAddressIndex == index
                                  ? Colors.blue.withOpacity(0.20) // selected background color
                                  : Colors.white,
                              child: ListTile(
                                onTap: () {
                                  controller.selectAddress(index);
                                  cartControl.selectPinCode(address["post_code"] ?? '');
                                  print('PINCODE : ${cartControl.selectedPinCode}');
                                  cartControl.selectAddressId(address["id"].toString());
                                  print('selectedAddressId : ${cartControl.selectedAddressId}');
                                  Get.find<CartController>().getCheckPinCodeList(pinCode: cartControl.selectedPinCode);
                                },
                                leading: CircleAvatar(
                                  backgroundColor: color.withOpacity(0.1),
                                  child: Icon(icon, color: color),
                                ),
                                title: Text(address["name"] ?? '', style: robotoBold),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sizedBox5(),
                                    Text("Phone: ${address["phone"] ?? ""}"),
                                    sizedBox3(),
                                    Text(maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        "Address Line 1: ${address["address_line"] ?? ""}"
                                    ),
                                  ],
                                ),
                                isThreeLine: true,
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            );
                          }, separatorBuilder: (BuildContext context, int index) => sizedBoxDefault(),
                        ),
                      ),
                      Positioned(bottom:0,
                        left: Dimensions.paddingSize10,
                        right: Dimensions.paddingSize10,
                        child: Column(
                          children: [
                            cartControl.isCheckingPinCodeLoading ?
                            CustomButtonWidget(
                              buttonText: "Please wait",
                              onPressed: () async {
                              },
                            ) :

                            CustomButtonWidget(
                              buttonText: "Place Order",
                              onPressed: () async {
                                if (controller.selectedAddressIndex == null) {
                                   LoadingGif.showLoading(lottie: Images.lottieFailed,message: "Please Select Address to Place Order.");
                                   await Future.delayed(const Duration(seconds: 3));
                                   LoadingGif.hideLoading();


                                } else {

                                   if (cartControl.checkPinCode == null || cartControl.checkPinCode?['is_deliverable'] == 0) {
                                   LoadingGif.showLoading(message: "Delivery Not Available in Selected Pincode.", lottie: Images.lottieFailed);
                                   await Future.delayed(const Duration(seconds: 3));
                                   LoadingGif.hideLoading();
                                   } else {
                                  cartControl.placeOrderApi(
                                      shopIds: shopIds,
                                      addressId: cartControl.selectedAddressId,
                                      note: note.isEmpty ? "N/A" : note,
                                      paymentMethod: "cash",
                                      couponCode: "");
                                   }

                                }



                              },

                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      }),
    );
  }
}
