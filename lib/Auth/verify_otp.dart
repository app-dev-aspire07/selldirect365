import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:truck_market_place/Auth/sign_in.dart';
import 'package:truck_market_place/app_utils/appUtils.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/loading_bar.dart';
import 'package:truck_market_place/widget/route.dart';

class VerifyOTP extends StatefulWidget {
  final String? email;
  final String? name;
  final String? password;
  final String? phoneno;

  const VerifyOTP({super.key, this.email, this.name, this.password, this.phoneno});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  String otpCode = "";
  bool status = true;
  final TextEditingController _controller = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = 300; // 5 minutes = 300 seconds

  String get _formattedTime {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String errormessage = "";
  verifyResetOTP(context) async {
    if (_remainingSeconds == 0) {
      AppUtils.showErrorMessage(context, message: "OTP expired. Please request a new one.");
      return;
    }

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
    var response = await ApiRepository.verifyOTP(
      email: widget.email,
      otp: otpCode);

    if (response.status == true) {
      ApiRepository.register(email: widget.email, password: widget.password, name: widget.name, mob_no: widget.phoneno);

      Navigator.pop(context);
      AppUtils.showSuccessMessage(context, message: "Register successfully");
      Navigator.of(context).push(createRoute(SignIn()));
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
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon:  Icon(
                    Icons.arrow_back,
                    color: AppColors.appBar,
                  ),
              ),
              Center(
                child:Image.asset(
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
              SizedBox(height: AppDimentions.pxh_15),

              // Timer Display
              Text(
                _remainingSeconds > 0
                    ? "Code expires in $_formattedTime"
                    : "OTP expired",
                style: GoogleFonts.poppins(
                  color: _remainingSeconds > 0 ? Colors.red : Colors.grey,
                  fontSize: AppDimentions.sp12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimentions.pxh_20),

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
                        keyboardType: TextInputType.number,
                        onChanged: (String code) {
                          otpCode = code;
                        },
                      ),
                      SizedBox(height: AppDimentions.pxh_15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              LoadingBar.showLoaderDialog(
                                context,
                                "loading...",
                              );
                              var repo =
                                  await ApiRepository.sendOTPforRegisteration(
                                emailId: widget.email,
                              );
                              _controller.clear();
                              _remainingSeconds = 300;
                              startTimer(); // restart the timer
                              if (repo.status == true) {
                                Navigator.pop(context);
                                AppUtils.showSuccessMessage(
                                  context,
                                  message: "Code sent successfully",
                                );
                              } else {
                                Navigator.pop(context);
                                AppUtils.showErrorMessage(
                                  context,
                                  message: "Something went wrong.",
                                );
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
                        onTap: 
                             () async => await verifyResetOTP(context),
                            
                        child: Container(
                          height: AppDimentions.pxh_45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: _remainingSeconds > 0
                                ? AppColors.primaryColor
                                : Colors.grey,
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
}
