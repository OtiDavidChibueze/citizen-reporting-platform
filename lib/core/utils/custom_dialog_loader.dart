import '../common/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomDialogLoader {
  static bool _isDialogOpen = false;

  static void show(BuildContext context) {
    if (!_isDialogOpen) {
      _isDialogOpen = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return PopScope(
            canPop: false,
            child: Center(
              child: SpinKitCubeGrid(color: AppColors.white, size: 50),
            ),
          );
        },
      ).then((value) => _isDialogOpen = false);
    });
  }

  static void cancel(BuildContext context) {
    if (_isDialogOpen) {
      _isDialogOpen = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  static void isDialogOpenCurrently() => _isDialogOpen;
}
