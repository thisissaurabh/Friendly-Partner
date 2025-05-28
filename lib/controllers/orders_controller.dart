import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  set currentIndex(int value) => _currentIndex.value = value;

  final PageController pageController = PageController(initialPage: 0);

  void goToTab(int index) {
    currentIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    update();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
