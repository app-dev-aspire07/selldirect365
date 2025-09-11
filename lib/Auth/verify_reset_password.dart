import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:truck_market_place/Auth/create_password.dart';
import 'package:truck_market_place/app_utils/appUtils.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/loading_bar.dart';
import 'package:truck_market_place/widget/route.dart';

// ignore: must_be_immutable
class VerifyResetPassword extends StatelessWidget {
  final String? email;
  VerifyResetPassword({super.key, this.email});
  String otpCode = "";
  bool status = true;
  final TextEditingController _controller = TextEditingController();
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
                "Verify OTP",
                style: GoogleFonts.poppins(
                  color: AppColors.black,
                  fontSize: AppDimentions.sp22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimentions.pxh_15),
              Text(
                "Please enter the verification code sent to your email",
                style: GoogleFonts.poppins(
                  color: AppColors.black,
                  fontSize: AppDimentions.sp14,
                  fontWeight: FontWeight.w500,
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
                    horizontal: AppDimentions.pxw10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Code",
                        style: GoogleFonts.poppins(
                          color: AppColors.black,
                          fontSize: AppDimentions.sp12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      PinCodeTextField(
                        controller: _controller,
                        appContext: context,
                        length: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d]')),
                        ],
                        autoFocus: true,
                        cursorColor: AppColors.appBar,
                        enablePinAutofill: false,
                        keyboardType: TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false,
                        ),
                        onChanged: (String code) {
                          otpCode = code;
                        },
                      ),
                      // OtpTextField(
                      //   numberOfFields: 6,
                      //   clearText: true,
                      //   // autoFocus: true,
                      //   cursorColor: AppColors.appBar,
                      //   enabledBorderColor: AppColors.appBar,
                      //   focusedBorderColor: AppColors.appBar,
                      //   borderColor: AppColors.indicatorColor,

                      //   //set to true to show as box or false to show as dash
                      //   showFieldAsBox: false,
                      //   //runs when a code is typed in
                      //   onCodeChanged: (String code) {
                      //     //handle validation or checks here
                      //   },
                      //   onSubmit: (String verificationCode) {
                      //     otpCode = verificationCode;
                      //     print("SubmittedCOde " + otpCode);
                      //   },
                      // ),
                      SizedBox(height: AppDimentions.pxh_15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              LoadingBar.showLoaderDialog(context, "");
                              var repo = await ApiRepository.forgotPassword(emailId: email);
                              if (repo.status == true) {
                                Navigator.pop(context);
                                AppUtils.showSuccessMessage(context,
                                    message: "Code sent successfully");
                              } else {
                                Navigator.pop(context);
                                AppUtils.showErrorMessage(context,
                                    message: repo.message.toString());
                              }
                            },
                            child: Text(
                              "Resend your code",
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryColor,
                                fontSize: AppDimentions.sp12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimentions.pxh_25),
                      InkWell(
                        onTap: () async {
                          await verifyResetOTP(context);
                          Navigator.of(
                            context,
                          ).push(createRoute(CreatePassword(emailId: email)));
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

  String errormessage = "";
  verifyResetOTP(context) async {
    if (emptyTextFieldCheck(otpCode.trim(), "Please enter OTP") != null) {
      errormessage = "Please enter OTP";
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }
    if (otpCode.trim().length < 6) {
      errormessage = "Otp field must not be empty";
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }
    LoadingBar.showLoaderDialog(context, "loading....");
    var response =
        await ApiRepository.verifyForgetOTP(otp: otpCode);

    if (response.status == true) {
      Navigator.pop(context);
      Navigator.of(context).push(createRoute(CreatePassword(
        emailId: email,
      )));
    } else {
      Navigator.pop(context);
      _controller.clear();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: response.message.toString(),
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
