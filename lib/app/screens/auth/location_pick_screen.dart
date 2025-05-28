import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/controllers/auth_controller.dart';
import 'package:friendly_partner/controllers/user_map_controller.dart';
import 'package:friendly_partner/helper/route_helper.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class LocationPickerScreen extends StatelessWidget {
  final bool isBack;

  LocationPickerScreen({super.key, this.isBack = false});
  final UserMapController userMapController = Get.put(UserMapController());
  // final AuthController controller = Get.put(AuthController(authRepo: Get.find(), sharedPreferences: Get.f));

  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Your Location', style: robotoRegular),
          centerTitle: true,
        ),
        body: GetBuilder<AuthController>(builder: (authControl) {
          return GetBuilder<UserMapController>(
            builder: (locationControl) {
              // Check if the location values are null and handle accordingly
              if (locationControl.latitude == null ||
                  locationControl.longitude == null) {
                return const Center(child: CircularProgressIndicator());
              }

              // Ensure latitude and longitude are non-null
              LatLng center = LatLng(
                locationControl.latitude ?? 0.0,
                locationControl.longitude ?? 0.0,
              );

              return Stack(
                children: [
                  GoogleMap(
                    mapToolbarEnabled: false,
                    onMapCreated: locationControl.onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: center,
                      zoom: 14.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: center,
                      ),
                    },
                    onCameraMove: (CameraPosition position) {
                      locationControl.latitude = position.target.latitude;
                      locationControl.longitude = position.target.longitude;
                      locationControl
                          .updateAddress(); // Update address on camera move
                      locationControl.update(); // Notify listeners to update UI
                    },
                  ),

                  Positioned(
                    top: Dimensions.paddingSizeDefault,
                    left: Dimensions.paddingSize20,
                    right: Dimensions.paddingSize20,
                    child: TypeAheadField<Map<String, dynamic>>(
                      suggestionsCallback: (pattern) async {
                        await locationControl.fetchSuggestions(pattern);
                        return locationControl.suggestions.toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion['description'] ?? ''),
                        );
                      },
                      emptyBuilder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          child: Text(
                            'Our Service is only Available in West Bengal Currently',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                      onSelected: (suggestion) async {
                        String placeId = suggestion['place_id'] ?? '';
                        await locationControl.fetchLocationDetails(placeId);
                        textController.text = suggestion['description'] ?? '';

                        if (locationControl.latitude != null &&
                            locationControl.longitude != null) {
                          locationControl.mapController?.animateCamera(
                            CameraUpdate.newLatLng(
                              LatLng(locationControl.latitude!,
                                  locationControl.longitude!),
                            ),
                          );
                        }
                      },
                      builder: (context, controller, focusNode) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            hintText: 'Search Location',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Positioned(
                  //   top: Dimensions.paddingSizeDefault,
                  //   left: Dimensions.paddingSize20,
                  //   right: Dimensions.paddingSize20,
                  //   child: TypeAheadField(
                  //     textFieldConfiguration: TextFieldConfiguration(
                  //       decoration: InputDecoration(
                  //         filled: true,
                  //         fillColor: Theme.of(context).cardColor,
                  //         hintText: 'Search Location',
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //     ),
                  //     suggestionsCallback: (pattern) async {
                  //       await locationControl.fetchSuggestions(pattern);
                  //       return locationControl.suggestions.toList();
                  //     },
                  //     itemBuilder: (context, suggestion) {
                  //       return ListTile(
                  //         title: Text(suggestion['description'] ?? ''),
                  //       );
                  //     },
                  //     noItemsFoundBuilder: (context) {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  //         child: Text(
                  //           'Our Service is only Available in West Bengal Currently',
                  //           style: TextStyle(
                  //             color: Theme.of(context).primaryColor, // Customize color if needed
                  //             fontSize: 16,
                  //           ),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       );
                  //     },
                  //     onSuggestionSelected: (suggestion) async {
                  //       String placeId = suggestion['place_id'] ?? '';
                  //       await locationControl.fetchLocationDetails(placeId);
                  //       if (locationControl.latitude != null &&
                  //           locationControl.longitude != null) {
                  //         locationControl.mapController?.animateCamera(
                  //           CameraUpdate.newLatLng(
                  //             LatLng(
                  //               locationControl.latitude!,
                  //               locationControl.longitude!,
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //     },
                  //   ),
                  // ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Theme.of(context).cardColor.withOpacity(0.60),
                        //    borderRadius: BorderRadius.circular(Dimensions.radius10)
                        //
                        //    ),
                        //   child: const Text(' Note: You Location is Set To Kolkata\n We are currently Available in West Bengal ',
                        //   textAlign: TextAlign.center,),
                        // ),
                        // sizedBox10(),
                        CustomButtonWidget(
                          buttonText: 'Continue',
                          onPressed: () {
                            if (locationControl.address != null) {
                              print(
                                  '==========> Address ${locationControl.address}');
                              print(
                                  '==========> Latitude ${locationControl.latitude}');
                              print(
                                  '==========> Longitude ${locationControl.longitude}');
                              authControl.saveLatitude(
                                  locationControl.latitude ?? 0.0);
                              authControl.saveLongitude(
                                  locationControl.longitude ?? 0.0);
                              authControl.saveAddress(locationControl.address!);
                              authControl
                                  .saveHomeAddress(locationControl.address!);
                              if (isBack == true) {
                                Get.back();
                              } else {

                                if(authControl.isWholeSellerLogin()) {
                                  Get.offNamed(RouteHelper.getWholeSellerDashboardRoute());

                                } else {
                                  Get.offNamed(RouteHelper.getDashboardRoute());

                                }

                              }
                            } else {
                              // Handle the case where address is null
                              print('Address is null');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
