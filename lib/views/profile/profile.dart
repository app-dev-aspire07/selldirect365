import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/service/api_url.dart';
import 'package:truck_market_place/service/controller/other_controller.dart';
import 'package:truck_market_place/views/profile/contact_us_screen.dart';
import 'package:truck_market_place/views/profile/edit_profile.dart';
import 'package:truck_market_place/views/profile/equipment_info.dart';
import 'package:truck_market_place/views/profile/help_center.dart';
import 'package:truck_market_place/views/profile/setting.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/show_popUp.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/equipmentInfo":
            return MaterialPageRoute(builder: (_) => EquipmentInfo());
          case "/editProfile":
            return MaterialPageRoute(builder: (_) => EditProfile());
          case "/helpCenter":
            return MaterialPageRoute(builder: (_) => HelpCenter());
          case "/settings":
            return MaterialPageRoute(builder: (_) => SettingsScreen());
            case "/contactUs":
            return MaterialPageRoute(builder: (_) => ContactUsScreen());
          default:
            return MaterialPageRoute(builder: (_) => _ProfileHome());
        }
      },
    );
  }
}

class _ProfileHome extends StatelessWidget {
  _ProfileHome();

  final OtherController _otherController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Color randomColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];

    return Scaffold(
      appBar: withoutBackAppBar(context, title: "Account"),
      body: Obx(() {
        if (_otherController.isProfile.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_otherController.userProfile.value == null) {
          return Center(
            child: Text(
              _otherController.errorMessage.value.isNotEmpty
                  ? _otherController.errorMessage.value
                  : "No profile data available",
              style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey),
            ),
          );
        }

        final profile = _otherController.userProfile.value!;
        String name = profile.name ?? "N/A";
        String email = profile.email ?? "N/A";
        String mobile = profile.mobileNumber ?? "N/A";
        String? profileImageUrl = profile.userImage;

        String initials = name.isNotEmpty
            ? "${name.split(" ").first[0]}${name.split(" ").length > 1 ? name.split(" ").last[0] : ''}"
                  .toUpperCase()
            : "";

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Center(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor:
                          (profileImageUrl == null || profileImageUrl.isEmpty)
                          ? randomColor
                          : Colors.transparent,
                      backgroundImage:
                          profileImageUrl != null && profileImageUrl.isNotEmpty
                          ? NetworkImage(
                              ApiEndPoints.imgUrl + profileImageUrl.toString(),
                            )
                          : null,
                      child:
                          (profileImageUrl == null || profileImageUrl.isEmpty)
                          ? Text(
                              initials,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          email,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.hintTxtColor,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).pushNamed("/editProfile"),
                          child: Text(
                            "Edit Account",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.indicatorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              /// Email + Mobile Show
              // Text(
              //   "Email: $email",
              //   style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.black87),
              // ),
              // SizedBox(height: 6.h),
              // Text(
              //   "Mobile: $mobile",
              //   style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.black87),
              // ),
              // SizedBox(height: 20.h),
              Divider(thickness: 0.5, color: AppColors.hintTxtColor),
              SizedBox(height: 8.h),

              /// Profile Options
              _profileTile(
                icon: const AssetImage("assets/icons/equipment.png"),
                title: "Equipment Info",
                subtitle: "Sent quote, My equipment",
                onTap: () => Navigator.of(context).pushNamed("/equipmentInfo"),
              ),
              _profileTile(
                icon: const AssetImage("assets/icons/help.png"),
                title: "Help Center",
                subtitle: "FAQ’s, Contact support",
                onTap: () => Navigator.of(context).pushNamed("/helpCenter"),
              ),
              _profileTile(
                icon: const AssetImage("assets/icons/contact_us.png"),
                title: "Contact Us",
                subtitle: "Contact via call, email",
                onTap: () => Navigator.of(context).pushNamed("/contactUs"),
              ),
              _profileTile(
                icon: const AssetImage("assets/icons/settings.png"),
                title: "Settings",
                subtitle: "Change password, Deactivate account",
                onTap: () => Navigator.of(context).pushNamed("/settings"),
              ),

              SizedBox(height: 30.h),

              /// Logout Button
              InkWell(
                onTap: () => ShowDialog.showLogOut(context),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout, color: Colors.white, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          "Log Out",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _profileTile({
    required AssetImage icon,
    required String title,
    String? subtitle,
    Function? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image(
            image: icon,
            color: AppColors.primaryColor,
            height: 24.h,
            width: 24.w,
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.blackTile,
                  ),
                )
              : null,
          onTap: onTap != null ? () => onTap() : null,
        ),
        Divider(height: 1.h, thickness: 0.6, color: Colors.grey.shade300),
      ],
    );
  }
}
