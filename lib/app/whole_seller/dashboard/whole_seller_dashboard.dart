import 'package:flutter/material.dart';
import 'package:friendly_partner/app/screens/home/home_screen.dart';
import 'package:friendly_partner/app/screens/orders/orders_screen.dart';
import 'package:friendly_partner/app/screens/partners/connected_wholeseller_screen.dart';
import 'package:friendly_partner/app/screens/profile/profile_screen.dart';
import 'package:friendly_partner/controllers/profile_controller.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/images.dart';
import '../home/retailer/retailers.dart';
import '../home/whole_seller_home.dart';
import '../orders/whole_seller_order.dart';
import '../profile/whole_seller_account.dart';

class WholeSellerDashboard extends StatefulWidget {
  const WholeSellerDashboard({super.key});

  @override
  State<WholeSellerDashboard> createState() => _WholeSellerDashboardState();
}

class _WholeSellerDashboardState extends State<WholeSellerDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    WholeSellerHome(),
    RetailersScreen(),
    WholeSellerOrder(),
    WholeSellerAccount(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Get.find<ProfileController>().getProfileData();
    // });
    return WillPopScope(
      onWillPop: Get.find<AuthController>().handleOnWillPop,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16)
            ),
            boxShadow: [
              BoxShadow(
                color: navBarColor,
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            color: navBarColor, // Background color of the navbar
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Padding(
                    padding:  const EdgeInsets.only(bottom: 5.0),
                    child: SizedBox(
                      height: _selectedIndex == 0 ? 28 : 24,
                      width: _selectedIndex == 0 ? 28 : 24,
                      child: SvgPicture.asset(
                        Images.svgHome,
                        color: Colors.white,
                        fit: BoxFit
                            .contain, // Adjust the fit based on your requirement
                      ),
                    ),
                  ),
                  label: 'HOME',
                ),
                BottomNavigationBarItem(
                  icon:Padding(
                    padding:   EdgeInsets.only(bottom: 5.0),
                    child: SizedBox(
                      height: _selectedIndex == 1 ? 28 : 24,
                      width: _selectedIndex == 1 ? 28 : 24,
                      child: SvgPicture.asset(
                        Images.svgPartner,
                        color: Colors.white,
                        fit: BoxFit
                            .contain, // Adjust the fit based on your requirement
                      ),
                    ),
                  ),
                  label: 'PARTNERS',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding:   EdgeInsets.only(bottom: 5.0),
                    child: SizedBox(
                      height: _selectedIndex == 2 ? 28 : 24,
                      width: _selectedIndex == 2 ? 28 : 24,
                      child: SvgPicture.asset(
                        Images.svgOrder,
                        color: Colors.white,
                        fit: BoxFit
                            .contain, // Adjust the fit based on your requirement
                      ),
                    ),
                  ),
                  label: 'ORDERS',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding:  const EdgeInsets.only(bottom: 5.0),
                    child: SizedBox(
                      height: _selectedIndex == 3 ? 28 : 24,
                      width: _selectedIndex == 3 ? 28 : 24,
                      child: SvgPicture.asset(
                        Images.svgProfile,
                        color: Colors.white,
                        fit: BoxFit
                            .contain, // Adjust the fit based on your requirement
                      ),
                    ),
                  ),
                  label: 'PROFILE',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white, // Highlight color
              unselectedItemColor: Colors.white,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              type: BottomNavigationBarType.fixed, // To show all labels
              onTap: _onItemTapped,
              backgroundColor: Colors
                  .transparent, // Make the BottomNavigationBar itself transparent
              elevation: 0, // Remove default elevation
            ),
          ),
        ),
      ),
    );
  }
}
