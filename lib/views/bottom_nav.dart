// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/service/controller/other_controller.dart';
import 'package:truck_market_place/views/favourites.dart';
import 'package:truck_market_place/views/home_screen.dart';
import 'package:truck_market_place/views/profile/profile.dart';
import 'package:truck_market_place/views/sell/basic_info.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';

class BottomNav extends StatefulWidget {
  final int currentIndexx;
  int? tabIndex;

  BottomNav({super.key, required this.currentIndexx, this.tabIndex});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndexx;
    _controller = PersistentTabController(initialIndex: currentIndex);
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      Favourites(),
      BasicInfo(),
      // Container(color: AppColors.appBar),
      ProfileScreen(),
    ];
  }

  final HomeController _homeController = Get.put(HomeController());
  final OtherController _otherController = Get.put(OtherController());

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    return [
      PersistentBottomNavBarItem(
        // contentPadding: 8.0,
        inactiveIcon: Container(
          margin: EdgeInsets.only(top: 12.sp),
          height: isTablet ? 22.h : 28.sp,
          width: isTablet ? 22.w : 28.w,
          child: FittedBox(
            fit: BoxFit.cover,
            child: ImageIcon(AssetImage("assets/icons/home.png")),
          ),
        ),
        icon: Container(
          margin: EdgeInsets.only(top: 12.sp),
          height: isTablet ? 20.h : 25.h,
          width: isTablet ? 20.w : 25.w,
          child: FittedBox(
            fit: BoxFit.cover,
            child: ImageIcon(AssetImage("assets/icons/home_filled.png")),
          ),
        ),
        title: "Home",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.hintTxtColor,
      ),
      PersistentBottomNavBarItem(
        // contentPadding: 8.0,
        inactiveIcon: Container(
          margin: EdgeInsets.only(top: 12.sp),
          height: isTablet ? 22.h : 28.sp,
          width: isTablet ? 22.w : 28.w,
          child: FittedBox(
            fit: BoxFit.cover,
            child: ImageIcon(AssetImage("assets/icons/favorite.png")),
          ),
        ),
        icon: Container(
          margin: EdgeInsets.only(top: 12.sp),
          height: isTablet ? 20.h : 25.h,
          width: isTablet ? 20.w : 25.w,
          child: FittedBox(
            fit: BoxFit.cover,
            child: ImageIcon(AssetImage("assets/icons/favorite_filled.png")),
          ),
        ),
        title: "Favorite",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.hintTxtColor,
      ),
      PersistentBottomNavBarItem(
        // contentPadding: 8.0,
        inactiveIcon: Container(
          margin: EdgeInsets.only(top: 12.sp),
          height: isTablet ? 22.h : 28.sp,
          width: isTablet ? 22.w : 28.w,
          child: FittedBox(
            fit: BoxFit.cover,
            child: ImageIcon(AssetImage("assets/icons/sell.png")),
          ),
        ),
        icon: Container(
          margin: EdgeInsets.only(top: 12.sp),
          height: isTablet ? 20.h : 25.h,
          width: isTablet ? 20.w : 25.w,
          child: FittedBox(
            fit: BoxFit.cover,
            child: ImageIcon(AssetImage("assets/icons/sell_filled.png")),
          ),
        ),
        title: "Sell",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.hintTxtColor,
      ),
      PersistentBottomNavBarItem(
        // contentPadding: 8.0,
        inactiveIcon: Container(
          margin: EdgeInsets.only(top: 12.sp),
          height: isTablet ? 22.h : 28.sp,
          width: isTablet ? 22.w : 28.w,
          child: FittedBox(
            fit: BoxFit.cover,
            child: ImageIcon(AssetImage("assets/icons/profile.png")),
          ),
        ),
        icon: Container(
          margin: EdgeInsets.only(top: 12.sp),
          height: isTablet ? 20.h : 25.h,
          width: isTablet ? 20.w : 25.w,
          child: FittedBox(
            fit: BoxFit.cover,
            child: ImageIcon(AssetImage("assets/icons/profile_filled.png")),
          ),
        ),
        title: "Profile",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.hintTxtColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        onItemSelected: (index) async {
          if (index == 2) {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => _buildSellSheet(),
            );
            _controller.index = currentIndex;
          }else if(index == 1){
            _otherController.fetchFavorites();
          }else if(index == 0){
            _homeController.fetchTrucks();
          }else if(index == 3){
            _otherController.fetchMyEquiments();
            _otherController.fetchQuotes();
           _otherController.fetchUserProfile();
          } else {
            setState(() {
              currentIndex = index;
              _controller.index = index;
            });
          }
        },
        backgroundColor: AppColors.white,
        handleAndroidBackButtonPress: false,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0 ? 0.0 : 60.h,
        hideNavigationBarWhenKeyboardAppears: true,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            duration: Duration(milliseconds: 200),
            screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
          ),
        ),
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
        padding: EdgeInsets.only(top: 4, bottom: 8),
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          colorBehindNavBar: Colors.white,
        ),
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }

  Widget _buildSellSheet() {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    return Container(
      padding: EdgeInsets.all(16),
      height: isTablet ? 750.h : 550.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Center(
            child: Image.asset('assets/images/app_logo.png', height: 100.h),
          ),

          _optionCard(
            icon: AssetImage("assets/icons/equipment_info.png"),
            iconColor: AppColors.primaryColor,
            title: "Equipment Information",
            subtitle: "Fill in the specification for your truck or trailer.",
          ),
          SizedBox(height: 12.h),
          _optionCard(
            icon: AssetImage("assets/icons/inspection.png"),
            iconColor: Colors.orange,
            title: "Order on inspection",
            subtitle:
                "Once we have information about your truck or trailer, we will contact you regarding an inspection appointment.",
          ),
          SizedBox(height: 12.h),
          _optionCard(
            icon: AssetImage("assets/icons/listing.png"),
            iconColor: AppColors.splash1,
            title: "List your vechicle",
            subtitle:
                "Once an inspection report is recieved your equipment will be listed for sell",
          ),

          Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // close sheet
                setState(() {
                  currentIndex = 2;
                  _controller.index = 2;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: Text(
                "Continue",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 30.sp),
        ],
      ),
    );
  }

  Widget _optionCard({
    required AssetImage icon,
    required String title,
    required String subtitle,

    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            radius: 24.r,
            child: icon != null
                ? Image(
                    image: icon,
                    color: iconColor,
                    height: 24.h,
                    width: 24.w,
                  )
                : SizedBox.shrink(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.hintTxtColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
