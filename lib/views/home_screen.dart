import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:truck_market_place/app_utils/search_screen.dart';
import 'package:truck_market_place/service/api_url.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/detailed_screens/truck_by_cat.dart';
import 'package:truck_market_place/views/detailed_screens/truck_details.dart';
import 'package:truck_market_place/views/detailed_screens/truck_list.dart';
import 'package:truck_market_place/views/detailed_screens/trucks.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/common_text.dart';
import 'package:truck_market_place/widget/route.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController _controller = TextEditingController();
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    return Scaffold(
      appBar: withoutBackAppBar(
        context,
        title: "Home",
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              size: isTablet ? 28 : 22,
              color: AppColors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 24 : 16,
          horizontal: isTablet ? 20 : 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            SizedBox(
              height: isTablet ? 55 : 50,
              child: _textFormField(context,_controller, isTablet),
            ),
            SizedBox(height: isTablet ? 20 : 12),

            // Categories
            CommonText(
              text: "Shop By Category",
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 20 : 16,
            ),
            SizedBox(height: 8),
            Obx(() {
              final isLoading = _homeController.isLoading.value;
              final categories = _homeController.categoriesList;

              if (isLoading) {
                return _buildShimmerGrid(isTablet, count: isTablet ? 5 : 3);
              }

              if (categories.isEmpty) {
                return Center(child: Text("No categories found"));
              }

              return GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 3 : 3,
                  childAspectRatio: isTablet ? 1.5 : 1.1,
                  crossAxisSpacing: isTablet ? 20 : 10,
                  mainAxisSpacing: isTablet ? 20 : 10,
                ),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        createRoute(
                          TruckByCategories(
                            name: item.name ?? "",
                            catId: item.id,
                          ),
                        ),
                      );
                    },
                    child: _categoryCard(
                      item.name ?? "",
                      item.icon ?? "",
                      isTablet,
                    ),
                  );
                },
              );
            }),

            SizedBox(height: isTablet ? 24 : 16),

            // Newly Added
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: "Newly Added",
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 20 : 16,
                ),
                InkWell(
                  onTap: () =>
                      Navigator.of(context).push(createRoute(ViewAllTrucks())),
                  child: CommonText(
                    text: "view all",
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 16 : 8),

            Obx(() {
              final trucks = _homeController.getTruckList;

              if (_homeController.isTrucks.value) {
                return _buildShimmerTruckList(isTablet);
              }

              if (trucks.isEmpty) {
                return SizedBox(
                  height: isTablet ? 180 : 150,
                  child: Center(child: Text("No Equipment found",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,)),
                ));
              }

              final reversedTrucks = trucks.reversed.toList();
              return SizedBox(
                height: isTablet ? 280 : 170,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: reversedTrucks.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(width: isTablet ? 20 : 12),
                  itemBuilder: (context, index) {
                    final truck = reversedTrucks[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          createRoute(
                            TruckDetails(
                              name:
                                  "${truck.year} ${truck.brand} ${truck.model}",
                              id: truck.truckFormId,
                            ),
                          ),
                        );
                      },
                      child: _truckCard(truck, isTablet),
                    );
                  },
                ),
              );
            }),

            SizedBox(height: isTablet ? 24 : 16),

            // Manufacturers
            CommonText(
              text: "Manufacturers",
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 20 : 16,
            ),
            SizedBox(height: 8),

            Obx(() {
              final isLoading = _homeController.isBrands.value;
              final brands = _homeController.branList;

              if (isLoading) {
                return _buildShimmerGrid(isTablet, count: isTablet ? 9 : 6);
              }

              if (brands.isEmpty) {
                return Center(child: Text("No Brands Found"));
              }

              return GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: brands.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 4 : 3,
                  childAspectRatio: isTablet ? 0.95 : 1.1,
                  crossAxisSpacing: isTablet ? 20 : 10,
                  mainAxisSpacing: isTablet ? 20 : 10,
                ),
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        createRoute(
                          TruckList(name: brand.optionValue, id: brand.id),
                        ),
                      );
                    },
                    child: _brandCard(
                      brand.optionValue ?? "",
                      brand.icon ?? "",
                      isTablet,
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

 
  TextFormField _textFormField(
    BuildContext context,
    TextEditingController? controller,
    bool isTablet,
  ) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.hintTxtColor,
      readOnly: true, // 👈 important
    onTap: () {
      Navigator.of(context).push(createRoute(SearchScreen()));
    },
      style: GoogleFonts.inter(
        fontSize: isTablet ? 16 : 13,
        color: AppColors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: "Search any brand, model, year",
        hintStyle: GoogleFonts.poppins(
          fontSize: isTablet ? 14 : 12.sp,
          color: AppColors.hintTxtColor,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.all(8.0),
        prefixIcon: Icon(
          Icons.search,
          size: isTablet ? 24 : 20,
          color: AppColors.indicatorColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.hintTxtColor),
        ),
      ),
    );
  }

  
  Widget _categoryCard(String name, String icon, bool isTablet) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // side: BorderSide(color: AppColors.hintTxtColor, width: 0.4),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.splashNew3.withOpacity(0.05),
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 16 : 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon.contains(".svg")
                  ? SvgPicture.network(
                      ApiEndPoints.imgBaseUrl + icon,
                      width: isTablet ? 64 : 40,
                    )
                  : CachedNetworkImage(
                      imageUrl: ApiEndPoints.imgBaseUrl + icon,
                      // width: isTablet ? 64 : 40.w,
                      height: isTablet ? 54.h : 20.h,
                      filterQuality: FilterQuality.high,
                    ),
              SizedBox(height: isTablet ? 12 : 20),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16 : 11.sp,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _truckCard(dynamic truck, bool isTablet) {
    final String? imageUrl = (truck.images != null && truck.images!.isNotEmpty)
        ? ApiEndPoints.imgUrl + truck.images![0]
        : null;

    return Container(
      width: isTablet ? 360 : 250,
      decoration: BoxDecoration(
        color: AppColors.indicatorColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: isTablet ? 180 : 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      height: isTablet ? 180 : 100,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(
                    height: isTablet ? 180 : 100,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(isTablet ? 12 : 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${truck.year} ${truck.brand} ${truck.model}",
                        style: GoogleFonts.inter(
                          fontSize: isTablet ? 8.sp : 12.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "\$${truck.price}",
                      style: GoogleFonts.inter(
                        fontSize: isTablet ? 8.sp : 12.sp,
                        color: Colors.white,
                        height: 0.9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 8 : 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: isTablet ? 18 : 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        truck.address ?? "",
                        style: GoogleFonts.inter(
                          fontSize: isTablet ? 14 : 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _brandCard(String name, String icon, bool isTablet) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // side: BorderSide(color: AppColors.hintTxtColor, width: 0.4),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.splashNew3.withOpacity(0.05),
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 16 : 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon.contains(".svg")
                  ? SvgPicture.network(
                      "${ApiEndPoints.imgMUrl}icons/$icon",
                      width: isTablet ? 64 : 40,
                    )
                  : CachedNetworkImage(
                      imageUrl: "${ApiEndPoints.imgMUrl}icons/$icon",
                      width: isTablet ? 64 : 40,
                    ),
              SizedBox(height: isTablet ? 12 : 6),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16 : 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildShimmerGrid(bool isTablet, {required int count}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 5 : 3,
          childAspectRatio: isTablet ? 1.5 : 1.1,
          crossAxisSpacing: isTablet ? 20 : 10,
          mainAxisSpacing: isTablet ? 20 : 10,
        ),
        itemBuilder: (_, __) => Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }


  Widget _buildShimmerTruckList(bool isTablet) {
    return SizedBox(
      height: isTablet ? 260 : 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: isTablet ? 6 : 4,
        separatorBuilder: (_, __) => SizedBox(width: isTablet ? 20 : 12),
        itemBuilder: (_, __) => Container(
          width: isTablet ? 360 : 220,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
