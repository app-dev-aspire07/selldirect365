
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';

class ScreenFirst extends StatefulWidget {
  const ScreenFirst({super.key});

  @override
  State<ScreenFirst> createState() => _ScreenFirstState();
}

class _ScreenFirstState extends State<ScreenFirst> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                // top: AppDimentions.pxh60,
              ),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimentions.pxw20),
                  child: Image.asset(
                    'assets/images/onboard1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppDimentions.pxh36,
            ),
            Text(
              'Explore Inventory',
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
                'Browse hundreds of commercial, trailer, and pickup trucks – ready to roll',
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
