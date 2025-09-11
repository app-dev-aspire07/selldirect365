import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:truck_market_place/model/Truck_Model/get_truck_id_model.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/service/api_url.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/image_view.dart';
import 'package:truck_market_place/widget/loading_bar.dart';
import 'package:truck_market_place/widget/route.dart';

class TruckDetails extends StatefulWidget {
  final String? name;
  final int? id;
  const TruckDetails({super.key, this.name, this.id});

  @override
  State<TruckDetails> createState() => _TruckDetailsState();
}

class _TruckDetailsState extends State<TruckDetails>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  bool _showMore = false;
  int currentPage = 0;
  final HomeController _homeController = Get.find();
  int _initialVisible = 6; // initially kitne fields dikhenge

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  loadData() async {
    await _homeController.fetchTruckById(widget.id!);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    return Scaffold(
      appBar: mainAppBar(context, title: widget.name),
      body: Obx(() {
        if (_homeController.isTruckDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final truck = _homeController.truckDetail.value;
        final images = truck?.images ?? [];
        final address = truck?.address ?? "N/A";
        final fields = truck?.fields ?? [];
        final desc = truck?.desc ?? "N/A";
        final isQuote = truck?.isQuote ?? 0;
        final isFavorite = truck?.isFavorite ?? 0;

        String getField(String fieldName) {
          if (fields.isEmpty) return "N/A";
          try {
            final field = fields.firstWhere(
              (f) => f.fieldName?.toLowerCase() == fieldName.toLowerCase(),
              orElse: () => Field(optionValue: "N/A"),
            );
            return field.optionValue ?? "N/A";
          } catch (_) {
            return "N/A";
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image Slider
            SizedBox(
              height: isTablet ? 260.h : 220.h,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() => currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(
                              FullScreenImageViewer(
                                imagePaths: images,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: ApiEndPoints.imgUrl + images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),

                  /// Page Indicator
                  if (images.isNotEmpty)
                    Positioned(
                      bottom: 10.h,
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: images.length,
                        effect: ScrollingDotsEffect(
                          activeDotColor: Colors.black,
                          dotColor: Colors.grey.shade300,
                          dotHeight: 8.h,
                          dotWidth: 8.w,
                        ),
                      ),
                    ),

                  /// Favorite Button
                  Positioned(
                    top: 10,
                    right: 18,
                    child: InkWell(
                      onTap: () async {
                        await toggleFavorite(widget.id!, isFavorite, context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: Icon(
                          isFavorite == 0
                              ? Icons.favorite_border
                              : Icons.favorite,
                          size: isTablet ? 30 : 22,
                          color: isFavorite == 0
                              ? AppColors.black
                              : AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Content Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      widget.name ?? "Truck Details",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.indicatorColor,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    /// Location / Price / Mileage
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: AppColors.primaryColor, size: 14.sp),
                        SizedBox(
                          width: Get.width * 0.5,
                          child: Text(
                            address,
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Icon(Icons.attach_money_outlined,
                            color: AppColors.primaryColor, size: 14.sp),
                        Text(
                          getField("Price"),
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Image.asset("assets/icons/meter.png",
                            color: AppColors.primaryColor, width: 14.w),
                        Text(
                          getField("Mileage"),
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),

                    Divider(color: AppColors.appBar, thickness: 0.4),

                    /// Description
                    Text("Description",
                        style: _sectionTitleStyle(isTablet)),
                    SizedBox(height: 4.h),
                    Text(
                      desc,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    /// Details
                    Text("Details", style: _sectionTitleStyle(isTablet)),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Column(
                        children: fields
                            .take(_showMore ? fields.length : _initialVisible)
                            .map((field) => _buildRow(
                                  isTablet,
                                  field.fieldName ?? "",
                                  field.optionValue ?? "N/A",
                                ))
                            .toList(),
                      ),
                    ),

                    if (fields.length > _initialVisible) ...[
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _showMore = !_showMore),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _showMore ? "See Less" : "See More",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              _showMore
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 20.h),

                    /// Quote Button
                    InkWell(
                      onTap: isQuote == 1
                          ? null
                          : () async {
                              await _sendQuote(context, widget.id!);
                            },
                      child: Container(
                        height: AppDimentions.pxh_45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: isQuote == 1
                              ? Colors.grey
                              : AppColors.primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            isQuote == 0 ? "Get a Quote" : "Request Sent",
                            style: GoogleFonts.inter(
                              color: AppColors.white,
                              fontSize: AppDimentions.sp16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Quote Send Function
  Future<void> _sendQuote(BuildContext context, int truckId) async {
    LoadingBar.showLoaderDialog(context, "Please wait...");
    final repo = await ApiRepository.sentQuote(truckId: truckId, isQuote: 1);
    Navigator.of(context).pop();

    if (repo.status == true) {
      showDialog(
  context: context,
  builder: (dialogContext) => Dialog(   // 👈 yaha alag context le liya
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 16),
          Text(
            "Request Sent!",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Thank you! Your quotation request has been submitted successfully. Our support team will contact you shortly.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
               Navigator.of(dialogContext).pop();
              await _homeController.fetchTruckById(widget.id!);
              
            },
            child: Text(
              "Okay",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

    } else {
      Get.snackbar("Error", repo.message ?? "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// Toggle Favorite
  Future<void> toggleFavorite(int truckId, int isFavorite, BuildContext context) async {
  try {
    LoadingBar.showLoaderDialog(context, "Please wait...");
    final newStatus = isFavorite == 0 ? 1 : 0;

    var repo = await ApiRepository.saveFavorite(
      truckId: truckId,
      isFavorite: newStatus,
    );
    Navigator.of(context).pop();

    if (repo.status == true) {
      // 👇 Force update local state instead of only relying on API
      _homeController.truckDetail.update((truck) {
        truck?.isFavorite = newStatus;
      });

      Get.snackbar(
        "Success",
        newStatus == 1 ? "Added to favorites" : "Removed from favorites",
        snackPosition: SnackPosition.TOP,
        backgroundColor: newStatus == 1 ? Colors.green : Colors.redAccent,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar("Error", repo.message ?? "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  } catch (e) {
    Navigator.of(context).pop();
    Get.snackbar("Error", "Unexpected error occurred",
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}

}

Widget _buildRow(bool isTablet, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 10.sp : 12.sp,
              color: AppColors.dotColor1,
              fontWeight: FontWeight.w600,
            )),
        Text(value,
            style: GoogleFonts.inter(
              fontSize: isTablet ? 10.sp : 12.sp,
              color: AppColors.black,
            )),
      ],
    ),
  );
}

TextStyle _sectionTitleStyle(bool isTablet) {
  return GoogleFonts.inter(
    fontSize: isTablet ? 14.sp : 15.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.indicatorColor,
  );
}
