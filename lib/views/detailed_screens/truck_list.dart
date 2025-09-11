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
import 'package:truck_market_place/widget/common_list_model.dart';
import 'package:truck_market_place/widget/route.dart';

class TruckList extends StatefulWidget {
  final String? name;
  final int? id;
  const TruckList({super.key, this.name, this.id});

  @override
  State<TruckList> createState() => _TruckListState();
}

class _TruckListState extends State<TruckList> {
  final TextEditingController _controller = TextEditingController();
  final HomeController _homeController = Get.find();

  // ✅ Filtered list
  final RxList filteredTruckList = [].obs;

  @override
  void initState() {
    super.initState();
    _homeController.fetchTrucksByModel(id: widget.id).then((_) {
      filteredTruckList.assignAll(_homeController.getTruckModelList);
    });

    _controller.addListener(() {
      filterTrucks(_controller.text.trim());
    });
  }

  void filterTrucks(String query) async {

  _homeController.isModelTruck.value = true;

  
  await Future.delayed(const Duration(milliseconds: 400));

  if (query.isEmpty) {
    filteredTruckList.assignAll(_homeController.getTruckModelList);
  } else {
    filteredTruckList.assignAll(
      _homeController.getTruckModelList.where((truck) {
        final title =
            "${truck.year ?? ""} ${truck.brand ?? ""} ${truck.model ?? ""}".toLowerCase();
        final address = (truck.address ?? "").toLowerCase();
        final desc = (truck.desc ?? "").toLowerCase();
        final q = query.toLowerCase();

        return title.contains(q) || address.contains(q) || desc.contains(q);
      }).toList(),
    );
  }

  
  _homeController.isModelTruck.value = false;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(
        context,
        title: widget.name,
      
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(height: 40.h, child: _textFormField(_controller)),
          ),
          SizedBox(height: 10.h),

          // ✅ ListView with filtered list
          Obx(() {
            if (_homeController.isModelTruck.value) {
              return Expanded(child: truckShimmer());
            }

            if (filteredTruckList.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    "No Data Found",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.appBar,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredTruckList.length,
                itemBuilder: (context, index) {
                  final truck = filteredTruckList[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          createRoute(
                            TruckDetails(
                              name: "${truck.year} ${truck.brand} ${truck.model}",
                              id: truck.truckFormId,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 130.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: ApiEndPoints.imgUrl +
                                      truck.images!.first,
                                  fit: BoxFit.cover,
                                  height: 100.h,
                                  width: 130.w,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${truck.year} ${truck.brand} ${truck.model}",
                                      style: GoogleFonts.inter(
                                        fontSize: 13.sp,
                                        color: AppColors.indicatorColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Row(
                                      children: [
                                        Icon(Icons.attach_money_outlined,
                                            color: AppColors.primaryColor,
                                            size: 15.sp),
                                        Text(
                                          truck.price ?? "",
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
                                        Icon(Icons.location_on_outlined,
                                            color: AppColors.primaryColor,
                                            size: 13.sp),
                                        SizedBox(width: 4.w),
                                        Expanded(
                                          child: Text(
                                            truck.address ?? "",
                                            style: GoogleFonts.inter(
                                              fontSize: 10.sp,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.normal,
                                              height: 1.2,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      truck.desc ?? "",
                                      style: GoogleFonts.inter(
                                        fontSize: 10.sp,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }



  Widget truckShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  TextFormField _textFormField(TextEditingController? controller) =>
      TextFormField(
        controller: controller,
        cursorColor: AppColors.hintTxtColor,
        style: GoogleFonts.inter(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: AppColors.hintTxtColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: AppColors.hintTxtColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: AppColors.indicatorColor, width: 1.0),
          ),
          hint: Text("Search any keyword"),
          hintStyle: GoogleFonts.poppins(
            color: AppColors.hintTxtColor,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.indicatorColor),
        ),
      );

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
