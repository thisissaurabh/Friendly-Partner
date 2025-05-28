import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import '../../../data/repo/whole_seller.dart';
import '../../../utils/styles.dart';
import '../../../utils/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class RetailerOrderDetails extends StatelessWidget {
  final String orderId;
  const RetailerOrderDetails({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final controller =
    Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WholeSellerController>().getRetailerOrderDetails(productId: orderId);
    });

    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Order Details",
          isHideCart: true,
          isBackButtonExist: true,
        ),
        body: GetBuilder<WholeSellerController>(builder: (controller) {
          final order = controller.retailerOrderDetails;
          if (order == null || order.isEmpty) {
            return const Center(
              child: Text("No Details Available"),
            );
          }

          final shop = order['shop'];
          final address = order['address'];
          final products = order['products'] as List;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Order Info"),
                _buildInfoRow("Order ID", order['order_code']),
                _buildInfoRow("Status", order['order_status']),
                _buildInfoRow("Placed At", order['placed_at']),
                _buildInfoRow("Est. Delivery", order['estimated_delivery_date']),
                _buildInfoRow("Payment Method", order['payment_method']),
                _buildInfoRow("Payment Status", order['payment_status']),

                // const SizedBox(height: 16),
                // _buildSectionTitle("Shop Info"),
                _buildInfoRow("Shop Name", shop['name']),
                // _buildInfoRow("Shop Address", shop['address']),
                // _buildInfoRow("Rating", "${shop['rating']}"),
                // _buildInfoRow("Total Reviews", shop['total_reviews']),
                // _buildInfoRow("Status", shop['shop_status']),

                const SizedBox(height: 16),
                _buildSectionTitle("Delivery Address"),
                _buildInfoRow("Name", address['name']),
                _buildInfoRow("Phone", address['phone']),
                _buildInfoRow("Flat No.", address['flat_no']),
                _buildInfoRow("Area", address['area']),
                _buildInfoRow("Address Line 1", address['address_line']),
                _buildInfoRow("Address Line 2", address['address_line2']),
                _buildInfoRow("Post Code", address['post_code']),

                const SizedBox(height: 16),
                _buildSectionTitle("Products (${products.length})"),
                ...products.map((product) => _buildProductCard(product)).toList(),

                const SizedBox(height: 16),
                _buildSectionTitle("Payment Summary"),
                _buildInfoRow("Total Amount", "₹${order['total_amount']}"),
                // _buildInfoRow("Discount", "₹${order['discount']}"),
                _buildInfoRow("Tax", "₹${order['tax_amount']}"),
                _buildInfoRow("Delivery Charge", "₹${order['delivery_charge']}"),
                Divider(),
                _buildInfoRow("Payable Amount", "₹${order['payable_amount']}", isBold: true),

                const SizedBox(height: 16),
                _buildDownloadButton("Download Invoice", order['invoice_url']),
                _buildDownloadButton("Download Payment Receipt", order['payment_receipt_url']),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: robotoBold.copyWith(fontSize: 16)),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(title, style: robotoRegular)),
          Expanded(
            child: Text(
              value,
              style: isBold
                  ? robotoBold.copyWith(color: Colors.black)
                  : robotoRegular.copyWith(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            product['thumbnail'].toString().startsWith('http')
                ? product['thumbnail']
                : 'https://friendly.invoidea.in${product['thumbnail']}',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(product['name'], style: robotoBold),
        subtitle: Text(
          '${product['brand'] ?? ''} x ${product['order_qty']}',
          style: robotoRegular,
        ),
        trailing: Text('₹${product['price']}', style: robotoMedium),
      ),
    );
  }

  Widget _buildDownloadButton(String label, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),

          ),
          onPressed: () {
            Get.to(() => WebViewScreen(url: url, title: label));
          },
          icon: const Icon(Icons.download),
          label: Text(label),
        ),
      ),
    );
  }
}

// You can implement a simple WebViewScreen if needed for invoice viewing
class WebViewScreen extends StatelessWidget {
  final String url;
  final String title;

  WebViewScreen({super.key, required this.url, required this.title});
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await _downloadPDF(context);
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        url,
        key: _pdfViewerKey,
      ),
    );
  }

  Future<void> _downloadPDF(BuildContext context) async {
    try {
      await requestStoragePermission();

      // Ask permission
      // final status = await Permission.storage.request();
      // if (!status.isGranted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Storage permission is required')),
      //   );
      //   return;
      // }

      // Download the file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/${title.replaceAll(" ", "_")}.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF downloaded to $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download PDF')),
        );
      }
    } catch (e) {
      print('Download error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during download')),
      );
    }
  }
}

Future<bool> requestStoragePermission() async {
  if (Platform.isAndroid) {
    if (await Permission.storage.request().isGranted) {
      return true;
    }

    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      return true;
    } else {
      await openAppSettings();
      return false;
    }
  }
  return true;
}