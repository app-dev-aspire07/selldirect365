import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: withoutBackAppBar(context, title: "Sell"),
       body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("No data yet!!", style: GoogleFonts.inter(
            color: AppColors.indicatorColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600
          ),),)
        ],
      ),
    );
  }
}