import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/detailed_screens/truck_details.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/route.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.put(HomeController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ✅ Clear old data when screen opens
    controller.getSearchResult.clear();
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        elevation: 1,
        foregroundColor: Colors.white,
        title: TextField(
          controller: searchController,
          autofocus: true,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: "Search equipment...",
            border: InputBorder.none,
            hintStyle: GoogleFonts.poppins(
              color: AppColors.white.withOpacity(0.8),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          cursorColor: AppColors.white,
          onChanged: (value) {
            if (value.trim().isEmpty) {
              controller.getSearchResult.clear();
              return;
            }
            controller.fetchSearchResult(keyword: value);
          },
        ),
      ),
      body: Obx(() {
        if (searchController.text.trim().isEmpty &&
            controller.getSearchResult.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 80.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 12.h),
                Text(
                  "Search to see equipment",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.isSearch.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.getSearchResult.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied,
                  size: 70.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 8.h),
                Text(
                  "No results found",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${controller.getSearchResult.length} results found",
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 2.h),
              Divider(thickness: 0.5, color: Colors.black),
              SizedBox(height: 4.h),

              Expanded(
                child: ListView.separated(
                  itemCount: controller.getSearchResult.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: Colors.grey.shade400, height: 20.h),
                  itemBuilder: (context, index) {
                    final item = controller.getSearchResult[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 6.0,
                      ),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          createRoute(
                            TruckDetails(
                              id: item.truckFormId,
                              name:
                                  "${item.year ?? ""} ${item.brand ?? ""} ${item.model ?? ""}",
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${item.year ?? ""} ${item.brand ?? ""} ${item.model ?? ""}",
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              item.address ?? "Unknown",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.splashNew4,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
