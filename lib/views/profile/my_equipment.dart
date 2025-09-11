import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/service/api_url.dart';
import 'package:truck_market_place/service/controller/other_controller.dart';
import 'package:truck_market_place/views/detailed_screens/truck_details.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/common_list_model.dart';
import 'package:truck_market_place/widget/route.dart';
import 'package:truck_market_place/widget/shimmer_card.dart';

class MyEquipments extends StatelessWidget {
   MyEquipments({super.key});
final OtherController _otherController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Obx(
        () => _otherController.isMyEquioment.value
            ? ListView.builder(
                itemCount: 5, 
                itemBuilder: (context, index) {
                  return const FavouriteShimmerCard();
                },
              )
            : _otherController.getMyEquimentList.isEmpty
            ? Center(child: Text("No Data Found"))
            : Column(
                children: [
                  SizedBox(height: 10.h),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _otherController.getMyEquimentList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                createRoute(
                                  TruckDetails(
                                    name:
                                        "${_otherController.getMyEquimentList[index].year} ${_otherController.getMyEquimentList[index].brand} ${_otherController.getMyEquimentList[index].model}",
                                    id: _otherController
                                        .getMyEquimentList[index]
                                        .truckFormId,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 130.w,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  ApiEndPoints.imgUrl +
                                                  _otherController
                                                      .getMyEquimentList[index]
                                                      .images!
                                                      .first,
                                              fit: BoxFit.cover,
                                              height: 100.h,
                                              width: 130.w,
                                              placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              " ${_otherController.getMyEquimentList[index].year ?? _otherController.getMyEquimentList[index].year} ${_otherController.getMyEquimentList[index].brand} ${_otherController.getMyEquimentList[index].model} ",
                                              style: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                color: AppColors.indicatorColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.attach_money_outlined,
                                                  color: AppColors.primaryColor,
                                                  size: 15.sp,
                                                  blendMode: BlendMode.darken,
                                                ),
                                                Text(
                                                  _otherController
                                                          .getMyEquimentList[index]
                                                          .price ??
                                                      "",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12.sp,
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0.9,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4.h),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  color: AppColors.primaryColor,
                                                  size: 13.sp,
                                                ),
                                                SizedBox(width: 4.w),
                                                SizedBox(
                                                  width: Get.width * 0.55,
                                                  child: Text(
                                                    "${_otherController.getMyEquimentList[index].address}",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.sp,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1.2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 4.h),
                                            SizedBox(
                                              width: Get.width * 0.58,
                                              child: Text(
                                                " ${_otherController.getMyEquimentList[index].desc ?? ""}",
                                                style: GoogleFonts.inter(
                                                  fontSize: 10.sp,

                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // SizedBox(height: 40.h,),
                ],
              ),
      ),
    
    );
  }
   final List<CommonTruckListItemModel> _truckList = [
    CommonTruckListItemModel(
      imageUrl: 'assets/trucks/truck1.jpeg',
      title: '2023 Kenworth T680',
      subtitle: '',
      distance: "125369",
      price: "25000",
    ),
    CommonTruckListItemModel(
      imageUrl: 'assets/trucks/truck2.jpg',
      title: '2020 Peterbilt Model 389',
      subtitle: '',
      distance: "8757654",
      price: "37065",
    ),
    CommonTruckListItemModel(
      imageUrl: 'assets/trucks/truck3.jpg',
      title: '2013 Frieghtliner Cascadia 125',
      subtitle: '',
      distance: "55469",
      price: "12000",
    ),
    CommonTruckListItemModel(
      imageUrl: 'assets/trucks/truck4.jpg',
      title: '2015 Western Star 4700 SF',
      subtitle: '',
      distance: "166000",
      price: "94000",
    ),
    CommonTruckListItemModel(
      imageUrl: 'assets/trucks/truck5.jpg',
      title: '2019 International IT',
      subtitle: '',
      distance: "613847",
      price: "85700",
    ),
    CommonTruckListItemModel(
      imageUrl: 'assets/trucks/truck7.jpg',
      title: '2022 Volvo VNL 860',
      subtitle: '',
      distance: "767662",
      price: "45500",
    ),
    
  ];
}