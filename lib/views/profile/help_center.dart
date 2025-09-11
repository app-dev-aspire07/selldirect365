import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  final List<Map<String, String>> faqs = const [
    {
      'question': 'How can I post my truck for sale?',
      'answer': 'Go to "Sell Truck", fill the form with details like model, mileage, and upload documents. Submit for admin approval.'
    },
    {
      'question': 'Where can I check my sent quotes?',
      'answer': 'Visit the Profile > Equipment Info > Sent Quote tab to view all quotes you have sent to sellers.'
    },
    {
      'question': 'How long does admin take to approve my truck?',
      'answer': 'Approval typically takes 24–48 hours depending on the completeness of your submission.'
    },
    {
      'question': 'Can I edit my truck listing?',
      'answer': 'Yes. Go to My Equipment and tap the edit icon next to your listed truck to update information.'
    },
     {
      'question': 'How do I start looking for equipment?',
      'answer': 'After downloading the application, open it on your phone. After a moment a page asking you to get started or sign in will appear. Choose get started to open the app roght away and start looking for your next rig.'
    },
    {
      'question': 'How do I contact support?',
      'answer': 'You can contact us from the Help Center screen via call or email. Look below for contact options.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context, title: "Help Center"),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FAQ's",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 16.h),
              ListView.separated(
                itemCount: faqs.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade300,
                  height: 12.h,
                  thickness: 0.8,
                ),
                itemBuilder: (context, index) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      tilePadding: EdgeInsets.symmetric(horizontal: 12.w),
                      childrenPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      backgroundColor: Colors.grey.shade100,
                      collapsedBackgroundColor: Colors.grey.shade200,
                      title: Text(
                        faqs[index]['question'] ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      iconColor: AppColors.primaryColor,
                      children: [
                        Text(
                          faqs[index]['answer'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),  
                    
                  );
                },
              ),
              SizedBox(height: 30.h),
              Text(
                "Need More Help?",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 10.h),
              ListTile(
                leading: const Icon(Icons.email_outlined, color: Colors.blueAccent),
                title: Text("support@aspireglobus.com",
                    style: GoogleFonts.inter(fontSize: 14.sp)),
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined, color: Colors.green),
                title: Text("+1 (866)-485-0088", style: GoogleFonts.inter(fontSize: 14.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
