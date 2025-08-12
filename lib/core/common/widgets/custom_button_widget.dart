import 'package:citizen_report_incident/core/common/theme/app_colors.dart';
import 'package:citizen_report_incident/core/utils/screen_util.dart';
import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double horizontal;
  final double vertical;

  const CustomButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.error,
    this.horizontal = 0,
    this.vertical = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(sr(20))),
        ),
        elevation: WidgetStatePropertyAll(0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.white,
          fontSize: sp(16),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
