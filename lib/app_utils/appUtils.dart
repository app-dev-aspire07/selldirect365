
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:truck_market_place/app_utils/constants.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';

class AppUtils {
  static void requestNewNode(
      {required FocusNode newFocus,
      required FocusNode prevFocus,
      required BuildContext context}) {
    prevFocus.unfocus();
// // newFocus.requestFocus();
    FocusScope.of(context).requestFocus(newFocus);
  }

  static void showErrorMessage(
    context, {
    required String message,
  }) {
    showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: message,
          iconRotationAngle: 0,
          icon: Container(),
          textStyle: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: AppDimentions.sp16,
            fontWeight: FontWeight.w600,
          ),
        ),
        displayDuration: Duration(milliseconds: 800));
  }

  static void showSuccessMessage(
    context, {
    required String message,
  }) {
    showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: message,
          iconRotationAngle: 0,
          icon: Container(),
          textStyle: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: AppDimentions.sp16,
            fontWeight: FontWeight.w600,
          ),
        ),
        displayDuration: Duration(milliseconds: 800));
  }
}

// Validation Function>>>>>>>>>>>>>>

String? passwordValidator(value) {
  return value.isEmpty
      ? Constants.errorPassword
      : value.length < 8
          ? "The password must be 8  to 32 characters long."
          // : !validateStructure(value)
          //     ? "The password must contain a mix of letters, numbers, \nand/or special characters.."
          : null;
}

// String? confirmPassword(String value, String pass, String message ) {
//   if (pass == null || (pass != null && pass.length == 0)) {
//     return "Confirm password do not match with new password";
//   } else if ((pass != null && pass.length != value.length)) {
//     return "Confirm password do not match with new password";
//   }
//   return value.isEmpty ? message : null;
// }
String? confirmPassword(
  String value,
  String pass,
) {
  if (value != pass) {
    return "Confirm password do not match with new password";
  }
  return value.isEmpty
      ? Constants.errorPassword
      : value.length < 8
          ? "The password must be 8  to 32 characters long."
          // : !validateStructure(value)
          //     ? "The password must contain a mix of letters, numbers, \nand/or special characters.."
          : null;
}

String? phoneValidator(String value) {
  if (value.isEmpty) {
    return Constants.enterPhone;
  } else if (value.length < 12 || value.length > 14) {
    return 'Number must be 10 digit';
  } else {
    return null;
  }
}

String? intEmpty(String value) {
  if (value.isEmpty) {
    return 'Please proceed atleast one cart';
  } else {
    return null;
  }
}

String? checkAmountTextFieldCheck(value, String message) {
  if (!isNumeric(value)) {
    return "Please enter valid amount.";
  } else {
    return null;
  }
}

bool isNumeric(String value) {
  // ignore: unnecessary_null_comparison
  if (value == null || value.isEmpty) {
    return false;
  }
  try {
    double.parse(value).toStringAsFixed(2);
    return true;
  } catch (e) {
    return false;
  }
}

bool validateStructure(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

String? userNameValidator(value) {
  return value.isEmpty ? Constants.emptyUsername : null;
}

String? emptyTextFieldCheck(value, String message) {
  return value.isEmpty ? message : null;
}

String? emailValidator(String value) {
  if (value.isEmpty) {
    return Constants.enterEmail;
  } else if (!value.isValidEmail()) {
    return Constants.errorEmail;
  } else {
    return null;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
