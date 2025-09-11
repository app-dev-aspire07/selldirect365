import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:truck_market_place/app_utils/appUtils.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/views/sell/image_upload.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/loading_bar.dart';
import 'package:truck_market_place/widget/route.dart';

class DescriptionScreen extends StatefulWidget {
  final int? truckId;
  const DescriptionScreen({super.key, this.truckId});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late AnimationController _animationController;
  final int maxWords = 100;

  bool _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _getCurrentLocation(); 
  }

  @override
  void dispose() {
    _descController.dispose();
    _addressController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  int _wordCount(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppUtils.showErrorMessage(context,
            message: "Please enable location services.");
        setState(() => _isGettingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppUtils.showErrorMessage(context,
              message: "Location permission denied.");
          setState(() => _isGettingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppUtils.showErrorMessage(context,
            message:
                "Location permission is permanently denied. Please enable it from settings.");
        setState(() => _isGettingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String fullAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";

        _addressController.text = fullAddress;
      }
    } catch (e) {
      AppUtils.showErrorMessage(context,
          message: "Failed to get location: $e");
    }

    setState(() {
      _isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int words = _wordCount(_descController.text);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: mainAppBar(context, title: "Sell"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            
            Text(
              "Enter Address",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      maxLines: 3,
                      style:
                          GoogleFonts.poppins(fontSize: 16, height: 1.4),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter address...",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _isGettingLocation
                        ?  CircularProgressIndicator()
                        :  Icon(Icons.my_location,
                            color: AppColors.appBar),
                    onPressed: _isGettingLocation ? null : _getCurrentLocation,
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Description Section
            Text(
              "Add description",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _descController,
                  maxLines: null,
                  expands: true,
                  onChanged: (_) => setState(() {}),   
                  style: GoogleFonts.poppins(fontSize: 16, height: 1.4),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write something about equipment...",
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: words > maxWords ? Colors.red : AppColors.appBar,
                  fontWeight: words > maxWords
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
                child: Text("$words / $maxWords words"),
              ),
            ),
            const SizedBox(height: 20),

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: words > maxWords
                    ? null
                    : () async {
                        if (_addressController.text.trim().isEmpty) {
                          AppUtils.showErrorMessage(
                            context,
                            message: "Please enter address first.",
                          );
                          return;
                        }

                        LoadingBar.showLoaderDialog(
                          context,
                          "please wait...",
                        );

                        var repo = await ApiRepository.saveDesc(
                          truckId: widget.truckId,
                          desc: _descController.text,
                          address: _addressController.text,  
                        );

                        if (repo.status == true) {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            createRoute(
                              ImageUpload(truckId: widget.truckId),
                            ),
                          );
                        } else {
                          Navigator.of(context).pop();
                          AppUtils.showErrorMessage(
                            context,
                            message:
                                "Something went wrong, please try again later.",
                          );
                        }
                      },
                child: Text(
                  "Next".toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
