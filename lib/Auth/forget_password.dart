import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:truck_market_place/Auth/verify_reset_password.dart';
import 'package:truck_market_place/app_utils/appUtils.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/loading_bar.dart';
import 'package:truck_market_place/widget/route.dart';

// ignore: must_be_immutable
class ForgetPassword extends StatelessWidget {
   ForgetPassword({super.key});
  final TextEditingController emailTC = TextEditingController();

  @override
  Widget build(BuildContext context) {
        final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    return Scaffold(
       body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimentions.pxw20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: AppDimentions.pxh70,
              ),
              Center(
                child: Image.asset(
                      "assets/images/app_logo.png",

                      height: isTablet ? 150.h : AppDimentions.pxh132,
                    ),
              ),
              SizedBox(
                height: AppDimentions.pxh_30,
              ),
              Text(
                "Reset your password",
                style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontSize: AppDimentions.sp22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: AppDimentions.pxh_15,
              ),
              Text(
                "Please enter your email. We will send a code to your email to reset your password.",
                style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontSize: AppDimentions.sp14,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppDimentions.pxh_25,
              ),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.border, width: AppDimentions.px_1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                      topLeft: Radius.circular(2),
                      bottomLeft: Radius.circular(25),
                    )),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: AppDimentions.pxh_20,
                      horizontal: AppDimentions.pxw20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: GoogleFonts.inter(
                            color: AppColors.black,
                            fontSize: AppDimentions.sp12,
                            fontWeight: FontWeight.w600),
                      ),
                      TextFormField(
                        controller: emailTC,
                        style: GoogleFonts.inter(
                          color: AppColors.fieldData,
                          fontSize: AppDimentions.sp14,
                        ),
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.inactiveThumbColor, width: 1),
                            ),
                            hintText: "Enter your email",
                            prefixIconConstraints: BoxConstraints(maxHeight: 50),
                            contentPadding: EdgeInsets.only(top: 20),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 10, top: 15),
                              child:Icon(Icons.email_outlined,color: AppColors.indicatorColor,)
                            )),
                      ),
                      SizedBox(
                        height: AppDimentions.pxh_32,
                      ),
                      InkWell(
                        onTap: () async {
                          await sendCode(context);
                          // Navigator.of(context)
                          //     .push(createRoute( VerifyResetPassword()));
                        },
                        child: Container(
                          height: AppDimentions.pxh_45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppColors.primaryColor),
                          child: Center(
                            child: Text(
                              "Send my code",
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
              )
            ],
          ),
        ),
      ),
    
    );
  }
  String errormessage = "";
  sendCode(context) async {
    if (emailValidator(
          emailTC.text.trim(),
        ) !=
        null) {
      errormessage = emailValidator(emailTC.text.trim())!;
      AppUtils.showErrorMessage(context, message: errormessage);
      return;
    }
    LoadingBar.showLoaderDialog(context, "loading...");
    var respo = await ApiRepository.forgotPassword(emailId: emailTC.text);
    if (respo.status == true) {
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          createRoute(VerifyResetPassword(
            email: emailTC.text,
          )),
          (route) => false);
    } else {
      Navigator.pop(context);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: respo.message.toString(),
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