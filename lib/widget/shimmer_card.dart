import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class FavouriteShimmerCard extends StatelessWidget {
  const FavouriteShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Placeholder
                    Container(
                      width: 130.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Text placeholders
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 12.h,
                              width: 120.w,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 12.h,
                              width: 80.w,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 12.h,
                              width: 160.w,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 12.h,
                              width: 200.w,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
