import 'package:citizen_report_incident/core/common/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomDialogLoader {
  static bool _isDialogOpen = false;

  static void show(BuildContext context) {
    if (!_isDialogOpen) {
      _isDialogOpen = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return PopScope(
                canPop: false,
                child: Center(
                  child: SpinKitCubeGrid(color: AppColors.white, size: 50.0),
                ),
              );
            },
          ).then((_) {
            _isDialogOpen = false;
          });
        }
      });
    }
  }

  static void cancel(BuildContext context) {
    if (_isDialogOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      _isDialogOpen = false;
    }
  }

  static void isDialogCurrentlyOpen() => _isDialogOpen;
}
