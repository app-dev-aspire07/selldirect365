import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/sell/year_list.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/route.dart';

class ModelList extends StatelessWidget {
  final String? brandName;
  final int? brandId;
  final int? catId;
  final int? subCat;
  final int? fieldId1;

  ModelList({
    super.key,
    this.brandName,
    this.catId,
    this.subCat,
    this.brandId,
    this.fieldId1,
  });

  final HomeController _homeController = Get.find();
  final TextEditingController manualController = TextEditingController();
  final RxString manualInput = "".obs;

  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // keyboard dismiss anywhere tap
      child: Scaffold(
        appBar: mainAppBar(context, title: "Sell"),
        body: GestureDetector(
          behavior:
              HitTestBehavior.translucent, // empty area tap bhi detect hoga
          onTap: () {
            FocusScope.of(context).unfocus(); // keyboard close + focus remove
          },
          child: Obx(() {
            final modelField = _homeController.modelList.isNotEmpty
                ? _homeController.modelList.first
                : null;
            final options = modelField?.options ?? [];

            if (modelField == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    modelField.fieldLabel ?? "",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Model List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 12, top: 6),
                      itemCount:
                          options.length + (modelField.isOptional == 1 ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < options.length) {
                          final option = options[index];

                          return Obx(() {
                            final isSelected =
                                _homeController.selectedModelIndex.value ==
                                index;

                            return GestureDetector(
                              onTap: () {
                                // list select -> manual clear
                                manualController.clear();
                                manualInput.value = "";
                                _homeController.selectedModelIndex.value =
                                    index;
                              },
                              child: Card(
                                elevation: isSelected ? 4 : 1,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.grey.shade300,
                                    width: isSelected ? 1.5 : 0.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        option.optionValue ?? "Unknown",
                                        style: GoogleFonts.inter(
                                          fontSize:isTablet?12.sp: 14.sp,
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
                        } else {
                          /// Extra section for manual input
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20.h),
                              Text(
                                "Or add manually",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                height: 44.h,
                                child: TextFormField(
                                  controller: manualController,
                                  onChanged: (val) {
                                    manualInput.value = val;
                                    if (val.trim().isNotEmpty) {
                                      // manual -> list deselect
                                      _homeController.selectedModelIndex.value =
                                          -1;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Enter model name",
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// NEXT button
                  Obx(() {
                    final isEnabled =
                        _homeController.selectedModelIndex.value != -1 ||
                        manualInput.value.trim().isNotEmpty;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEnabled
                                ? AppColors.primaryColor
                                : Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isEnabled
                              ? () {
                                  String? selectedModel;
                                  int? modelId;

                                  if (_homeController
                                          .selectedModelIndex
                                          .value !=
                                      -1) {
                                    selectedModel =
                                        options[_homeController
                                                .selectedModelIndex
                                                .value]
                                            .optionValue;
                                    modelId =
                                        options[_homeController
                                                .selectedModelIndex
                                                .value]
                                            .id;
                                  } else {
                                    selectedModel = manualInput.value;
                                    modelId = 0;
                                  }
                                  print(selectedModel);
                                  print(modelId);
                                  Navigator.push(
                                    context,
                                    createRoute(
                                      ColorYearList(
                                        brand: brandName,
                                        model: selectedModel,
                                        catId: catId,
                                        subCat: subCat,
                                        brandId: brandId,
                                        modelId: modelId,
                                        fieldId1: fieldId1,
                                        fieldId2: modelField.fieldId,
                                      ),
                                    ),
                                  );
                                  _homeController.selectedModelIndex.value = -1;
                                }
                              : null,
                          child: Text(
                            "NEXT",
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 14),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
