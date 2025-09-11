import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/views/sell/document_upload.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/route.dart';

class ImageUpload extends StatefulWidget {
  final int? truckId;
  const ImageUpload({super.key, this.truckId});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  double _uploadProgress = 0.0; // Track upload percentage
  bool _isUploading = false; // Track uploading state

  /// Function to pick image
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
    Navigator.pop(context);
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.appBar),
                title: const Text("Capture from Camera"),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo, color: AppColors.appBar),
                title: const Text("Select from Gallery"),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImages() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    var repo = await ApiRepository.saveImages(
      id: widget.truckId,
      img: _images.map((e) => e.path).toList(),
      onProgress: (sent, total) {
        setState(() {
          _uploadProgress = sent / total;
        });
      },
    );

    setState(() {
      _isUploading = false;
    });

    if (repo.status == true) {
      Navigator.of(context).push(createRoute( DocumentUpload(truckId: widget.truckId,)));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Image upload failed, try again.")),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context, title: "Upload Images"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: _images.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  if (index == _images.length) {
                    // Add new image button
                    return GestureDetector(
                      onTap: _showImageSourceOptions,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.add, size: 40, color: Colors.grey),
                        ),
                      ),
                    );
                  } else {
                    // Show selected image
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _images[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _images.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black54,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.white,
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _images.isEmpty || _isUploading
                      ? null
                      : _uploadImages,
                  child: _isUploading
                      ? TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: _uploadProgress,
                          ),
                          duration: const Duration(milliseconds: 400),
                          builder: (context, value, _) => Text(
                            "${(value * 100).toStringAsFixed(0)} % UPLOADED",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        )
                      : Text(
                          "UPLOAD",
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
            ),
            if (_isUploading)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: _uploadProgress),
                  duration: const Duration(
                    milliseconds: 400,
                  ), // smooth animation
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey[300],
                    color: AppColors.primaryColor,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
