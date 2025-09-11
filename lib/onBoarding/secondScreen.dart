
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';

class ScreenSecond extends StatefulWidget {
  const ScreenSecond({super.key});

  @override
  State<ScreenSecond> createState() => _ScreenSecondState();
}

class _ScreenSecondState extends State<ScreenSecond> {
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
                    'assets/images/onboard2.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppDimentions.pxh36,
            ),
            Text(
              'Sell with Confidence',
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
                'List your truck in a few taps. Reach thousands of serious buyers.',
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
