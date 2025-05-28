import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/utils/dimensions.dart';

class StoreCard extends StatelessWidget {
  final String storeName;
  final String location;
  final bool isConnected;
  final VoidCallback onViewPressed;

  const StoreCard({
    super.key,
    required this.storeName,
    required this.location,
    this.isConnected = true,
    required this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: isConnected
                      ? Colors.lightGreen.shade100
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    color: isConnected ? Colors.green : Colors.grey.shade700,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            storeName,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.grey,
                size: 16.0,
              ),
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  location,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          CustomButtonWidget(
            height: 40,
            color: Theme.of(context).disabledColor,
            buttonText: "View",
            onPressed: onViewPressed,
            fontSize: Dimensions.fontSize14,
          )
        ],
      ),
    );
  }
}
