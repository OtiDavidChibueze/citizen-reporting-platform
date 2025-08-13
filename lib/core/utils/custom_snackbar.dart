import '../common/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static void success(BuildContext context, String message) {
    _snackBar(context, message, AppColors.successSnackbar);
  }

  static void error(BuildContext context, String message) {
    _snackBar(context, message, AppColors.error);
  }

  static void info(BuildContext context, String message) {
    _snackBar(context, message, AppColors.infoSnackbar);
  }

  static _snackBar(BuildContext context, String message, Color color) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
    });
  }
}
