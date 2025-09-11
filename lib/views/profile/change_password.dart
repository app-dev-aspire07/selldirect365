import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:truck_market_place/Auth/forget_password.dart';
import 'package:truck_market_place/app_utils/appUtils.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/loading_bar.dart';
import 'package:truck_market_place/widget/route.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPasswords = TextEditingController();

  bool oldObscure = true;
  bool newObscure = true;
  bool confirmObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context, title: "Change Password"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Old Password"),
            SizedBox(height: 8.h),
            _passwordField(
              controller: oldPassword,
              hint: "Enter old password",
              obscure: oldObscure,
              onToggle: () => setState(() => oldObscure = !oldObscure),
              suffix: TextButton(
                onPressed: () {
                  Navigator.of(context,rootNavigator: true).push(createRoute(ForgetPassword())); 
                },
                child: Text(
                  "Forgot?",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            _label("New Password"),
            SizedBox(height: 8.h),
            _passwordField(
              controller: newPassword,
              hint: "Enter new password",
              obscure: newObscure,
              onToggle: () => setState(() => newObscure = !newObscure),
            ),
            SizedBox(height: 20.h),
            _label("Confirm Password"),
            SizedBox(height: 8.h),
            _passwordField(
              controller: confirmPasswords,
              hint: "Confirm new password",
              obscure: confirmObscure,
              onToggle: () => setState(() => confirmObscure = !confirmObscure),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                resetPassword();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 1,
              ),
              child: Center(
                child: Text(
                  "Submit",
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor:AppColors.bottomWhite,
        suffixIcon:
            suffix ??
            IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: onToggle,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }

  String _password = "";
  String errormessage = "";
  resetPassword() async {
    if(oldPassword.text.trim().isEmpty){
      errormessage = "Please enter old password";
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }
    if (passwordValidator(newPassword.text.trim()) != null) {
      errormessage = passwordValidator(newPassword.text.trim())!;
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }

    if (confirmPassword(confirmPasswords.text.trim(), newPassword.text.trim()) != null) {
  errormessage = confirmPassword(
    confirmPasswords.text.trim(),
    newPassword.text.trim(),
  )!;
  AppUtils.showErrorMessage(context, message: errormessage);
  return;
}

    LoadingBar.showLoaderDialog(context, "loading...");
    var repo = await ApiRepository.changePassword(confirmPass: confirmPasswords.text,newPass: newPassword.text ,oldPassword: oldPassword.text );
    if (repo.status == true) {
    Navigator.of(context).pop();
      AppUtils.showSuccessMessage(
        context,
        message: "Password reset successfully",
      );
       Future.delayed(const Duration(milliseconds: 300), () {
    Navigator.of(context).pop();
  });
      
     
    } else {
      Navigator.pop(context);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: repo.message.toString(),
          textStyle: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: AppDimentions.sp16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
