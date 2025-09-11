import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/views/profile/change_password.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/route.dart';
import 'package:truck_market_place/widget/show_popUp.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context, title: "Settings"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _settingsTile(
              icon: Icons.lock_outline,
              title: "Change Password",
              onTap: () {
                Navigator.of(context).push(createRoute(ChangePasswordScreen()));
              },
            ),
            Divider(color: Colors.grey.shade300),
            _settingsTile(
              icon: Icons.delete_outline,
              title: "Delete Account",
              iconColor: Colors.red,
              titleColor: Colors.red,
              onTap: () {
                ShowDialog.showConfirmUp(context, title: "Deactivate Account", onTap: (){});
              },
            ),
            Divider(color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required Function() onTap,
    Color iconColor = Colors.black,
    Color titleColor = Colors.black,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16.sp, color: Colors.grey),
      onTap: onTap,
    );
  }
}
