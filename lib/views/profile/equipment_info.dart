import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/service/controller/other_controller.dart';
import 'package:truck_market_place/views/profile/my_equipment.dart';
import 'package:truck_market_place/views/profile/sent_quote.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';

class EquipmentInfo extends StatefulWidget {
   EquipmentInfo({super.key});

  @override
  State<EquipmentInfo> createState() => _EquipmentInfoState();
}

class _EquipmentInfoState extends State<EquipmentInfo> {
final OtherController _otherController = Get.find();


@override
  void initState() {
    // TODO: implement initState
    super.initState();
      _otherController.fetchQuotes();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Hero(
            tag: "Equipment Info",
            child: Material(
              color: Colors.transparent,
              child: Text(
                "Equipment Info".toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: AppDimentions.sp16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: AppColors.white),
          ),
          backgroundColor: AppColors.appBar, // App bar dark color
          elevation: 0.0,
          toolbarHeight: 40.h,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: Container(
              color: Colors.white, // Tab bar white background
              child: TabBar(
                labelColor: AppColors.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primaryColor,
                labelStyle: GoogleFonts.poppins(
                  fontSize: AppDimentions.sp14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontSize: AppDimentions.sp14,
                  fontWeight: FontWeight.w600,
                ),
                onTap: (index) async{
                  if(index == 0) {
                   await _otherController.fetchQuotes();
                  }else{
                   await _otherController.fetchMyEquiments();
                  }
                },
                tabs: const [
                  Tab(text: 'Sent Quotes'),
                  Tab(text: 'My Equipments'),
                ],
              ),
            ),
          ),
        ),
        body:  TabBarView(
          children: [
            SentQuote(),
            MyEquipments(),
          ],
        ),
      ),
    );
  }
}
