import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:get/get.dart';

import '../../../../data/repo/whole_seller.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/decorated_containers.dart';

class OrderDetails extends StatelessWidget {
  final String orderId;
  const OrderDetails({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final wholeC = Get.put(WholeSellerController(wholeSellerRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WholeSellerController>().getWholeSellerOrderDetails(ordersId: orderId);
    });

    return SafeArea(
      child: Scaffold(
        appBar: CustomBackAppBar(title: "Order Details",  isBackButtonExist: true,
         ),
        body: GetBuilder<WholeSellerController>(builder: (controller) {
          final order = controller.orderDetails;
      
          if (order == null) {
            return const Center(child: CircularProgressIndicator());
          }
      
          final user = order['user'] ?? {};
          final address = user['address'] ?? {};
          final products = List<Map<String, dynamic>>.from(order['products'] ?? []);
      
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Info
                Row(
                  children: [
                    Expanded(flex: 2,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(maxLines: 2,overflow: TextOverflow.ellipsis,
                              "Order ID: ${order['order_code']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(maxLines: 2,overflow: TextOverflow.ellipsis,
                              "Status: ${order['order_status']}"),
                          Text(maxLines: 2,overflow: TextOverflow.ellipsis,
                              "Payment: ${order['payment_status']} (${order['payment_method']})"),
                          Text(maxLines: 2,overflow: TextOverflow.ellipsis,
                              "Order Placed: ${order['order_placed']}"),
                          Text(
                              "Delivery Date: ${order['delivery_date']}"),
                        ],
                      ),
                    ),
                    order['order_status'] == "Pending" ?
                    Expanded(
                      child: DecoratedContainers(
                        tap: () {
                          // print("check");
                          controller.updateOrderConfirmStatusApi(orderId: orderId);
                        },
                        color: greenColor,
                        paddingType: EdgeInsets.symmetric(vertical: 6,horizontal: Dimensions.paddingSize12),
                          child: Center(
                            child: Text("Confirm Order",style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSize14,
                              color: Colors.white
                            ),),
                          )),
                    ) :
                    order['order_status'] == "Confirm" ?
                    Expanded(
                      child: DecoratedContainers(
                          tap: () {
                            controller.updateOrderCancelStatusApi(orderId: orderId);
                          },
                          color: redColor,
                          paddingType: EdgeInsets.symmetric(vertical: 6,horizontal: Dimensions.paddingSize12),
                          child: Center(
                            child: Text("Cancel Order",style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSize14,
                                color: Colors.white
                            ),),
                          )),
                    ) :
                        SizedBox()




                  ],
                ),
                const SizedBox(height: 16),
      
                // User Info
                const Divider(),
                Text("Customer", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(user['profile_photo'] ?? '')),
                  title: Text(user['name'] ?? ''),
                  subtitle: Text(user['phone'] ?? ''),
                ),
                const SizedBox(height: 8),
      
                // Address Info
                Text("Address", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("${address['flat_no']}, ${address['address_line']}"),
                Text("${address['address_line2'] ?? ''}"),
                Text("Area: ${address['area']}"),
                Text("Post Code: ${address['post_code']}"),
                const SizedBox(height: 16),
      
                // Product List
                Text("Products", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...products.map((product) => Card(
                  child: ListTile(
                    leading: Image.network(product['thumbnail'], width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(product['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Brand: ${product['brand']}"),
                        Text("Qty: ${product['quantity']}"),
                        Text("Price: ₹${product['discount_price']}"),
                      ],
                    ),
                    // trailing: Text(
                    //   product['is_active'] ? "Available" : "Inactive",
                    //   style: TextStyle(color: product['is_active'] ? Colors.green : Colors.red),
                    // ),
                  ),
                )),
      
                const SizedBox(height: 16),
      
                // Summary
                const Divider(),
                Text("Order Summary", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Subtotal: ₹${order['amount']}"),
                Text("Delivery: ₹${order['delivery_charge']}"),
                const SizedBox(height: 12),
                // CustomButtonWidget(buttonText: "Download Invoice",
                //   onPressed: () {
                //     final invoiceUrl = order['invoice_url'];
                //     if (invoiceUrl != null) {
                //       // launchUrl(Uri.parse(invoiceUrl), mode: LaunchMode.externalApplication);
                //     }
                //   },
                //   color: Theme.of(context).primaryColor,
                // ),


              ],
            ),
          );
        }),
      ),
    );
  }
}
