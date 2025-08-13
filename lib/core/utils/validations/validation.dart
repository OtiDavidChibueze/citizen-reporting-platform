import '../../constants/app_string.dart';

class Validation {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return AppString.required;

    final pattern = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!pattern.hasMatch(value)) return AppString.emailValidation;
    return null;
  }

  static String? password(val) {
    if (val == null || val.isEmpty) return AppString.required;

    final int minInput = 6;
    final int maxInput = 20;

    if (val.length < minInput || val.length > maxInput) {
      return AppString.passwordValidation;
    }
    return null;
  }
}
