class IndianPriceFormatter {
  static String formatIndianPrice(double value) {
    if (value >= 10000000) {
      double crores = value / 10000000;
      return '${_formatValue(crores)} Cr';
    } else if (value >= 100000) {
      double lakhs = value / 100000;
      return '${_formatValue(lakhs)} L';
    } else if (value >= 1000) {
      double thousands = value / 1000;
      return '${_formatValue(thousands)} K';
    } else {
      return _formatValue(value);
    }
  }

  // Helper method to format values without unnecessary decimals
  static String _formatValue(double value) {
    // Round the value to avoid floating-point precision issues
    double roundedValue = double.parse(value.toStringAsFixed(2));

    // If the value is an integer, return it without decimals
    if (roundedValue == roundedValue.truncateToDouble()) {
      return roundedValue.toStringAsFixed(0); // No decimal part
    } else {
      return roundedValue.toStringAsFixed(2); // Show 2 decimal places if needed
    }
  }

  static double parsePriceString(String priceString) {
    // Remove non-numeric characters (e.g., ₹, commas, spaces)
    String cleanedString = priceString.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.parse(cleanedString);
  }
}
