import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/sell/model_screen.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/route.dart';

class ScreenFirst extends StatelessWidget {
  const ScreenFirst({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    // final TextEditingController tc = TextEditingController();

    return Obx(() {
      if (homeController.selectedCatId.value == 0) {
        return const Center(child: Text("Please select a category first!"));
      }
      if (homeController.isForm.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (homeController.brandList.isEmpty) {
        return const Center(child: Text("Please select a category first!"));
      }

      final options = homeController.brandList.first.options ?? [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            homeController.brandList.first.fieldLabel ?? "",
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10, top: 8),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected =
                    homeController.selectedBrandIndex.value == index;

                return GestureDetector(
                  onTap: () {
                    homeController.selectedBrandIndex.value = index;
                  },
                  child: Card(
                    elevation: isSelected ? 4 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 0.5,
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        option.optionValue ?? "Unknown",
                        style: GoogleFonts.inter(fontSize: 14.sp),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: AppColors.primaryColor,
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          // homeController.brandList.first.isOptional == 1
          //           ? SizedBox(
          //               height: 40,
          //               child: Row(
          //                 children: [
          //                   Expanded(
          //                     child: TextFormField(
          //                       controller: tc,
          //                       cursorColor: AppColors.hintTxtColor,
          //                       style: GoogleFonts.inter(
          //                         color: AppColors.black,
          //                         fontWeight: FontWeight.w600,
          //                         fontSize: 14,
          //                       ),
          //                       decoration: InputDecoration(
          //                         isDense: true,
          //                         contentPadding: const EdgeInsets.symmetric(
          //                           horizontal: 12,
          //                           vertical: 10,
          //                         ),
          //                         border: OutlineInputBorder(
          //                           borderRadius: BorderRadius.circular(12.0),
          //                         ),
          //                         enabledBorder: OutlineInputBorder(
          //                           borderRadius: BorderRadius.circular(12.0),
          //                           borderSide: BorderSide(
          //                             color: AppColors.hintTxtColor,
          //                           ),
          //                         ),
          //                         focusedBorder: OutlineInputBorder(
          //                           borderRadius: BorderRadius.circular(12.0),
          //                           borderSide: BorderSide(
          //                             color: AppColors.indicatorColor,
          //                             width: 1.0,
          //                           ),
          //                         ),
          //                         hintText:
          //                             "Enter ${homeController.brandList.first.fieldLabel}",
          //                         hintStyle: GoogleFonts.poppins(
          //                           color: AppColors.hintTxtColor,
          //                           fontWeight: FontWeight.w600,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                   const SizedBox(width: 12),
          //                   SizedBox(
          //                     width: 90.w,
          //                     child: ElevatedButton(
          //                       style: ElevatedButton.styleFrom(
          //                         backgroundColor: AppColors.primaryColor,
          //                         padding: const EdgeInsets.symmetric(
          //                           vertical: 10,
          //                         ),
          //                         shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(12),
          //                         ),
          //                       ),
          //                       onPressed: () {},
          //                       child: Text(
          //                         "Submit",
          //                         style: GoogleFonts.poppins(
          //                           fontSize: 12.sp,
          //                           fontWeight: FontWeight.w600,
          //                           color: AppColors.white,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             )
          //           : const Spacer(),
          const SizedBox(height: 10),
          if (homeController.selectedBrandIndex.value != -1 &&
              homeController.selectedBrandIndex.value < options.length)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final selectedBrand =
                        options[homeController.selectedBrandIndex.value]
                            .optionValue;
                            final selectedBrandId =
                        options[homeController.selectedBrandIndex.value]
                            .id;
                    final selectedCatId = homeController.selectedCatId.value;
                    final selectedSubCatId =
                        homeController.selectedSubCatId.value;

                        print("FormID ${homeController.brandList.first.fieldId}");
                    Navigator.of(context).push(
                      createRoute(
                        ModelList(
                          brandName: selectedBrand,
                          catId: selectedCatId,
                          subCat: selectedSubCatId,
                          brandId: selectedBrandId,
                          fieldId1: homeController.brandList.first.fieldId,
                        ),

                      ),
                    );
                    homeController.selectedBrandIndex.value = -1;
                  },
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
        ],
      );
    });
  }
}
