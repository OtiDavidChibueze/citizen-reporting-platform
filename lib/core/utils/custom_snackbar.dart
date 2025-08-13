import 'package:citizen_report_incident/core/common/theme/app_colors.dart';
import 'package:citizen_report_incident/core/utils/screen_util.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static void error(BuildContext context, String message) {
    _snackbar(context, message, AppColors.error);
  }

  static void success(BuildContext context, String message) {
    _snackbar(context, message, AppColors.successSnackbar);
  }

  static void info(BuildContext context, String message) {
    _snackbar(context, message, AppColors.infoSnackbar);
  }

  static void _snackbar(BuildContext context, String message, Color color) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: color,
            content: Text(
              message,
              style: TextStyle(fontSize: sp(14), color: AppColors.white),
            ),
          ),
        );
    });
  }
}
