import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';

class RatingButtonWidget extends StatelessWidget {
  final String rating;
  const RatingButtonWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('',
          // rating,
          style: robotoMedium.copyWith(color: ratingYellowColor),
        ),
        sizedBoxW5(),
        Icon(
          CupertinoIcons.star_fill,
          color: Colors.white,
          // color: ratingYellowColor,
          size: 16,
        )
      ],
    );
  }
}
