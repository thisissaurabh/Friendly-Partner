import 'package:flutter/material.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/images.dart';
import 'package:get/get.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNetworkImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String placeholder;
  final double? radius;
  final double? imagePadding;
  const CustomNetworkImageWidget(
      {super.key,
      required this.image,
      this.height,
      this.width,
      this.fit = BoxFit.cover,
      this.placeholder = '',
      this.radius,
      this.imagePadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 200,
      width: width ?? Get.size.width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          // color: Colors.grey[200],
          borderRadius: BorderRadius.circular(radius ?? Dimensions.radius20)),
      child: CachedNetworkImage(
        imageUrl: image,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Padding(
          padding: EdgeInsets.all(imagePadding ?? 0),
          child: Image.asset(
            color: Colors.grey,
              placeholder.isNotEmpty ? placeholder : Images.icBrokenImage,
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}




class CustomRoundNetworkImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String placeholder;
  final double? radius;
  final double? imagePadding;
  const CustomRoundNetworkImageWidget(
      {super.key,
        required this.image,
        this.height,
        this.width,
        this.fit = BoxFit.cover,
        this.placeholder = '',
        this.radius,
        this.imagePadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 100,
      width: width ?? 100,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // color: Colors.grey[200],
        //   borderRadius: BorderRadius.circular(radius ?? Dimensions.radius20)
      ),
      child: CachedNetworkImage(
        imageUrl: image,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Padding(
          padding: EdgeInsets.all(imagePadding ?? 0),
          child: SvgPicture.asset(
              placeholder.isNotEmpty ? placeholder : Images.svgProfile,
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
