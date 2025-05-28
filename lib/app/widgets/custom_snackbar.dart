import 'package:flutter/material.dart';

// void showCustomSnackBar(String? message, {bool isError = true}) {
//   Get.showSnackbar(GetSnackBar(
//     backgroundColor: isError ? Colors.red : Colors.green,
//     message: message,
//     duration: const Duration(seconds: 3),
//     snackStyle: SnackStyle.FLOATING,
//     margin: const EdgeInsets.all(Dimensions.paddingSize10),
//     borderRadius: 10,
//     isDismissible: true,
//     dismissDirection: DismissDirection.horizontal,
//   ));
// }

void showCustomSnackBar(BuildContext context, String? message,
    {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16,),
        child: Text(
          textAlign: TextAlign.center,
          message ?? "",
          style: const TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 3),
      // behavior: SnackBarBehavior.floating,
    ),
  );
}


// void showCustomSnackBar(String? message, {bool isError = true} ) {
//   Fluttertoast.showToast(
//     msg: message ?? "",
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     backgroundColor: Colors.white.withOpacity(0.60),
//     // backgroundColor: isError ? Colors.red : Colors.green,
//     textColor: Colors.black,
//     fontSize: 16.0,
//     timeInSecForIosWeb: 3,
//   );
// }