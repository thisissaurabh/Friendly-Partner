import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

import '../../../controllers/user_map_controller.dart';
import '../../../utils/images.dart';
import '../../widgets/add_address_bottomsheet.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(UserMapController());
    WidgetsBinding.instance.addPostFrameCallback((_) {

      Get.find<AuthController>().getAddressList();
      Get.find<UserMapController>().getUserLocation();
    });

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Address",
          isHideCart: true,
          isBackButtonExist: true,
        ),
        body: GetBuilder<AuthController>(builder: (controller) {
          final data = controller.addressList;
          final isListEmpty = data == null || data.isEmpty;

          if (isListEmpty) {
            return  Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Images.icAddress,height: 180,width: 180,),
                Text("No addresses found.",style: robotoBold,),
              ],
            ));
          }

          return SingleChildScrollView(
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
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
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.1),
                      child: Icon(icon, color: color),
                    ),
                    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text(address["name"] ?? '', style: robotoBold)),
                        sizedBoxW10(),
                        TextButton(onPressed: () {
                          controller.deleteAddressApi(addressId: address["id"].toString());
                        }, child: Text('Delete Address'))
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBox5(),
                        Text("Phone: ${address["phone"] ?? ""}"),
                        sizedBox3(),
                        Text("Flat No: ${address["flat_no"] ?? ""}, Area: ${address["area"] ?? ""}"),
                        sizedBox3(),

                        Text("Address Line 1: ${address["address_line"] ?? ""}"),
                        sizedBox3(),
                        if (address["address_line2"] != null)
                          Text("Address Line 2: ${address["address_line2"]}"),
                        Text("Post Code: ${address["post_code"] ?? ""}"),
                     

                      ],
                    ),
                    isThreeLine: true,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) => sizedBoxDefault(),
            ),
          );
        }),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: SingleChildScrollView(
            child: CustomButtonWidget(buttonText: "Add Address",
              onPressed: () {
              Get.bottomSheet(AddAddressBottomSheet());
              },
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
