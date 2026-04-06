import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

Widget mainTextField({
  required BuildContext context,
  required TextEditingController controller,
  required TextStyle style,
  String? labelText,
  String? hintText,
  String? errorText,
  Widget? prefixIcon,
  bool? obscureText,
  double? radius,
  bool? isInputError,
  VoidCallback? onSuffixIconPressed,
  void Function(String value)? onSubmitted,
  void Function(String value)? onChanged,
  void Function()? onEditingComplete,
  FocusNode? focusNode,
}) {
  double currentRadius = radius ?? 12;
  return TextField(
    style: style,
    controller: controller,
    obscureText: obscureText ?? false,
    onSubmitted: (value) {
      FocusScope.of(context).unfocus();
      onSubmitted?.call(value);
    },
    onChanged: (value) {
      onChanged?.call(value);
    },
    focusNode: focusNode,
    decoration: InputDecoration(
      labelStyle: style,
      hintStyle: style,
      prefixIconColor: context.color.dimPurple,
      labelText: labelText,
      hintText: hintText,
      errorText: (errorText?.isEmpty ?? true) ? null : errorText,
      errorStyle: context.theme.textTheme.bodySmall!.modify(
        color: context.color.red,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: obscureText != null
          ? IconButton(
              color: context.color.dimPurple,
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: onSuffixIconPressed,
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(currentRadius),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(currentRadius),
        borderSide: (isInputError ?? false)
            ? BorderSide(color: context.color.red, width: 2)
            : BorderSide(color: context.color.gray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(currentRadius),
        borderSide: (isInputError ?? false)
            ? BorderSide(color: context.color.red, width: 2)
            : BorderSide(color: Colors.white),
      ),
    ),
  );
}
