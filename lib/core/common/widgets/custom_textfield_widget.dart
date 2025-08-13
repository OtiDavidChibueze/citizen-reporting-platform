import '../theme/app_colors.dart';
import '../../utils/screen_util.dart';
import 'package:flutter/material.dart';

class CustomTextfieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? suffix;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextfieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffix,
    this.maxLines = 1,
    this.validator,
    this.obscureText = false,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColors.white,
      style: TextStyle(color: AppColors.white, fontSize: sp(16)),
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: w(20),
          vertical: h(12),
        ),
        errorStyle: TextStyle(color: AppColors.error, fontSize: sp(12)),
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.borderColor, fontSize: sp(16)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderColor, width: 1.0),
          borderRadius: BorderRadius.circular(sr(20)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 1.0),
          borderRadius: BorderRadius.circular(sr(20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.white, width: 1.0),
          borderRadius: BorderRadius.circular(sr(20)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 1.0),
          borderRadius: BorderRadius.circular(sr(20)),
        ),
        suffixIcon: suffix,
      ),
      validator: validator,
    );
  }
}
