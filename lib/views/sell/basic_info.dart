import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/service/api_url.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/sell/first_screen.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';

class BasicInfo extends StatefulWidget {
  const BasicInfo({super.key});

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();

    ever(_homeController.categoriesList, (_) {
      if (_homeController.categoriesList.isNotEmpty) {
        _homeController.selectedCatId.value =
            _homeController.categoriesList[0].id ?? 0;
        _homeController.fetchSubCategoriesList(
          _homeController.selectedCatId.value,
        );
        _homeController.selectedSubCatId.value = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    return Scaffold(
      appBar: withoutBackAppBar(
        context,
        title: "Sell",
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Categories
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio:isTablet? 1.4: 3 / 2.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _homeController.categoriesList.length,
                itemBuilder: (context, index) {
                  final item = _homeController.categoriesList[index];
                  return Obx(() {
                    final isSelected =
                        _homeController.selectedCatId.value == item.id;
                    return InkWell(
                      onTap: () {
                        _homeController.selectedCatId.value = item.id ?? 0;
                        _homeController.fetchSubCategoriesList(
                          _homeController.selectedCatId.value,
                        );
                        _homeController.selectedSubCatId.value =
                            0; // reset subcategory
                        _homeController.fetchFormFields(
                          _homeController.selectedCatId.value,
                        );
                      },
                      child: Card(
                        elevation: isSelected ? 6 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.hintTxtColor,
                            width: isSelected ? 1.5 : 0.4,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor.withOpacity(0.1)
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                item.icon!.contains(".svg")
                                    ? SvgPicture.network(
                                        ApiEndPoints.imgBaseUrl + item.icon!,
                                        width: AppDimentions.pxw40,
                                        height: AppDimentions.pxh_40,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl:
                                            ApiEndPoints.imgBaseUrl +
                                            item.icon!,
                                        width: AppDimentions.pxw40,
                                        height: AppDimentions.pxh_40,
                                      ),
                                const SizedBox(height: 8),
                                Text(
                                  item.name ?? "",
                                  style: GoogleFonts.poppins(
                                    fontSize: AppDimentions.sp11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            /// Subcategories
            Obx(() {
              if (_homeController.subCatList.isEmpty) {
                return const SizedBox.shrink();
              }
              return SizedBox(
                height: isTablet?90.h:80.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _homeController.subCatList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final subItem = _homeController.subCatList[index];

                    return Obx(() {
                      final bool isSubSelected =
                          _homeController.selectedSubCatId.value ==
                          (subItem.id ?? 0);

                      return GestureDetector(
                        onTap: () {
                          _homeController.selectedSubCatId.value =
                              subItem.id ?? 0;
                              
                        },
                        child: Container(
                          width: 120.w,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 0,
                          ),
                          decoration: BoxDecoration(
                            color: isSubSelected
                                ? AppColors.primaryColor.withOpacity(0.15)
                                : Colors.white,
                            border: Border.all(
                              color: isSubSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade300,
                              width: isSubSelected ? 1.5 : 0.8,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                subItem.icon!.contains(".svg")
                                    ? SvgPicture.network(
                                        ApiEndPoints.imgBaseUrl + subItem.icon!,
                                        width: AppDimentions.pxw30,
                                        height: AppDimentions.pxh_30,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl:
                                            "${ApiEndPoints.imgBaseUrl}icons${subItem.icon!}",
                                        width: AppDimentions.pxw30,
                                        height: AppDimentions.pxh_30,
                                      ),
                                const SizedBox(height: 8),
                                Text(
                                  subItem.name ?? "",
                                  style: GoogleFonts.poppins(
                                    fontSize: AppDimentions.sp11,
                                    fontWeight: FontWeight.w500,
                                    color: isSubSelected
                                        ? AppColors.primaryColor
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              );
            }),

            const SizedBox(height: 10),

            /// Form screen
            Expanded(
              flex:isTablet ? 3 : 4,
              child: Obx(
                () => ScreenFirst(
                  key: ValueKey(_homeController.selectedCatId.value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
