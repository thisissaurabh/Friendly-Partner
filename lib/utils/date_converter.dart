//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:get/get.dart';
//
// class DateConverter {
//
//   static String formatDate(DateTime dateTime) {
//     return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
//   }
//
//   static String estimatedDate(DateTime dateTime) {
//     return DateFormat('dd MMM yyyy').format(dateTime);
//   }
//
//   static String estimatedOnlyDate(DateTime dateTime) {
//     return DateFormat('dd-MM-yyyy').format(dateTime);
//   }
//
//   // A method to parse a date string into a DateTime object
//   static DateTime parseDateString(String dateString) {
//     return DateTime.parse(dateString); // Adjust the parsing format if needed
//   }
//   static DateTime convertStringToDatetime(String dateTime) {
//     return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
//   }
//
//   static DateTime isoStringToLocalDate(String dateTime) {
//     return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime);
//   }
//
//
//   static String dateTimeStringToDateOnly(String dateTime) {
//     return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
//   }
//
//   static String dateTimeStringForDisbursement(String time) {
//     var newTime = '${time.substring(0,10)} ${time.substring(11,23)}';
//     return DateFormat('dd MMM, yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(newTime));
//   }
//
//   static DateTime dateTimeStringToDate(String dateTime) {
//     return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
//   }
//
//   static String isoStringToLocalDateOnly(String dateTime) {
//     return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
//   }
//
//   static String localDateToIsoString(DateTime dateTime) {
//     return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime);
//   }
//
//
//   static String convertTimeToTime(DateTime time) {
//     return DateFormat('HH:mm').format(time);
//   }
//
//   static DateTime convertTimeToDateTime(String time) {
//     return DateFormat('HH:mm').parse(time);
//   }
//
//   static String convertDateToDate(String date) {
//     return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd').parse(date));
//   }
//
//   static String dateTimeStringToMonthAndTime(String dateTime) {
//     return DateFormat('dd MMM yyyy HH:mm').format(dateTimeStringToDate(dateTime));
//   }
//
//   static String dateTimeForCoupon(DateTime dateTime) {
//     return DateFormat('yyyy-MM-dd').format(dateTime);
//   }
//
//
//
//
//   static int differenceInMinute(String? deliveryTime, String? orderTime, int? processingTime, String? scheduleAt) {
//     int minTime = processingTime ?? 0;
//     if(deliveryTime != null && deliveryTime.isNotEmpty && processingTime == null) {
//       try {
//         List<String> timeList = deliveryTime.split('-');
//         minTime = int.parse(timeList[0]);
//       }catch(_) {}
//     }
//     DateTime deliveryTime0 = dateTimeStringToDate(scheduleAt ?? orderTime!).add(Duration(minutes: minTime));
//     return deliveryTime0.difference(DateTime.now()).inMinutes;
//   }
//
//   static bool isBeforeTime(String? dateTime) {
//     if(dateTime == null) {
//       return false;
//     }
//     DateTime scheduleTime = dateTimeStringToDate(dateTime);
//     return scheduleTime.isBefore(DateTime.now());
//   }
//
//   static String localDateToIsoStringAMPM(DateTime dateTime) {
//     return DateFormat('MMM d, yyyy ').format(dateTime.toLocal());
//   }
//
//   static int expireDifferanceInDays(DateTime dateTime) {
//     int day = dateTime.difference(DateTime.now()).inDays;
//     return day;
//   }
//
// }
//
//
// class SimpleDateConverter {
//
//   // Method to parse a date string into a DateTime object
//   static DateTime parseDateString(String dateString) {
//     return DateTime.parse(dateString); // Parses the string into DateTime
//   }
//
//   // Method to format a DateTime object into 'dd-MM-yyyy' format
//   static String formatDateToCustomFormat(DateTime dateTime) {
//     return DateFormat('dd-MM-yyyy').format(dateTime);
//   }
//
//   // Example usage combining both methods
//   static String parseAndFormatDateString(String dateString) {
//     DateTime dateTime = parseDateString(dateString);
//     return formatDateToCustomFormat(dateTime);
//   }
//
// }
//
// class TimeConverter {
//   // Method to format a TimeOfDay object into 'HH:mm' format
//   static String formatTimeToCustomFormat(TimeOfDay timeOfDay) {
//     final now = DateTime.now();
//     final dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
//     return DateFormat('HH:mm').format(dateTime);
//   }
// }