import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/profile/support_ticket.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:get/get.dart';

import '../../../data/repo/whole_seller.dart';
import '../../../utils/styles.dart';

class AllSupportTicketScreen extends StatelessWidget {
  const AllSupportTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartRepo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final wholeC = Get.put(WholeSellerController(wholeSellerRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      wholeC.getSupportTicketList();
    });

    return SafeArea(
      child: Scaffold(
        appBar: CustomBackAppBar(title: "Support Tickets", isBackButtonExist: true),
        body: GetBuilder<WholeSellerController>(builder: (controller) {
          final ticketData = controller.supportTicketList;
          final tickets = ticketData?['support_tickets'] ?? [];

          if (tickets.isEmpty) {
            return const Center(
              child: Text(
                "No Support Tickets Available",
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBox10(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'You have ${ticketData!['total']} total ticket(s)',
                  style: robotoSemiBold.copyWith(color: Theme.of(context).primaryColor),
                ),
              ),

              sizedBox10(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildStatusBox("Running", ticketData['running'], Colors.orange),
                    _buildStatusBox("Completed", ticketData['completed'], Colors.green),
                    _buildStatusBox("Cancelled", ticketData['cancel'], Colors.red),
                  ],
                ),
              ),

              sizedBox10(),

              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: tickets.length,
                  separatorBuilder: (_, __) => sizedBox10(),
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return CustomCardContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ticket No: ${ticket['ticket_no']}",
                              style: robotoBold.copyWith(fontSize: 16),
                            ),
                            sizedBox5(),
                            Text("Subject: ${ticket['subject'] ?? '-'}",
                                style: robotoMedium.copyWith(fontSize: 14)),
                            sizedBox5(),
                            Text("Issue Type: ${ticket['issue_type'] ?? '-'}",
                                style: robotoRegular.copyWith(fontSize: 14)),
                            sizedBox5(),
                            Text("Created At: ${ticket['created_at'] ?? '-'}",
                                style: robotoRegular.copyWith(fontSize: 13, color: Colors.grey[700])),
                            sizedBox10(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _statusColor(ticket['status']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: _statusColor(ticket['status'])),
                                ),
                                child: Text(
                                  ticket['status'].toString().capitalize ?? '',
                                  style: robotoMedium.copyWith(color: _statusColor(ticket['status']), fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: SingleChildScrollView(
            child: CustomButtonWidget(buttonText: "Create Support Ticket",
            onPressed: () {
              Get.to(() => CreateSupportTicketScreen());


            },),
          ),
        ),
      ),
    );
  }

  // Summary Box Widget
  Widget _buildStatusBox(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: robotoBold.copyWith(fontSize: 16, color: color),
          ),
          Text(
            label,
            style: robotoRegular.copyWith(fontSize: 13, color: color),
          ),
        ],
      ),
    );
  }

  // Status color logic
  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
      case 'running':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancel':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
