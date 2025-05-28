import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:get/get.dart';
import '../../../data/repo/whole_seller.dart';

class RetailerDetails extends StatelessWidget {
  final String retailerId;
  const RetailerDetails({super.key, required this.retailerId});

  @override
  Widget build(BuildContext context) {
    final repo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final controller = Get.put(WholeSellerController(wholeSellerRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getRetailerDetails(retailerId: retailerId);
    });

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Retailer Details", isHideCart: true, isBackButtonExist: true),
        body: GetBuilder<WholeSellerController>(builder: (controller) {
      
          final data = controller.retailerDetails;
          if (data == null || data.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
      
      
          final store = data['store'] ?? {};
          final logo = store['media_logo']?['src'];
          final banner = store['media_banner']?['src'];
          final name = store['name'] ?? 'N/A';
          final description = store['description'] ?? 'No description available';
          final prefix = store['prefix'] ?? '';
          final minOrderAmount = store['min_order_amount'] ?? 0.0;
          final deliveryCharge = store['delivery_charge'] ?? 0.0;
      
          return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: CustomRoundNetworkImageWidget(image: '${AppConstants.shopImagebaseUrl}${data["media"]?["src"] ?? "default.jpg"}')),
      
      const SizedBox(height: 16),
      Center(
        child: Column(
          children: [
            Text(
            '${data["name"] ?? ""}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // const SizedBox(height: 4),
            // Text(data["email"] ?? "-", style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      const Divider(height: 32),
      Row(
        children: [
          Expanded(child: _buildTile("Phone", data["phone"])),
          Expanded(child: _buildTile("Email", data["email"])),
        ],
      ),
      
      // Row(
      //   children: [
      //     Expanded(child: _buildTile("Date of Birth", data["date_of_birth"])),
      //     Expanded(child: _buildTile("Status", data["is_active"] == 1 ? "Active" : "Inactive")),
      //   ],
      // ),
      // _buildTile("Verified Email", data["email_verified_at"]),
      // _buildTile("Verified Phone", data["phone_verified_at"]),
      
      
      // if ((data["roles"] as List?)?.isNotEmpty ?? false)
      // _buildTile(
      // "Roles",
      // (data["roles"] as List)
      //     .map((role) => role["name"])
      //     .join(', '),
      // ),
      ],
      ),
      );
      },
      )),
    );
  }

  Widget _buildTile(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value ?? "-"),
      ),
    );

  }
}
