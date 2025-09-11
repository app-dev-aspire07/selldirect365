import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:truck_market_place/Auth/forget_password.dart';
import 'package:truck_market_place/app_utils/appUtils.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/bottom_nav.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/loading_bar.dart';
import 'package:truck_market_place/widget/route.dart';

import 'sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late TapGestureRecognizer _tapRecognizer;
  final TextEditingController emailTC = TextEditingController();
  final TextEditingController passTC = TextEditingController();

  final FocusNode _eMailFN = FocusNode();
  final FocusNode _passwordFN = FocusNode();
  bool _obsecureText = true;

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).push(createRoute(const SignUp()));
      };
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
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
                  // SizedBox(height: AppDimentions.pxh_30),
                  Text(
                    "Log in",
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: isTablet ? 18.sp : AppDimentions.sp22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppDimentions.pxh_15),
                  Text(
                    "Welcome back!",
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: isTablet ? 12.sp : AppDimentions.sp14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account?',
                      style: GoogleFonts.inter(
                        color: AppColors.black,
                        fontSize: isTablet ? 12.sp : AppDimentions.sp14,
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Sign up',
                          style: GoogleFonts.inter(
                            color: AppColors.primaryColor,
                            fontSize: isTablet ? 12.sp : AppDimentions.sp14,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: _tapRecognizer,
                        ),
                      ],
                    ),
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
                            "Email",
                            style: GoogleFonts.inter(
                              color: AppColors.black,
                              fontSize: AppDimentions.sp12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextFormField(
                            controller: emailTC,
                            style: GoogleFonts.inter(
                              color: AppColors.fieldData,
                              fontSize: isTablet ? 12.sp : AppDimentions.sp14,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.inactiveThumbColor,
                                  width: 1,
                                ),
                              ),
                              hintText: "Enter your email",
                              prefixIconConstraints: BoxConstraints(
                                maxHeight: 50,
                              ),
                              contentPadding: EdgeInsets.only(top: 20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 10, top: 15),
                                child: Icon(
                                  Icons.email_outlined,
                                  color: AppColors.indicatorColor,
                                  size: isTablet ? 16.sp : 20.sp,
                                ),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              AppUtils.requestNewNode(
                                newFocus: _passwordFN,
                                prevFocus: _eMailFN,
                                context: context,
                              );
                            },
                          ),
                          SizedBox(height: AppDimentions.pxh_22),
                          Text(
                            "Password",
                            style: GoogleFonts.inter(
                              color: AppColors.black,
                              fontSize: AppDimentions.sp12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextFormField(
                            obscureText: _obsecureText,
                            controller: passTC,
                            style: GoogleFonts.inter(
                              color: AppColors.fieldData,
                              fontSize: isTablet ? 12.sp : AppDimentions.sp14,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp('[ ]')),
                            ],
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.inactiveThumbColor,
                                  width: 1,
                                ),
                              ),
                              hintText: "Enter your password",
                              prefixIconConstraints: BoxConstraints(
                                maxHeight: 50,
                              ),
                              contentPadding: EdgeInsets.only(top: 20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 10, top: 15),
                                child: Icon(
                                  Icons.key_sharp,
                                  color: AppColors.indicatorColor,
                                  size: isTablet ? 16.sp : 20.sp,
                                ),
                              ),

                              suffixIconConstraints: BoxConstraints(
                                maxHeight: 50,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 10, top: 15),
                                child: InkWell(
                                  onTap: () {
                                    _toggle();
                                  },
                                  child: _obsecureText
                                      ? Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: AppColors.indicatorColor,
                                          size: isTablet ? 14.sp : 18.sp,
                                        )
                                      : Icon(
                                          Icons.remove_red_eye,
                                          color: AppColors.indicatorColor,
                                          size: isTablet ? 16.sp : 20.sp,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppDimentions.pxh_10),
                          InkWell(
                            onTap: () {
                              Navigator.of(
                                context,
                              ).push(createRoute(ForgetPassword()));
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot you password?",
                                style: GoogleFonts.inter(
                                  color: AppColors.primaryColor,
                                  fontSize: isTablet
                                      ? 10.sp
                                      : AppDimentions.sp12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppDimentions.pxh_25),
                          InkWell(
                            onTap: () async {
                              signInClick();
                            },
                            child: Container(
                              height: AppDimentions.pxh_45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: AppColors.primaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  "Confirm".toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    color: AppColors.white,
                                    fontSize: AppDimentions.sp14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
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
          ],
        ),
      ),
    );
  }

  String errormessage = "";
  signInClick() async {
    if (emailValidator(emailTC.text.trim()) != null) {
      errormessage = emailValidator(emailTC.text.trim())!;
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }
    if (passwordValidator(passTC.text.trim()) != null) {
      errormessage = passwordValidator(passTC.text.trim())!;
      AppUtils.showErrorMessage(context, message: "Password is incorrect");
      return;
    }
    LoadingBar.showLoaderDialog(context, "loading....");
    var repo = await ApiRepository.loginRequest(
      context: context,
      data: {"email": emailTC.text, "password": passTC.text},
    );

    if (repo.status == true) {
      Navigator.pop(context);

      // HomeController ko reset karo
      if (Get.isRegistered<HomeController>()) {
        Get.delete<HomeController>();
      }

      await Navigator.of(context).pushAndRemoveUntil(
        createRoute(BottomNav(currentIndexx: 0)),
        (route) => true,
      );
    } else {
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
