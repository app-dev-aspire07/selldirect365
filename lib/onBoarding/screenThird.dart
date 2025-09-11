// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';

class ScreenThird extends StatefulWidget {
  const ScreenThird({super.key});

  @override
  State<ScreenThird> createState() => _ScreenThirdState();
}

class _ScreenThirdState extends State<ScreenThird> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: AppDimentions.pxh_50,
              ),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimentions.pxw20),
                  child: Image.asset(
                    'assets/images/onboard3.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppDimentions.pxh36,
            ),
            Text(
              'Secure & Easy Deals',
              style: GoogleFonts.poppins(
                  color: AppColors.black,
                  fontSize: AppDimentions.sp22,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: AppDimentions.pxh_20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.0),
              child: Text(
                'Hassle-Free Transactions\nChat, negotiate, and close deals securely within the app.',
                style: GoogleFonts.poppins(
                    color: AppColors.black,
                    fontSize: AppDimentions.sp16,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: AppDimentions.pxh150,
            ),
          ],
        ),
      ),
    );
  }
}
