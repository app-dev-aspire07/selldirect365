import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/service/api_url.dart';
import 'package:truck_market_place/service/controller/other_controller.dart';
import 'package:truck_market_place/views/detailed_screens/truck_details.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/route.dart';
import 'package:truck_market_place/widget/shimmer_card.dart';
import 'package:truck_market_place/widget/show_popUp.dart';

class SentQuote extends StatelessWidget {
  SentQuote({super.key});

  final OtherController _otherController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _otherController.isQuotes.value
            ? ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const FavouriteShimmerCard();
                },
              )
            : _otherController.getMyQuoteList.isEmpty
            ? Center(child: Text("No Data Found"))
            : Column(
                children: [
                  SizedBox(height: 10.h),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _otherController.getMyQuoteList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                createRoute(
                                  TruckDetails(
                                    name:
                                        "${_otherController.getMyQuoteList[index].year} ${_otherController.getMyQuoteList[index].brand} ${_otherController.getMyQuoteList[index].model}",
                                    id: _otherController
                                        .getMyQuoteList[index]
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
                                                      .getMyQuoteList[index]
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
                                              " ${_otherController.getMyQuoteList[index].year ?? _otherController.getMyQuoteList[index].year} ${_otherController.getMyQuoteList[index].brand} ${_otherController.getMyQuoteList[index].model} ",
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
                                                          .getMyQuoteList[index]
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
                                                    "${_otherController.getMyQuoteList[index].address}",
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
                                                " ${_otherController.getMyQuoteList[index].desc ?? ""}",
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
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () async {
                                          ShowDialog.showConfirmUp(context, title: "Are you sure you want to remove this quote?", onTap: () async{
                                            var repo =
                                              await ApiRepository.deleteQuote(
                                                truckId: _otherController
                                                    .getMyQuoteList[index]
                                                    .truckFormId,
                                              );
                                              if(repo.status == true){
                                                await _otherController.fetchQuotes();
                                              }
                                          });
                                          
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right: 12.sp,
                                          ),
                                          child: Text(
                                            "Remove Quote",
                                            style: GoogleFonts.inter(
                                              fontSize: 12.sp,

                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
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
}
