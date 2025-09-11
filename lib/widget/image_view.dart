import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:truck_market_place/service/api_url.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final bool isNetwork; // ✅ decide karega ki Asset hai ya Network

  const FullScreenImageViewer({
    super.key,
    required this.imagePaths,
    required this.initialIndex,
    this.isNetwork = true,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  ImageProvider _getImageProvider(String path) {
    if (widget.isNetwork) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            /// Fullscreen Gallery
            PhotoViewGallery.builder(
              itemCount: widget.imagePaths.length,
              pageController: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: _getImageProvider( ApiEndPoints.imgUrl +widget.imagePaths[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2.5,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.imagePaths[index],
                  ),
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),

            /// Close Button
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            /// Bottom Thumbnails
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.imagePaths.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: currentIndex == index
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.isNetwork
                              ? Image.network(
                                 ApiEndPoints.imgUrl + widget.imagePaths[index],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  widget.imagePaths[index],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
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
      ),
    );
  }
}
