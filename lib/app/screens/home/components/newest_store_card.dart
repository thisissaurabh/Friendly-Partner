import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_buttons.dart';
import 'package:friendly_partner/app/widgets/custom_card_container.dart';
import 'package:friendly_partner/app/widgets/custom_network_image.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';

class NewestStoreCard extends StatelessWidget {
  final String storeName;
  final String location;
  final String rating;
  final String logo;
  final bool isConnected;
  final VoidCallback onViewPressed;

  const NewestStoreCard({
    super.key,
    required this.storeName,
    required this.location,
    this.isConnected = true,
    required this.onViewPressed,
    required this.rating,
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 20,
            ),
            CustomCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingButtonWidget(
                    rating: rating.toString(),
                  ),
                  Text(
                    storeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                        color: redColor,
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
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
                    icon: Icons.arrow_forward,
                    height: 40,
                    color: Theme.of(context).disabledColor,
                    buttonText: "View Store",
                    onPressed: onViewPressed,
                    fontSize: Dimensions.fontSize14,
                  )
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
          child: CustomCardContainer(
              width: 50,
              child: CustomNetworkImageWidget(
                width: 50,
                height: 20,
                image: '${AppConstants.onlyBaseUrl}${logo}',
              )),
        )
      ],
    );
  }
}
