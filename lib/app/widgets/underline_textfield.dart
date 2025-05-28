import 'package:flutter/material.dart';
import 'package:friendly_partner/utils/styles.dart';

class UnderlineTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final Color? underlineColor;
  final double underlineThickness;
  final Color? focusedUnderlineColor;
  final double focusedUnderlineThickness;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextCapitalization textCapitalization;
  final bool showTitle;

  const UnderlineTextField({
    super.key,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.underlineColor = Colors.grey,
    this.underlineThickness = 1.0,
    this.focusedUnderlineColor,
    this.focusedUnderlineThickness = 0.5,
    this.contentPadding,
    this.enabled = true,
    this.focusNode,
    this.onTap,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.showTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showTitle
            ? Text(
                hintText!,
                // Adjust style as needed
              )
            : const SizedBox(),
        SizedBox(height: showTitle ? 0 : 0),
        TextFormField(
          controller: controller,
          cursorColor: Theme.of(context).highlightColor,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
          style:
              robotoRegular.copyWith(color: Theme.of(context).highlightColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                robotoRegular.copyWith(color: Theme.of(context).highlightColor),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: underlineColor ?? Colors.grey,
                width: underlineThickness,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: focusedUnderlineColor ?? Theme.of(context).primaryColor,
                width: focusedUnderlineThickness,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: underlineColor ?? Colors.grey,
                width: underlineThickness,
              ),
            ),
            contentPadding: contentPadding,
            enabled: enabled,
          ),
          focusNode: focusNode,
          onTap: onTap,
          readOnly: readOnly,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          textCapitalization: textCapitalization,
        ),
      ],
    );
  }
}
