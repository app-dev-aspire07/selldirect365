import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/views/profile/help_center.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/route.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  Future<void> sendEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'App Support',
      },
    );

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context, title: "Contact Us"),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/app_logo.png",
                height: 120.h,
              ),
              SizedBox(height: 16.h),
              Text(
                "We're Here to Help",
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Reach us anytime for quick support.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20.h),

              /// Call + Email Buttons
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.call,
                      text: "Call Us",
                      gradient: const [Colors.green, Colors.teal],
                      onTap: () => _makePhoneCall("+18664850088"),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.email_outlined,
                      text: "Email Us",
                      gradient: const [Colors.orange, Colors.deepOrange],
                      onTap: () => sendEmail("info@selldirect365.com"),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              /// Info Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                            Icon(Icons.location_on, color: AppColors.primaryColor, size: 24.sp),
                        title: Text(
                          "1979 Marcus Ave, Suite 210",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        subtitle: Text(
                          "New Hyde Park, NY 11042",
                          style: GoogleFonts.inter(fontSize: 12.sp),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading:
                            Icon(Icons.access_time, color: AppColors.primaryColor, size: 20.sp),
                        title: Text(
                          "Working Hours",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        subtitle: Text(
                          "Mon–Fri: 9 AM – 7 PM\nSat–Sun: Closed",
                          style: GoogleFonts.inter(fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              /// Social Media
              Text(
                "Follow Us",
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIcon(
                    icon: Icons.whatshot,
                    color: Colors.green,
                    onTap: () => _openUrl("https://wa.me/911234567890"),
                  ),
                  SizedBox(width: 16.w),
                  _SocialIcon(
                    icon: Icons.facebook,
                    color: Colors.blue,
                    onTap: () => _openUrl("https://facebook.com/yourpage"),
                  ),
                  SizedBox(width: 16.w),
                  _SocialIcon(
                    icon: Icons.camera_alt,
                    color: Colors.purple,
                    onTap: () => _openUrl("https://instagram.com/yourpage"),
                  ),
                  SizedBox(width: 16.w),
                  _SocialIcon(
                    icon: Icons.work,
                    color: Colors.blueGrey,
                    onTap: () => _openUrl("https://linkedin.com/company/yourcompany"),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              /// FAQ Footer
              TextButton.icon(
                onPressed: () => Navigator.of(context).push(createRoute(HelpCenter())),
                icon: Icon(Icons.help_outline, color: Colors.black54, size: 16.sp),
                label: Text(
                  "Need quick help? Visit our FAQ",
                  style: GoogleFonts.inter(color: Colors.black54, fontSize: 12.sp),
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.text,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Ink(
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.r),
      onTap: onTap,
      child: CircleAvatar(
        radius: 20.r,
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20.sp),
      ),
    );
  }
}
