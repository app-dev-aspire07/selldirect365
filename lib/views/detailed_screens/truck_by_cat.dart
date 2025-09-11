import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:truck_market_place/service/api_url.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/detailed_screens/truck_details.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/route.dart';

class TruckByCategories extends StatefulWidget {
  final int? catId;
  final String? name;

  const TruckByCategories({super.key, this.catId, this.name});

  @override
  State<TruckByCategories> createState() => _TruckByCategoriesState();
}

class _TruckByCategoriesState extends State<TruckByCategories> {
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _homeController.selectedSubCat.value = 0;
      await _homeController.fetchSubCategoriesList(widget.catId ?? 0);
      _homeController.fetchTrucksByCategories(id: widget.catId, subCatId: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: mainAppBar(context, title: widget.name),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (_homeController.isSubCat.value) {
              return _buildShimmerChips();
            }

            if (_homeController.subCatList.isEmpty) {
              return const SizedBox.shrink();
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  _buildChip(
                    isTablet: isTablet,
                    label: "All",
                    isSelected: _homeController.selectedSubCat.value == 0,
                    onTap: () {
                      _homeController.selectedSubCat.value = 0;
                      _homeController.fetchTrucksByCategories(
                        id: widget.catId,
                        subCatId: 0,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  ..._homeController.subCatList.map((subItem) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildChip(
                        isTablet: isTablet,
                        label: subItem.name ?? "",
                        isSelected:
                            _homeController.selectedSubCat.value == subItem.id,
                        onTap: () {
                          _homeController.selectedSubCat.value =
                              subItem.id ?? 0;
                          _homeController.fetchTrucksByCategories(
                            id: widget.catId,
                            subCatId: subItem.id ?? 0,
                          );
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          }),

          Expanded(
            child: Obx(() {
              if (_homeController.isCat.value) {
                return _buildTruckShimmerGrid(isTablet);
              }

              if (_homeController.getTruckCatList.isEmpty) {
                return const Center(
                  child: Text(
                    "No Trucks Found",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(4),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 3 : 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: isTablet ? 0.68 : 1.3 / 1.67,
                ),
                itemCount: _homeController.getTruckCatList.length,
                itemBuilder: (context, index) {
                  final truck = _homeController.getTruckCatList[index];

                  String imageUrl = "";
                  try {
                    final decoded = truck.images != null
                        ? List<String>.from(truck.images as List)
                        : [];
                    if (decoded.isNotEmpty) {
                      imageUrl = ApiEndPoints.imgUrl + decoded.first;
                    }
                  } catch (e) {
                    imageUrl = "";
                  }

                  return _buildMinimalTruckCard(isTablet, truck, imageUrl);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTruckShimmerGrid(isTablet) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: isTablet ? 0.68 : 1.3 / 1.67,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),

                      Container(
                        height: 12,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 24,
                            width: 65,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),

                          Container(
                            height: 28,
                            width: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip({
    isTablet,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryColor.withOpacity(0.7),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 8.sp : 12.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalTruckCard(isTablet, truck, String imageUrl) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          createRoute(TruckDetails(name: truck.brand, id: truck.truckFormId)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: isTablet ? 140.h : 130.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey.shade200),
                          errorWidget: (context, url, error) => Container(
                            height: 130.h,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.local_shipping, size: 40),
                          ),
                        )
                      : Container(
                          height: 120,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.local_shipping, size: 40),
                        ),
                ),

                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Featured",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: isTablet ? 7.sp : 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "\$ ${truck.price ?? "-"}",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${truck.year ?? ""} ${truck.brand}",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: isTablet ? 10.sp : 13.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    truck.model ?? "-",
                    style: GoogleFonts.inter(
                      fontSize: isTablet ? 10.sp : 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    truck.desc ?? "No description available",
                    style: GoogleFonts.inter(
                      fontSize: isTablet ? 9.sp : 12.sp,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerChips() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: List.generate(
          4,
          (index) => Container(
            margin: const EdgeInsets.only(right: 8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 36,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
