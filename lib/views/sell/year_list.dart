import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/sell/the_list.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/route.dart';

class ColorYearList extends StatelessWidget {
  final String? brand;
  final String? model;
  final int? catId;
  final int? subCat;
  final int? brandId;
  final int? modelId;
  final int? fieldId1;
  final int? fieldId2;

  ColorYearList({
    super.key,
    this.brand,
    this.model,
    this.catId,
    this.subCat,
    this.brandId,
    this.modelId,
    this.fieldId1,
    this.fieldId2,
  });

  final HomeController _homeController = Get.find();

  /// Manual Year input
  final TextEditingController yearManualController = TextEditingController();
  final FocusNode yearManualFocus = FocusNode();
  final RxString yearManualInput = "".obs;

  /// Manual Color input
  final TextEditingController colorManualController = TextEditingController();
  final FocusNode colorManualFocus = FocusNode();
  final RxString colorManualInput = "".obs;

  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // anywhere tap hides keyboard
      child: Scaffold(
        appBar: mainAppBar(context, title: "Sell"),
        body: Obx(() {
          // yearColorList observable hona chahiye controller me
          if (_homeController.yearColorList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final yearField = _homeController.yearColorList.first;
          final colorField = _homeController.yearColorList[1];

          final yearOptions = yearField.options ?? [];
          final colorOptions = colorField.options ?? [];

          final isYearManualAllowed = yearField.isManual == 1;
          final isColorManualAllowed = colorField.isManual == 1;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// YEAR LIST
                Text(
                  yearField.fieldLabel ?? "Year",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),

                 SizedBox(
                  height: AppDimentions.pxh220,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: isYearManualAllowed ? yearOptions.length + 1 : yearOptions.length,
                    itemBuilder: (context, index) {
                      if (index < yearOptions.length) {
                        final option = yearOptions[index];

                        return Obx(() {
                          final isSelected =
                              _homeController.selectedModelIndex.value == index;

                          return GestureDetector(
                            onTap: () {
                              yearManualController.clear();
                              yearManualInput.value = "";
                              _homeController.selectedModelIndex.value = index;
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              elevation: isSelected ? 3 : 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade300,
                                  width: isSelected ? 1.5 : 0.5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      option.optionValue ?? "Unknown",
                                      style: GoogleFonts.inter(
                                        fontSize: isTablet? 10.sp: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.primaryColor,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      }

                     
                      return Obx(() {
                        final isManual = yearManualInput.value.isNotEmpty;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "Or add manually",
                              style: GoogleFonts.inter(
                                fontSize:isTablet?9.sp: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: yearManualController,
                              focusNode: yearManualFocus,
                              onTap: () {
                                _homeController.selectedModelIndex.value = -1; // deselect
                              },
                              onChanged: (val) {
                                yearManualInput.value = val.trim();
                              },
                              decoration: InputDecoration(
                                hintText: "Enter year manually",
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                    },
                  ),
                ),

                  const SizedBox(height: 20),

                /// COLOR LIST
                Text(
                  colorField.fieldLabel ?? "Color",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:isTablet? 6: 4,
                      childAspectRatio: 2.3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: colorOptions.length,
                    itemBuilder: (context, index) {
                      final option = colorOptions[index];
                  
                      return Obx(() {
                        final isSelected1 = _homeController.selectedModelIndex1.value == index;
                  
                        return GestureDetector(
                          onTap: () {
                            // grid select -> manual clear
                            colorManualController.clear();
                            colorManualInput.value = "";
                            _homeController.selectedModelIndex1.value = index;
                            FocusScope.of(context).unfocus();
                          },
                          child: Card(
                            elevation: 1.5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSelected1 ? AppColors.primaryColor : Colors.grey.shade300,
                                width: isSelected1 ? 1.5 : 0.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                option.optionValue ?? "Unknown",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: isTablet? 10.sp: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected1 ? AppColors.primaryColor : AppColors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),

                if (isColorManualAllowed) ...[
                  const SizedBox(height: 10),
                  Text(
                    "Or add color manually",
                    style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: colorManualController,
                    focusNode: colorManualFocus,
                    onTap: () {
                      // manual focus -> grid deselect
                      _homeController.selectedModelIndex1.value = -1;
                    },
                    onChanged: (val) {
                      colorManualInput.value = val.trim();
                    },
                    decoration: InputDecoration(
                      hintText: "Enter color manually",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],

                const SizedBox(height: 10),
                // Expanded(child: Container()),

                /// NEXT BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(() {
                    final bool isYearListSelected = _homeController.selectedModelIndex.value != -1;
                    final bool isColorListSelected = _homeController.selectedModelIndex1.value != -1;

                    final bool isYearManualSelected = yearManualInput.value.isNotEmpty;
                    final bool isColorManualSelected = colorManualInput.value.isNotEmpty;

                    final bool isEnabled =
                        (isYearListSelected || isYearManualSelected) &&
                        (isColorListSelected || isColorManualSelected);

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isEnabled ? AppColors.primaryColor : Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isEnabled
                            ? () {
                                final String? selectedYear = isYearManualSelected
                                    ? yearManualInput.value
                                    : yearOptions[_homeController.selectedModelIndex.value].optionValue;

                                final String? selectedColor = isColorManualSelected
                                    ? colorManualInput.value
                                    : colorOptions[_homeController.selectedModelIndex1.value].optionValue;

                                final int? yearId = isYearManualSelected
                                    ? null
                                    : yearOptions[_homeController.selectedModelIndex.value].id;

                                final int? colorId = isColorManualSelected
                                    ? null
                                    : colorOptions[_homeController.selectedModelIndex1.value].id;

                                Navigator.push(
                                  context,
                                  createRoute(
                                    TheList(
                                      brand: brand,
                                      color: selectedColor,
                                      model: model,
                                      year: selectedYear,
                                      catId: catId,
                                      subCat: subCat,
                                      brandId: brandId,
                                      modelId: modelId,
                                      colorId: colorId,
                                      yearId: yearId,
                                      fieldId1: fieldId1,
                                      fieldId2: fieldId2,
                                      fieldId3: colorField.fieldId,
                                      fieldId4: yearField.fieldId,
                                    ),
                                  ),
                                );

                                // reset selections
                                _homeController.selectedModelIndex.value = -1;
                                _homeController.selectedModelIndex1.value = -1;
                                yearManualController.clear();
                                colorManualController.clear();
                                yearManualInput.value = "";
                                colorManualInput.value = "";
                              }
                            : null,
                        child: Text(
                          "NEXT",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }),
      ),
    );
  }
}
