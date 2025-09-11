// ignore_for_file: unused_field

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:truck_market_place/Auth/sign_in.dart';
import 'package:truck_market_place/Auth/verify_otp.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/loading_bar.dart';
import 'package:truck_market_place/widget/route.dart';

import '../app_utils/appUtils.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TapGestureRecognizer _tapRecognizer;

  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _obscureTextR = true;
  String _password = "";

  final TextEditingController nameTc = TextEditingController();
  final TextEditingController emailTc = TextEditingController();
  final TextEditingController phNumberTc = TextEditingController();
  final TextEditingController passwordTc = TextEditingController();
  final TextEditingController confirmPasswordTc = TextEditingController();

  final FocusNode _fullNameFN = FocusNode();
  final FocusNode _eMailFN = FocusNode();
  final FocusNode _passwordFN = FocusNode();
  final FocusNode _confirmPassFN = FocusNode();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureTextR = !_obscureTextR;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.initState();
    _tapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).push(createRoute(const SignIn()));
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
              padding: EdgeInsets.symmetric(
                horizontal: AppDimentions.pxw20,
                vertical: AppDimentions.pxh_20,
              ),
              child: Column(
                children: [
                  SizedBox(height: AppDimentions.pxh_30),
                  Center(
                    child: Image.asset(
                      "assets/images/app_logo.png",

                      height: isTablet ? 150.h : AppDimentions.pxh132,
                    ),
                  ),

                  // SizedBox(height: AppDimentions.pxh_30),
                  Text(
                    "Register",
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: AppDimentions.sp22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppDimentions.pxh_15),

                  Text.rich(
                    TextSpan(
                      text:
                          'Please enter your details to sign up and create an account.',
                      style: GoogleFonts.inter(
                        color: AppColors.black,
                        fontSize: AppDimentions.sp14,
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Sign In',
                          style: GoogleFonts.inter(
                            color: AppColors.primaryColor,
                            fontSize: AppDimentions.sp14,
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
                            "Your Name",
                            style: GoogleFonts.inter(
                              color: AppColors.black,
                              fontSize: AppDimentions.sp12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextFormField(
                            controller: nameTc,
                            style: GoogleFonts.inter(
                              color: AppColors.fieldData,
                              fontSize: AppDimentions.sp14,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.inactiveThumbColor,
                                  width: 1,
                                ),
                              ),
                              hintText: "Enter your full name",
                              prefixIconConstraints: BoxConstraints(
                                maxHeight: 50,
                              ),
                              contentPadding: EdgeInsets.only(top: 20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 10, top: 15),
                                child: Icon(
                                  Icons.person_2_outlined,
                                  color: AppColors.indicatorColor,
                                ),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              AppUtils.requestNewNode(
                                newFocus: _eMailFN,
                                prevFocus: _fullNameFN,
                                context: context,
                              );
                            },
                          ),
                          SizedBox(height: AppDimentions.pxh_22),
                          Text(
                            "Email",
                            style: GoogleFonts.inter(
                              color: AppColors.black,
                              fontSize: AppDimentions.sp12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextFormField(
                            controller: emailTc,
                            style: GoogleFonts.inter(
                              color: AppColors.fieldData,
                              fontSize: AppDimentions.sp14,
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
                            "Phone Number",
                            style: GoogleFonts.inter(
                              color: AppColors.black,
                              fontSize: AppDimentions.sp12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextFormField(
                            controller: phNumberTc,
                            style: GoogleFonts.inter(
                              color: AppColors.fieldData,
                              fontSize: AppDimentions.sp14,
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              PhoneInputFormatter(
                                allowEndlessPhone: false,
                                defaultCountryCode: 'US',
                              ),
                            ],
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.inactiveThumbColor,
                                  width: 1,
                                ),
                              ),
                              hintText: "+1 (123) 456-7890",
                              prefixIconConstraints: BoxConstraints(
                                maxHeight: 50,
                              ),
                              contentPadding: EdgeInsets.only(top: 20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 10, top: 15),
                                child: Icon(
                                  Icons.phone_android,
                                  color: AppColors.indicatorColor,
                                ),
                              ),
                            ),
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
                            obscureText: _obscureText,
                            controller: passwordTc,
                            style: GoogleFonts.inter(
                              color: AppColors.fieldData,
                              fontSize: AppDimentions.sp14,
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
                          ),
                          SizedBox(height: AppDimentions.pxh_20),
                          Text(
                            "Retype your password",
                            style: GoogleFonts.inter(
                              color: AppColors.black,
                              fontSize: AppDimentions.sp12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp('[ ]')),
                            ],
                            obscureText: _obscureTextR,
                            controller: confirmPasswordTc,
                            style: GoogleFonts.inter(
                              color: AppColors.fieldData,
                              fontSize: AppDimentions.sp14,
                            ),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.inactiveThumbColor,
                                  width: 1,
                                ),
                              ),
                              hintText: "Retype your password",
                              prefixIconConstraints: BoxConstraints(
                                maxHeight: 50,
                              ),
                              contentPadding: EdgeInsets.only(top: 20),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 10, top: 15),
                                child: Icon(
                                  Icons.key_sharp,
                                  color: AppColors.indicatorColor,
                                ),
                              ),
                              suffixIconConstraints: BoxConstraints(
                                maxHeight: 50,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 10, top: 15),
                                child: InkWell(
                                  onTap: (() {
                                    _toggle2();
                                  }),
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

                          SizedBox(height: AppDimentions.pxh_25),
                          InkWell(
                            onTap: () async {
                              signUpClick();
                            },
                            child: Container(
                              height: AppDimentions.pxh_45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: AppColors.primaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  "Sign up",
                                  style: GoogleFonts.inter(
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
          ],
        ),
      ),
    );
  }

  String errormessage = "";
  signUpClick() async {
    if (emptyTextFieldCheck(nameTc.text.trim(), "Please enter your name") !=
        null) {
      errormessage = "Please enter name";
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }
    if (emailValidator(emailTc.text.trim()) != null) {
      errormessage = emailValidator(emailTc.text.trim())!;
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }
    if (phoneValidator(phNumberTc.text.trim()) != null) {
      errormessage = phoneValidator(phNumberTc.text.trim())!;
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }
    if (passwordValidator(passwordTc.text.trim()) != null) {
      errormessage = passwordValidator(passwordTc.text.trim())!;
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }

    _password = passwordTc.text.trim();

    if (confirmPassword(confirmPasswordTc.text.trim(), _password) != null) {
      errormessage = confirmPassword(confirmPasswordTc.text.trim(), _password)!;
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }

    LoadingBar.showLoaderDialog(context, "loading....");
    var response = await ApiRepository.sendOTPforRegisteration(
      emailId: emailTc.text,
    );

    if (response.status == true) {
      Navigator.pop(context);
      await Navigator.of(context).push(
        createRoute(
          VerifyOTP(
            name: nameTc.text,
            password: passwordTc.text,
            phoneno: toNumericString(phNumberTc.text, allowHyphen: false),
            email: emailTc.text,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "Something went wrong. Please try again!!",
          textStyle: GoogleFonts.inter(
            color: AppColors.white,
            fontSize: AppDimentions.sp16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
