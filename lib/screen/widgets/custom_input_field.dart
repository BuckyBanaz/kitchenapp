import 'package:flutter/material.dart';
import 'package:orderapp/constants/app_strings.dart';

import '../../constants/app_colors.dart';

class CustomInputField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;
  final TextInputAction inputAction;
  final int maxLines;
  final VoidCallback? onDone;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool autofocus;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;

  const CustomInputField({
    super.key,
    this.label,
    this.controller,
    this.currentFocus,
    this.nextFocus,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onDone,
    this.decoration,
    this.style,
    this.autofocus = false,
    this.onChanged,
    this.keyboardType, this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      controller: controller,
      focusNode: currentFocus,
      autofocus: autofocus,
      maxLines: maxLines,
      textInputAction: inputAction,
      keyboardType: keyboardType,
      style: style,
      onSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else {
          FocusScope.of(context).unfocus();
          if (onDone != null) onDone!();
        }
      },
      onChanged: onChanged,
      decoration: decoration ??
          InputDecoration(
            hintText: hintText ?? (label != null ? '${AppStrings.enterYour} ${label!.toLowerCase()}' : null),

            filled: true,
            fillColor: AppColors.primarySwatch.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
    );

    return label != null
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        textField,
      ],
    )
        : textField;
  }
}
