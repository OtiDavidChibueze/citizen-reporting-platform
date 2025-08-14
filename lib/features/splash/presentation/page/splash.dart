import '../../../../core/common/theme/app_colors.dart';
import '../../../../core/constants/app_image_urls.dart';
import '../../../../core/utils/screen_util.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  static const routeName = 'splash';

  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Center(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: AppColors.white, blurRadius: 30),
                BoxShadow(color: AppColors.white, blurRadius: 15),
              ],
            ),
            child: Image.asset(
              AppImageUrls.logo,
              fit: BoxFit.cover,
              height: h(200),
            ),
          ),
        ),
      ),
    );
  }
}
