
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';

AppBar mainAppBar(BuildContext context,
        {@required String? title,
        List<Widget>? actions,
        Widget? leading,
        bool automaticallyImplyLeading = true}) =>
    AppBar(
      title: Hero(
        tag: title!,
        child: Material(
          color: Colors.transparent,
          child: Text(
            title.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: AppDimentions.sp16,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: AppColors.white,)),
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: AppColors.appBar,
      elevation: 0.0,
      toolbarHeight: 40.h,
      // shadowColor: Colors.black12,
      centerTitle: true,
      // iconTheme: const IconThemeData(color: AppColors.black),

      actions: actions,
    );

AppBar withoutBackAppBar(BuildContext context,
        {@required String? title,
        List<Widget>? actions,
        Widget? leading,
        bool automaticallyImplyLeading = true}) =>
    AppBar(
      title: Hero(
        tag: title!,
        child: Material(
          color: Colors.transparent,
          child: Text(
            title.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: AppDimentions.sp16,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
      
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: AppColors.appBar,
      elevation: 0.0,
      toolbarHeight: 40.h,
      centerTitle: true,
      actions: actions,
    );
