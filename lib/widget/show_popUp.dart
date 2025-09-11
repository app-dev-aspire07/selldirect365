// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';

class ShowDialog {
  static Future<void> showLogOut(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              height: AppDimentions.pxh260,
              width: AppDimentions.pxw300,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: AppDimentions.pxh_45, color: AppColors.indicatorColor),
                  SizedBox(height: AppDimentions.pxh_30),
                  Text(
                    "Logout",
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: AppDimentions.sp20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppDimentions.pxh_10),
                  Text(
                    "Are you sure, you want to logout?",
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: AppDimentions.sp14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _popupButton(
                        text: "No",
                        backgroundColor: AppColors.dotColor,
                        textColor: AppColors.white,
                        onTap: () => Navigator.pop(context),
                      ),
                      _popupButton(
                        text: "Yes",
                        backgroundColor: AppColors.primaryColor,
                        textColor: AppColors.white,
                        onTap: () async{
                       await  ApiRepository.logOut();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showConfirmUp(
    BuildContext context, {
    required String? title,
    required Function()? onTap,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              height: AppDimentions.pxh200,
              width: AppDimentions.pxw300,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title ?? '',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.black,
                        fontSize: AppDimentions.sp16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppDimentions.pxh_30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _popupButton(
                          text: "No",
                          backgroundColor: AppColors.dotColor,
                          textColor: AppColors.white,
                          onTap: () => Navigator.pop(context),
                        ),
                        _popupButton(
                          text: "Yes",
                          backgroundColor: AppColors.primaryColor,
                          textColor: AppColors.white,
                          onTap: () {
                            Navigator.pop(context);
                            onTap?.call();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _popupButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimentions.pxh_40,
        width: AppDimentions.pxw94,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: backgroundColor,
        ),
        child: Center(
          child: Text( 
            text,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: AppDimentions.sp14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
