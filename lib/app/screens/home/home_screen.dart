import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/auth/location_pick_screen.dart';
import 'package:friendly_partner/app/screens/cart/cart.dart';
import 'package:friendly_partner/app/screens/dashboard/dashboard.dart';
import 'package:friendly_partner/app/screens/home/components/connected_wholesellers.dart';
import 'package:friendly_partner/app/screens/home/components/nearest_stores.dart';
import 'package:friendly_partner/app/screens/home/components/newest_store.dart';
import 'package:friendly_partner/app/screens/home/components/top_rated_stores.dart';
import 'package:friendly_partner/app/widgets/custom_notification_button.dart';
import 'package:friendly_partner/app/widgets/custom_searchfield.dart';
import 'package:friendly_partner/app/widgets/verify_wholeseller.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/cart_controller.dart';
import 'package:friendly_partner/controllers/home_controller.dart';
import 'package:friendly_partner/controllers/profile_controller.dart';
import 'package:friendly_partner/data/repo/cart_repo.dart';
import 'package:friendly_partner/data/repo/home_repo.dart';
import 'package:friendly_partner/utils/app_constants.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/images.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../widgets/custom_network_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Get.put(HomeRepo(apiClient: Get.find()));
    final controller = Get.put(HomeController(homeRepo: Get.find()));
    final repoc = Get.put(CartRepo(apiClient: Get.find()));
    final controllerc = Get.put(CartController(cartRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HomeController>().getHomeData();
      Get.find<CartController>().getCartList();
    });
    return SafeArea(
      child: Scaffold(body: GetBuilder<HomeController>(builder: (homeControl) {
        final list = homeControl.retailerHomeData;
        final isListEmpty = list == null || list.isEmpty;

        if (isListEmpty) {
          return SizedBox.shrink();
        }

        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              backgroundColor: Theme.of(context).hintColor,
              expandedHeight: 170.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    child: Column(
                      children: [
                        sizedBox20(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              height: 70,
                              width: 70,
                              Images.logo,
                            ),
                            Obx(() {
                              final address =
                                  Get.find<AuthController>().address.value;
                              return Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  Get.to(() => LocationPickerScreen(
                                        isBack: true,
                                      ));
                                },
                                child: Text(
                                  address,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSize14,
                                      color: Theme.of(context).disabledColor),
                                ),
                              ));
                            }),
                            CustomNotificationButton(
                              tap: () {
                                // Get.toNamed(RouteHelper.getNotificationRoute());
                              },
                            ),
                            CustomCartNotification(
                              tap: () {
                                Get.to(() => CartScreen());
                              },
                            )
                          ],
                        ),
                        sizedBox10(),
                      ],
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40.0),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(
                    children: [CustomConnectedSearchfield()],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ConnectedWholesellers(
                    connectedWholeSeller: (list['connectedWoleseller'] is List && (list['connectedWoleseller'] as List).isNotEmpty)
                        ? list['connectedWoleseller']
                        : [],

                  ),


                  sizedBox10(),
                  if (list['banners'] != null)
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 140.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        aspectRatio: 1,
                        autoPlayInterval: Duration(seconds: 3),
                      ),
                      items: (list['banners'] as List).map((banner) {
                        return Builder(
                          builder: (BuildContext context) {
                            return CustomNetworkImageWidget(image:   '${AppConstants.onlyBaseUrl}${banner['thumbnail']}',
                            );
                          },
                        );
                      }).toList(),
                    ),
                  sizedBox10(),
                  NewestStore(
                    newestStore: list['newest_store'] as List,
                  ),
                  TopRatedStores(
                    newestStore: list['top_rated_store'] as List,
                  ),
                  // NearestStores()
                ],
              ),
            )
          ],
        );
      })),
    );
  }
}
