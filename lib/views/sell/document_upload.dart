import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_market_place/app_utils/appUtils.dart';
import 'package:truck_market_place/service/api_calls.dart';
import 'package:truck_market_place/service/controller/home_controller.dart';
import 'package:truck_market_place/views/bottom_nav.dart';
import 'package:truck_market_place/views/profile/equipment_info.dart';
import 'package:truck_market_place/widget/app_bar.dart';
import 'package:truck_market_place/widget/colors.dart';

class DocumentUpload extends StatefulWidget {
  final int? truckId;
  const DocumentUpload({super.key, this.truckId});

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  final List<Map<String, dynamic>> _documents = [];
  final List<String> _categories = [
    "Insurance",
    "Damage Report",
    "Title Deed",
    "Other",
  ];
  String _selectedCategory = "Insurance";
  bool _isUploading = false;
  double _uploadProgress = 0.0; // 0 to 1.0
final HomeController _homeController = Get.find();
  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf", "doc", "docx", "jpg", "png"],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _documents.add({
          "file": File(result.files.single.path!),
          "category": _selectedCategory,
        });
      });
    }
  }

  Future<void> _uploadAllDocuments({int? id}) async {
    if (_documents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one document")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      // Extract all file paths
      final List<String> filePaths = _documents
          .map((doc) => doc['file'].path as String)
          .toList();

      // Yaha tum ek hi type select karte ho
      final String category = _documents.first['category'] as String;

      var repo = await ApiRepository.saveDocuments(
        id: id,
        docs: filePaths,
        documentsType: category,
        onProgress: (sent, total) {
          if (total > 0) {
            setState(() {
              _uploadProgress = sent / total;
            });
          }
        },
      );

      if (repo.status == true) {
        _showSuccessPopup(context);
        // AppUtils.showSuccessMessage(context, message: "Documents uploaded successfully");
        setState(() {
          _documents.clear();
        });
      } else {
        AppUtils.showErrorMessage(
          context,
          message: "Document upload failed, please try again.",
        );
      }
    } catch (e) {
      debugPrint("Upload failed: $e");
      AppUtils.showErrorMessage(
        context,
        message: "Documents failed to upload. Please try again.",
      );
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context, title: "Document Upload"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Category",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            /// Add Document Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _pickDocument,
                icon: const Icon(Icons.upload_file, color: Colors.white),
                label: Text(
                  "Add Document",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Document List
            Expanded(
              child: _documents.isEmpty
                  ? const Center(
                      child: Text(
                        "No documents uploaded yet.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _documents.length,
                      itemBuilder: (context, index) {
                        final doc = _documents[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(
                              Icons.insert_drive_file,
                              color: Colors.blue,
                            ),
                            title: Text(
                              doc["file"].path.split('/').last,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(doc["category"]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _documents.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),

            /// Upload Button with Progress
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
                  onPressed: _documents.isEmpty || _isUploading
                      ? null
                      : () => _uploadAllDocuments(id: widget.truckId),
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
                  duration: const Duration(milliseconds: 400),
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

  void _showSuccessPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ), // frosted glass effect
          child: Center(
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: ModalRoute.of(context)!.animation!,
                curve: Curves.easeOutBack,
              ),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
                backgroundColor: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Get.offAll(() => BottomNav(currentIndexx: 0));
                          },
                        ),
                      ),

                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.asset(
                          "assets/icons/truck.gif",
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Listing Submitted 🚚",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // 📝 Message
                      Text(
                        "We’ll notify you once it’s approved.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 24),

                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () async{
                            Navigator.pop(context);
                            Get.offAll(() => BottomNav(currentIndexx: 0));
                            await _homeController.fetchTrucks();
                          },
                          child: Text(
                            "Go to Home",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            side: BorderSide(color: Colors.grey.shade400),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Get.offAll(
                              () => BottomNav(currentIndexx: 3),
                            );
                            Future.delayed(Duration(milliseconds: 200), () {
                             
                              Get.to(() => EquipmentInfo());
                            });
                          },
                          child: Text(
                            "View Profile",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
