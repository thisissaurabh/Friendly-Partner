import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_textfield.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/sizeboxes.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:get/get.dart';

class MultiSelectDropdown extends StatefulWidget {
  final List<String> options;
  final RxList<String> selectedItems;
  final String hintText;

  MultiSelectDropdown({
    Key? key,
    required this.options,
    required this.selectedItems,
    this.hintText = 'Select items',
  }) : super(key: key);

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with the selected items
    controller.text = widget.selectedItems.join(', ');
  }

  void _showMultiSelectBottomSheet() {
    Get.bottomSheet(
      Stack(
        children: [
          Container(
            height: Get.size.height * 0.6, // Adjust the height as needed
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: SingleChildScrollView(
              child: Obx(() {
                return Column(
                  children: widget.options.map((item) {
                    Color color = _getColorForItem(item);

                    return CheckboxListTile(
                      title: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 10), // Space between color and text
                          Text(item),
                        ],
                      ),
                      value: widget.selectedItems.contains(item),
                      onChanged: (bool? selected) {
                        if (selected == true) {
                          widget.selectedItems.add(item);
                        } else {
                          widget.selectedItems.remove(item);
                        }
                        controller.text = widget.selectedItems.join(', ');
                      },
                    );
                  }).toList(),
                );
              }),
            ),
          ),
          Positioned(
            bottom: Dimensions.paddingSizeDefault,
            left: Dimensions.paddingSizeDefault,
            right: Dimensions.paddingSizeDefault,
            child: Row(
              children: [
                Expanded(
                  child: CustomButtonWidget(buttonText: "Cancel",
                    onPressed: () {
                    Get.back();
                    },
                    color: redColor,
                    borderSideColor: redColor,
                    height: 40,fontSize: Dimensions.fontSize14,),
                ),
                sizedBoxW10(),
                Expanded(
                  child: CustomButtonWidget(buttonText: "Done",
                    onPressed: () {
                      Get.back();
                    },
                    borderSideColor: greenColor,
                  color: greenColor,
                  height: 40,fontSize: Dimensions.fontSize14,),
                ),
              ],
            ),
          )
        ],
      ),
      isDismissible: true, // Allows closing by tapping outside
      backgroundColor: Colors.transparent,
    );
  }

  // This method will map the color name to an actual Color
  Color _getColorForItem(String item) {
    // Expanded list of industry standard colors
    switch (item.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'gray':
        return Colors.grey;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'teal':
        return Colors.teal;
      case 'cyan':
        return Colors.cyan;
      case 'lime':
        return Colors.lime;
      case 'indigo':
        return Colors.indigo;
      case 'amber':
        return Colors.amber;
      case 'deepPurple':
        return Colors.deepPurple;
      case 'deepOrange':
        return Colors.deepOrange;
      case 'blueGrey':
        return Colors.blueGrey;
      case 'lightBlue':
        return Colors.lightBlue;
      case 'lightGreen':
        return Colors.lightGreen;
      case 'yellowAccent':
        return Colors.yellowAccent;
      case 'greenAccent':
        return Colors.greenAccent;
      case 'blueAccent':
        return Colors.blueAccent;
      case 'redAccent':
        return Colors.redAccent;

    // Additional custom colors
      case 'magenta':
        return Colors.pink; // Flutter doesn't have a direct magenta color, so we use pink.
      case 'violet':
        return Colors.deepPurple; // A close match for violet.
      case 'gold':
        return Color(0xFFFFD700); // Hex code for gold.
      case 'silver':
        return Color(0xFFC0C0C0); // Hex code for silver.
      case 'beige':
        return Color(0xFFF5F5DC); // Hex code for beige.
      case 'lavender':
        return Color(0xFFE6E6FA); // Hex code for lavender.
      case 'turquoise':
        return Color(0x40E0D0); // Hex code for turquoise.
      case 'coral':
        return Color(0xFFFF7F50); // Hex code for coral.
      case 'maroon':
        return Color(0x800000); // Hex code for maroon.
      case 'navy':
        return Color(0x000080); // Hex code for navy.
      case 'olive':
        return Color(0x808000); // Hex code for olive.
      case 'charcoal':
        return Color(0x36454F); // Hex code for charcoal.
      case 'peach':
        return Color(0xFFDABB8); // Hex code for peach.
      case 'mint':
        return Color(0x98FF98); // Hex code for mint.
      case 'aqua':
        return Colors.cyanAccent; // Close match for aqua.
      case 'rose':
        return Color(0xFF007A33); // Hex code for rose.
      case 'emerald':
        return Color(0x50C878); // Hex code for emerald.
      case 'crimson':
        return Color(0xDC143C); // Hex code for crimson.
      case 'sky blue':
        return Color(0x87CEEB); // Hex code for sky blue.
      case 'sea green':
        return Color(0x2E8B57); // Hex code for sea green.
      case 'slate':
        return Color(0x708090); // Hex code for slate.
      case 'plum':
        return Color(0x8E4585); // Hex code for plum.
      case 'rust':
        return Color(0xB7410E); // Hex code for rust.
      case 'copper':
        return Color(0xB87333); // Hex code for copper.
      case 'ivory':
        return Color(0xFFFFF0); // Hex code for ivory.
      case 'fuchsia':
        return Color(0xFF00FF); // Hex code for fuchsia.
      case 'chartreuse':
        return Color(0x7FFF00); // Hex code for chartreuse.
      case 'tan':
        return Color(0xD2B48C); // Hex code for tan.
      case 'sapphire':
        return Color(0x0F52BA); // Hex code for sapphire.
      case 'lilac':
        return Color(0xC8A2C8); // Hex code for lilac.

    // Default for unknown colors
      default:
        return Colors.transparent; // Fallback color
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showMultiSelectBottomSheet,
      child: AbsorbPointer(
        child: CustomTextField(
          showTitle: true,
          hintText: widget.hintText,
          controller: controller,
        ),
      ),
    );
  }
}
