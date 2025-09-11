import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/sell/rest_data.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/route.dart';

class TheList extends StatelessWidget {
  final String? brand;
  final String? model;
  final String? color;
  final String? year;
  final int? catId;
  final int? subCat;
  final int? brandId;
  final int? modelId;
  final int? colorId;
  final int? yearId;
  final int? fieldId1;
  final int? fieldId2;
  final int? fieldId3;
  final int? fieldId4;

  TheList({
    super.key,
    this.brand,
    this.model,
    this.color,
    this.year,
    this.catId,
    this.subCat,
    this.brandId,
    this.modelId,
    this.colorId,
    this.yearId,
    this.fieldId1,
    this.fieldId2,
    this.fieldId3,
    this.fieldId4,
  });

  final HomeController _home = Get.find<HomeController>();
  final TextEditingController priceTC = TextEditingController();

  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    return Scaffold(
      appBar: mainAppBar(context, title: "Sell"),
      body: Obx(() {
        // safe-guards
        if (_home.theList.isEmpty || _home.theList.length < 3) {
          return const Center(child: CircularProgressIndicator());
        }

        final priceField = _home.theList[0];
        final modelField = _home.theList[1];
        final transmissionField = _home.theList[2];

        final modelOptions = modelField.options ?? [];
        final transOptions = transmissionField.options ?? [];

        final canProceed = _home.enteredPrice.value.isNotEmpty;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label(isTablet, priceField.fieldLabel ?? "", priceField.isOptional),
              const SizedBox(height: 10),

              if (priceField.isManual == 1) _priceInput(isTablet),

              const SizedBox(height: 28),

              _label(isTablet, modelField.fieldLabel ?? "", modelField.isOptional),
              const SizedBox(height: 10),
              _compactSelectableList(
                isTablet: isTablet,
                options: modelOptions,
                selectedIndexRx: _home.selectedModelIndex,
                onTap: (i) => _home.selectedModelIndex.value = i,
              ),

              // const SizedBox(height: 20),
              _label(
                isTablet,
                transmissionField.fieldLabel ?? "",
                transmissionField.isOptional,
              ),
              const SizedBox(height: 10),
              _compactSelectableList(
                isTablet: isTablet,
                options: transOptions,
                selectedIndexRx: _home.selectedTransmissionIndex,
                onTap: (i) => _home.selectedTransmissionIndex.value = i,
              ),

              const SizedBox(height: 24),

              // NEXT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canProceed
                          ? AppColors.primaryColor
                          : Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: canProceed
                        ? () {
                            // Price (required)
                            final price = _home.enteredPrice.value;

                            // Model (optional)
                            String? selectedModel;
                            int? gvvrId;
                            if (_home.selectedModelIndex.value != -1) {
                              selectedModel =
                                  modelOptions[_home.selectedModelIndex.value]
                                      .optionValue;
                              gvvrId =
                                  modelOptions[_home.selectedModelIndex.value]
                                      .id;
                            } else {
                              selectedModel =
                                  _home.manualFieldValues[modelField.fieldId] ??
                                  "";
                              gvvrId = null;
                            }

                            // Transmission (optional)
                            String? selectedAxle;
                            int? axleId;
                            if (_home.selectedTransmissionIndex.value != -1) {
                              selectedAxle =
                                  transOptions[_home
                                          .selectedTransmissionIndex
                                          .value]
                                      .optionValue;
                              axleId =
                                  transOptions[_home
                                          .selectedTransmissionIndex
                                          .value]
                                      .id;
                            } else {
                              selectedAxle =
                                  _home.manualFieldValues[transmissionField
                                      .fieldId] ??
                                  "";
                              axleId = null;
                            }

                            debugPrint("Price: $price");
                            debugPrint("Selected Model: $selectedModel");
                            debugPrint("Selected Transmission: $selectedAxle");

                            Navigator.of(context).push(
                              createRoute(
                                RestDetails(
                                  axle: selectedAxle ?? "",
                                  brand: brand,
                                  color: color,
                                  gvvr: selectedModel ?? "",
                                  model: model,
                                  price: price,
                                  year: year,
                                  catId: catId,
                                  subCat: subCat,
                                  brandId: brandId,
                                  modelId: modelId,
                                  colorId: colorId,
                                  yearId: yearId,
                                  priceId: 0,
                                  axleId: axleId,
                                  gvvrId: gvvrId,
                                  fieldId1: fieldId1,
                                  fieldId2: fieldId2,
                                  fieldId3: fieldId3,
                                  fieldId4: fieldId4,
                                  fieldId5: _home.theList[0].fieldId,
                                  fieldId6: _home.theList[1].fieldId,
                                  fieldId7: _home.theList[2].fieldId,
                                ),
                              ),
                            );
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
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }),
    );
  }

  Widget _label(isTablet, String text, int? isOptional) {
    return Text(
      isOptional == 1 ? "$text (Optional)" : text,
      style: GoogleFonts.inter(
        fontSize:isTablet? 14.sp: 16.sp, // thoda compact
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _priceInput(isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height:isTablet?60: 40,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: priceTC,
                  cursorColor: AppColors.hintTxtColor,
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _home.enteredPrice.value = value; // save price live
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: AppColors.hintTxtColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: AppColors.indicatorColor,
                        width: 1.0,
                      ),
                    ),
                    hintText: "Enter price",
                    hintStyle: GoogleFonts.poppins(
                      color: AppColors.hintTxtColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 90.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _home.showEnteredPrice.value = true; // show on UI
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.poppins(
                      fontSize:isTablet? 8.sp: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Show entered price after submit
        Obx(() {
          if (_home.showEnteredPrice.value &&
              _home.enteredPrice.value.trim().isNotEmpty) {
            return Text(
              "Entered Price: \$${_home.enteredPrice.value}",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.appBar,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  /// Compact, reactive selectable list
  Widget _compactSelectableList({
    isTablet,
    required List<dynamic> options,
    required RxInt selectedIndexRx,
    required void Function(int) onTap,
  }) {
    return SizedBox(
      height: AppDimentions.pxh200,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final option = options[index];
          return Obx(() {
            final isSelected = selectedIndexRx.value == index;
            return InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.grey.shade300,
                    width: isSelected ? 1.5 : 0.8,
                  ),
                  color: isSelected
                      ? AppColors.primaryColor.withOpacity(0.06)
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option?.optionValue ?? "Unknown",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize:isTablet? 11.sp: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: AppColors.primaryColor,
                      ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
