import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/service/api_url.dart';
import 'package:truck_market_place/service/controller/other_controller.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/loading_bar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final OtherController _otherController = Get.find();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  File? _pickedImage;
  late final Color avatarColor;

  @override
  void initState() {
    super.initState();
    avatarColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    final profile = _otherController.userProfile.value;
if (profile != null) {
      _nameController.text = profile.name ?? "";
      _mobileController.text = profile.mobileNumber ?? "";
    }
   

  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final userImagePath = _pickedImage?.path;

    if (name.isEmpty || mobile.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    LoadingBar.showLoaderDialog(context, "Updating...");

    final result = await ApiRepository.updateProfile(
      name: name,
      mobileNumber: mobile,
      userImagePath: userImagePath,
    );

    Navigator.pop(context); 

    if (result.status == true) {
      Get.snackbar("Success", "Profile updated successfully");

      await _otherController.fetchUserProfile(); 

      Get.back(); 
      Navigator.of(context).pop();
      
    } else {
      Get.snackbar("Error", result.message ?? "Failed to update profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.appBar,
        elevation: 0,
      ),
      body: Obx(() {
        if (_otherController.isProfile.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = _otherController.userProfile.value;
        if (profile == null) {
          return Center(
            child: Text(
              _otherController.errorMessage.value.isNotEmpty
                  ? _otherController.errorMessage.value
                  : "No profile data available",
              style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey),
            ),
          );
        }

        final String name = profile.name ?? "N/A";
        final String email = profile.email ?? "N/A";
        final String mobile = profile.mobileNumber ?? "N/A";
        final String? profileImageUrl = profile.userImage;
        final String initials = (name.isNotEmpty ? name[0] : "U").toUpperCase();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: (_pickedImage == null &&
                                (profileImageUrl == null ||
                                    profileImageUrl.isEmpty))
                            ? avatarColor
                            : Colors.transparent,
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : (profileImageUrl != null &&
                                    profileImageUrl.isNotEmpty)
                                ? NetworkImage(ApiEndPoints.imgUrl +profileImageUrl)
                                : null as ImageProvider<Object>?,
                        child: (_pickedImage == null &&
                                (profileImageUrl == null ||
                                    profileImageUrl.isEmpty))
                            ? Text(
                                initials,
                                style: GoogleFonts.poppins(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(6.r),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              _formField("Full Name", _nameController, hint: "Enter your full name"),
              SizedBox(height: 16.h),
              _formField("Mobile Number", _mobileController,
                  hint: "Enter mobile number", keyboardType: TextInputType.phone),
              SizedBox(height: 16.h),
              _emailField("Email", email),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Expanded(
                    child: _actionButton("Cancel", AppColors.dotColor, Colors.white,
                        () {
                      Navigator.pop(context);
                    }),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _actionButton("Update", AppColors.primaryColor, Colors.white,
                        _updateProfile),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _formField(String label, TextEditingController controller,
      {String? hint, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
            filled: true,
            fillColor: AppColors.bottomWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emailField(String label, String emailText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )),
        SizedBox(height: 6.h),
        TextField(
          controller: TextEditingController(text: emailText),
          enabled: false,
          style: GoogleFonts.poppins(color: Colors.grey.shade600),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.bottomWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(
      String text, Color bgColor, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: bgColor,
        ),
        child: Center(
          child: Text(text,
              style: GoogleFonts.poppins(
                  fontSize: 14.sp, fontWeight: FontWeight.w600, color: textColor)),
        ),
      ),
    );
  }
}
