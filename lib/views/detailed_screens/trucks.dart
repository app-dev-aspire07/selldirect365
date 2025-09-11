import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:truck_market_place/app_utils/search_screen.dart';
import 'package:truck_market_place/model/Truck_Model/get_truck_model.dart';
import 'package:truck_market_place/service/api_url.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/detailed_screens/filtered_list.dart';
import 'package:truck_market_place/views/detailed_screens/truck_details.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/route.dart';

class ViewAllTrucks extends StatefulWidget {
  ViewAllTrucks({super.key});

  @override
  State<ViewAllTrucks> createState() => _ViewAllTrucksState();
}

class _ViewAllTrucksState extends State<ViewAllTrucks> {
  final HomeController _homeController = Get.find();

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  
  loadData() async {
    await _homeController.fetchTrucks();
    setState(() {
      _filteredList = _homeController.getTruckList; 
    });
  }
void filterTrucks(Map<String, dynamic> filters) {
  List<Datum> filtered = List.from(_homeController.getTruckList);

  // multiple brands
  if (filters["brands"] != null && (filters["brands"] as List).isNotEmpty) {
    filtered = filtered.where((t) => filters["brands"].contains(t.brand)).toList();
  }

  // multiple models
  if (filters["models"] != null && (filters["models"] as List).isNotEmpty) {
    filtered = filtered.where((t) => filters["models"].contains(t.model)).toList();
  }

  // multiple colors
  if (filters["colors"] != null && (filters["colors"] as List).isNotEmpty) {
    filtered = filtered.where((t) => filters["colors"].contains(t.color)).toList();
  }

  // price sort
  if (filters["priceSort"] == "lowToHigh") {
    filtered.sort((a, b) => double.parse(b.price ?? "0").compareTo(double.parse(a.price ?? "0")));
  } else if (filters["priceSort"] == "highToLow") {
    filtered.sort((a, b) => double.parse(a.price ?? "0").compareTo(double.parse(b.price ?? "0")));
  }

  setState(() {
    _filteredList = filtered;
  });
}

List<Datum> _filteredList = [];
  @override
  Widget build(BuildContext context) {
    final trucks = _filteredList.isNotEmpty ? _filteredList : _homeController.getTruckList;
final reversedTrucks = trucks.reversed.toList();

    return Scaffold(
      appBar: mainAppBar(context, title: "Equipments",  actions: [
          IconButton(
            icon: Icon(Icons.sort_sharp, color: AppColors.white),
            onPressed: () {
         Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          brands: _homeController.getTruckList.map((e) => e.brand ?? "").toSet().toList(),
          models: _homeController.getTruckList.map((e) => e.model ?? "").toSet().toList(),
          colors: _homeController.getTruckList.map((e) => e.color ?? "").toSet().toList(),
          onApply: filterTrucks,
        ),
      ),
    );
      },
          ),
        ],),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(height: 40.h, child: _textFormField(_controller)),
          ),
          SizedBox(height: 10.h),

          Obx(
            () => _homeController.isTrucks.value
                ? Expanded(child: truckShimmer())
                : _homeController.getTruckList.isEmpty
                ? Expanded(
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
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: reversedTrucks.length,
                      itemBuilder: (context, index) {
                        final truck =
                            reversedTrucks[index]; 
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                createRoute(
                                  TruckDetails(
                                    name:
                                        "${truck.year} ${truck.brand} ${truck.model}",
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
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft: Radius.circular(
                                                    10,
                                                  ),
                                                ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  ApiEndPoints.imgUrl +
                                                  truck.images!.first,
                                              fit: BoxFit.cover,
                                              height: 100.h,
                                              width: 130.w,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${truck.color != null ? truck.color : truck.year} ${truck.brand} ${truck.model}",
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
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  color: AppColors.primaryColor,
                                                  size: 13.sp,
                                                ),
                                                SizedBox(width: 4.w),
                                                SizedBox(
                                                  width: Get.width * 0.55,
                                                  child: Text(
                                                    truck.address ?? "",
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
                                                truck.desc ?? "",
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
          ),
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
        readOnly: true, // 👈 important
    onTap: () {
      Navigator.of(context).push(createRoute(SearchScreen()));
    },
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
}
class Truck {
  final String brand;
  final String model;
  final String color;
  final double price;

  Truck({
    required this.brand,
    required this.model,
    required this.color,
    required this.price,
  });
}