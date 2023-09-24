import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/validator.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(this.controller,
      {super.key,
      this.labelText = '',
      this.hintText = '',
      this.required = false,
      this.enabled = true,
      this.icon,
      this.suffixIcon,
      this.maxLines = 1,
      this.padding = const EdgeInsets.only(bottom: 15),
      this.keyboardType,
      this.fixedLength,
      this.isAmount = false,
      this.isFixedLengthRestricted = true,
      this.validator,
      this.inputFormatter});

  final TextEditingController controller;
  final bool required, enabled;
  final String labelText;
  final String hintText;
  final int maxLines;
  final EdgeInsets padding;
  final Widget? suffixIcon;
  final IconData? icon;
  final TextInputType? keyboardType;
  final int? fixedLength;
  final bool isAmount, isFixedLengthRestricted;
  final List<TextInputFormatter>? inputFormatter;

  final FormFieldValidator<String>? validator;
  @override
  Widget build(BuildContext context) {
    final String requiredIndicator = required ? ' *' : '';
    return Padding(
      padding: padding,
      child: TextFormField(
        inputFormatters: inputFormatter ??
            [
              LengthLimitingTextInputFormatter(fixedLength), // for mobile
            ],
        maxLines: maxLines,
        enabled: enabled,
        keyboardType: (keyboardType == TextInputType.name && Platform.isAndroid)
            ? keyboardType
            : (keyboardType == TextInputType.name && Platform.isIOS)
                ? TextInputType.text
                : keyboardType,
        textCapitalization: (keyboardType == TextInputType.name)
            ? TextCapitalization.words
            : TextCapitalization.none,
        style: const TextStyle(
          color: Colors.black87,
        ),
        decoration: InputDecoration(
            alignLabelWithHint: true,
            errorMaxLines: 2,
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.black.withOpacity(0.38), width: 2),
                borderRadius: BorderRadius.circular(8)),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(8)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(8)),
            errorStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 12, color: Colors.red),
            labelText: labelText + requiredIndicator,
            hintText: hintText.isEmpty ? labelText : hintText,
            icon: icon != null
                ? Icon(
                    icon,
                  )
                : null,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.all(19)),
        validator: (value) {
          if (validator != null) {
            return validator!(value);
          }
          final label = labelText.toLowerCase();
          if (value!.isEmpty || value.trim().isEmpty) {
            if (required) {
              if (isVowels(label)) {
                return 'Please enter an $label.';
              } else {
                return 'Please enter a $label.';
              }
            }
          }
          if (isAmount) {
            final double amount =
                double.tryParse(value.replaceAll(',', '')) ?? 0;
            if (amount <= 0) {
              return '$labelText is invalid.';
            }
          }
          if (isFixedLengthRestricted && fixedLength != null) {
            if (value.length != fixedLength) {
              return '$labelText must be $fixedLength characters long. ';
            }
          }
          return null;
        },
        controller: controller,
      ),
    );
  }
}
