import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/model/Truck_Model/get_formField_model.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/sell/description.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/loading_bar.dart';
import 'package:truck_market_place/widget/route.dart';

class RestDetails extends StatelessWidget {
  final String? brand;
  final String? model;
  final String? color;
  final String? year;
  final String? price;
  final String? axle;
  final String? gvvr;
  final int? catId;
  final int? subCat;
  final int? brandId;
  final int? modelId;
  final int? colorId;
  final int? yearId;
  final int? priceId;
  final int? axleId;
  final int? gvvrId;
  final int? fieldId1;
  final int? fieldId2;
  final int? fieldId3;
  final int? fieldId4;
  final int? fieldId5;
  final int? fieldId6;
  final int? fieldId7;

  RestDetails({
    super.key,
    this.brand,
    this.model,
    this.color,
    this.year,
    this.price,
    this.axle,
    this.gvvr,
    this.catId,
    this.subCat,
    this.brandId,
    this.modelId,
    this.colorId,
    this.yearId,
    this.priceId,
    this.axleId,
    this.gvvrId,
    this.fieldId1,
    this.fieldId2,
    this.fieldId3,
    this.fieldId4,
    this.fieldId5,
    this.fieldId6,
    this.fieldId7,
  });

  final HomeController _home = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
         final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    return Scaffold(
      appBar: mainAppBar(context, title: "Sell"),
      body: Obx(
        () => _home.isForm.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _home.remainingFieldsList.length,
                        itemBuilder: (context, index) {
                          final field = _home.remainingFieldsList[index];
                          // final fieldId = field.fieldId ?? "f$index";
                          final options = field.options ?? [];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _home.remainingFieldsList[index].isOptional == 1
                                  ? Text(
                                      "${field.fieldLabel} (Optional)",
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : Text(
                                      field.fieldLabel ?? "",
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              const SizedBox(height: 10),
                              options.isEmpty
                                  ? _priceInput(
                                    isTablet,
                                      _home.remainingFieldsList[index].fieldId!,
                                      field.fieldLabel,
                                    )
                                  : options.length > 3
                                  ? _listSelection(
                                    isTablet,
                                      _home.remainingFieldsList[index].fieldId!,
                                      options,
                                    )
                                  : _gridSelection(
                                    isTablet,
                                      _home.remainingFieldsList[index].fieldId!,
                                      options,
                                    ),

                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    ),

                    Obx(() {
                      return _home.isNextEnabled
                          ? Padding(
                              padding:  EdgeInsets.symmetric(
                                horizontal: 30.w,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {
                                    LoadingBar.showLoaderDialog(
                                      context,
                                      "please wait saving....",
                                    );
                                   
                                    final List<int> idList = [];
                                    final List<String> valueList = [];
                                    final List<int> fieldIdList = [];

                                   
                                    final predefinedFields = [
                                      {
                                        'id': brandId,
                                        'value': brand,
                                        'fieldId': fieldId1,
                                      },
                                      {
                                        'id': modelId,
                                        'value': model,
                                        'fieldId': fieldId2,
                                      },
                                      {
                                        'id': colorId,
                                        'value': color,
                                        'fieldId': fieldId3,
                                      },
                                      {
                                        'id': yearId,
                                        'value': year,
                                        'fieldId': fieldId4,
                                      },
                                      {
                                        'id': priceId,
                                        'value': price,
                                        'fieldId': fieldId5,
                                      },
                                      {
                                        'id': axleId,
                                        'value': axle,
                                        'fieldId': fieldId7,
                                      },
                                      {
                                        'id': gvvrId,
                                        'value': gvvr,
                                        'fieldId': fieldId6,
                                      },
                                    ];

                                    for (var field in predefinedFields) {
                                      if (field['id'] != null &&
                                          field['value'] != null &&
                                          field['fieldId'] != null) {
                                        idList.add(field['id'] as int);
                                        valueList.add(field['value'] as String);
                                        fieldIdList.add(
                                          field['fieldId'] as int,
                                        );
                                      }
                                    }

                                    
                                    for (var field
                                        in _home.remainingFieldsList) {
                                      final fieldId = field.fieldId!;
                                      final selectedValue =
                                          _home.selectedValues[fieldId];

                                      if (field.options != null &&
                                          field.options!.isNotEmpty) {
                                        Option? option;
                                        if (selectedValue != null) {
                                          option = field.options!.firstWhere(
                                            (opt) =>
                                                opt.optionValue ==
                                                selectedValue,
                                            orElse: () => field.options!.first,
                                          );
                                        }

                                        idList.add(option?.id ?? 0);
                                        valueList.add(
                                          option?.optionValue ??
                                              selectedValue ??
                                              "",
                                        );
                                        fieldIdList.add(fieldId);
                                      } else if (_home.enteredValues[fieldId] !=
                                          null) {
                                       
                                        idList.add(0);
                                        valueList.add(
                                          _home.enteredValues[fieldId]!,
                                        );
                                        fieldIdList.add(fieldId);
                                      }
                                    }

                                    print("ID List: $idList");
                                    print("Value List: $valueList");
                                    print("Field ID List: $fieldIdList");

                                    var repo = await ApiRepository.saveTruck(
                                      catId: catId,
                                      subCatId: subCat,
                                      desc: "",
                                      formId: idList,
                                      formValue: valueList,
                                      fieldId: fieldIdList,
                                    );
                                    if (repo.status == true) {
                                      print("TRUCK ID ${repo.id}");
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                        createRoute(
                                          DescriptionScreen(
                                            truckId: int.parse(
                                              repo.id.toString(),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    "Next",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
      ),
    );
  }

  /// PRICE / TEXT FIELD TYPE
  Widget _priceInput(isTablet,int fieldId, String? label) {
    
    final TextEditingController tc = TextEditingController(
      text: _home.enteredValues[fieldId] ?? "",
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: tc,
                  cursorColor: AppColors.hintTxtColor,
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize:isTablet?8.sp: 14,
                  ),
                  onChanged: (value) {
                    _home.enteredValues[int.parse(fieldId.toString())] =
                        value; // save live
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
                    hintText: "Enter ${label ?? "value"}",
                    hintStyle: GoogleFonts.poppins(
                      color: AppColors.hintTxtColor,
                      fontWeight: FontWeight.w600,
                      fontSize:isTablet?8.sp: 12,
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
                    _home.showPriceFields[int.parse(fieldId.toString())] = true;
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.poppins(
                      fontSize:isTablet?8.sp: 12.sp,
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
          if (_home.showPriceFields[fieldId] == true &&
              (_home.enteredValues[fieldId]?.trim().isNotEmpty ?? false)) {
            return Text(
              "Entered: ${_home.enteredValues[fieldId]}",
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

  /// LIST SELECTION TYPE (> 2 options)
  Widget _listSelection(isTablet,int fieldId, List<dynamic> options) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (context, idx) {
        final option = options[idx];
        return Obx(() {
          final isSelected =
              _home.selectedValues[fieldId] == option.optionValue;
          return InkWell(
            onTap: () {
              _home.selectedValues[fieldId] = option.optionValue;
            },
            child: Card(
              elevation: 1.5,
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
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option.optionValue ?? "Unknown",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primaryColor,
                        size: 18,
                      ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  /// GRID SELECTION TYPE (<= 3 options)
    /// GRID SELECTION TYPE (<= 3 options)
  Widget _gridSelection(isTablet,int fieldId, List<dynamic> options) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:isTablet?5: options.length > 2 ? 3 : 2,
        childAspectRatio:isTablet?2.6: options.length > 2 ? 2.8 : 3.5, // balanced look
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, i) {
        final option = options[i];
        return Obx(() {
          final isSelected =
              _home.selectedValues[fieldId] == option.optionValue;
          return InkWell(
            onTap: () {
              _home.selectedValues[fieldId] = option.optionValue;
            },
            child: Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.grey.shade300,
                  width: isSelected ? 1.5 : 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  option.optionValue ?? "Unknown",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

}
