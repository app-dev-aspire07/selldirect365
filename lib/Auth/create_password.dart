import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:truck_market_place/Auth/sign_in.dart';
import 'package:truck_market_place/app_utils/appUtils.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/loading_bar.dart';
import 'package:truck_market_place/widget/route.dart';

// ignore: must_be_immutable
class CreatePassword extends StatefulWidget {
  String? emailId;
  CreatePassword({super.key, this.emailId});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final TextEditingController passTc = TextEditingController();
  final TextEditingController confirmPassTc = TextEditingController();

  final FocusNode _passwordFN = FocusNode();
  final FocusNode _confirmPassFN = FocusNode();
  bool _obscureText = true;
  bool _obscureTextR = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      // _obscureTextR = !_obscureTextR;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureTextR = !_obscureTextR;
    });
  }

  @override
  Widget build(BuildContext context) {
       final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimentions.pxw20),
          child: Column(
            children: [
              SizedBox(height: AppDimentions.pxh70),
              Center(
                child: Image.asset(
                      "assets/images/app_logo.png",

                      height: isTablet ? 150.h : AppDimentions.pxh132,
                    ),
              ),
              SizedBox(height: AppDimentions.pxh_30),
              Text(
                "Create new password",
                style: GoogleFonts.poppins(
                  color: AppColors.black,
                  fontSize: AppDimentions.sp22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimentions.pxh_15),
              Text(
                "Please set a new and strong password",
                style: GoogleFonts.poppins(
                  color: AppColors.black,
                  fontSize: AppDimentions.sp14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimentions.pxh_25),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.border,
                    width: AppDimentions.px_1,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    topLeft: Radius.circular(2),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimentions.pxh_20,
                    horizontal: AppDimentions.pxw20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: GoogleFonts.poppins(
                          color: AppColors.black,
                          fontSize: AppDimentions.sp12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        controller: passTc,
                        style: GoogleFonts.poppins(
                          color: AppColors.fieldData,
                          fontSize: AppDimentions.sp14,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[ ]')),
                        ],
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.inactiveThumbColor,
                              width: 1,
                            ),
                          ),
                          hintText: "Enter Password",
                          prefixIconConstraints: BoxConstraints(maxHeight: 50),
                          contentPadding: EdgeInsets.only(top: 20),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(right: 10, top: 15),
                            child: Icon(
                              Icons.key_sharp,
                              color: AppColors.indicatorColor,
                            ),
                          ),
                          suffixIconConstraints: BoxConstraints(maxHeight: 50),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 10, top: 15),
                            child: InkWell(
                              onTap: () {
                                _toggle();
                              },
                              child: _obscureText
                                  ? Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: AppColors.indicatorColor,
                                    )
                                  : Icon(
                                      Icons.remove_red_eye,
                                      color: AppColors.indicatorColor,
                                    ),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        onFieldSubmitted: (value) {
                          AppUtils.requestNewNode(
                            newFocus: _confirmPassFN,
                            prevFocus: _passwordFN,
                            context: context,
                          );
                        },
                        onChanged: (value) => _password = value,
                      ),
                      SizedBox(height: AppDimentions.pxh_22),
                      Text(
                        "Retype your password",
                        style: GoogleFonts.poppins(
                          color: AppColors.black,
                          fontSize: AppDimentions.sp12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        controller: confirmPassTc,
                        style: GoogleFonts.poppins(
                          color: AppColors.fieldData,
                          fontSize: AppDimentions.sp14,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[ ]')),
                        ],
                        obscureText: _obscureTextR,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.inactiveThumbColor,
                              width: 1,
                            ),
                          ),
                          hintText: "Retype your password",
                          prefixIconConstraints: BoxConstraints(maxHeight: 50),
                          contentPadding: EdgeInsets.only(top: 20),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(right: 10, top: 15),
                            child: Icon(
                              Icons.key_sharp,
                              color: AppColors.indicatorColor,
                            ),
                          ),
                          suffixIconConstraints: BoxConstraints(maxHeight: 50),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 10, top: 15),
                            child: InkWell(
                              onTap: () {
                                _toggle2();
                              },
                              child: _obscureTextR
                                  ? Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: AppColors.indicatorColor,
                                    )
                                  : Icon(
                                      Icons.remove_red_eye,
                                      color: AppColors.indicatorColor,
                                    ),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: AppDimentions.pxh_32),
                      InkWell(
                        onTap: () async {
                          await resetPassword();
                          Navigator.of(context).push(createRoute(SignIn()));
                        },
                        child: Container(
                          height: AppDimentions.pxh_45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: AppColors.primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              "Confirm",
                              style: GoogleFonts.poppins(
                                color: AppColors.white,
                                fontSize: AppDimentions.sp14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_field
  String _password = "";

  String errormessage = "";
  resetPassword() async {
    if (passwordValidator(passTc.text.trim()) != null) {
      errormessage = passwordValidator(passTc.text.trim())!;
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }

    if (confirmPassword(
          confirmPassTc.text.trim(),
          _password,
        ) !=
        null) {
      errormessage = confirmPassword(
        confirmPassTc.text.trim(),
        "_password",
      )!;
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }

    LoadingBar.showLoaderDialog(context, "loading...");
    var repo = await ApiRepository.resetPassword(
        password: passTc.text);
    if (repo.status == true) {
      Navigator.pop(context);
      AppUtils.showSuccessMessage(context,
          message: "Password reset successfully");
      Navigator.of(context).push(createRoute(SignIn()));
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
