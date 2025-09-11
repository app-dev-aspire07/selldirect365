
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';

class LoadingBar {
  static showLoaderDialog(BuildContext context, String text) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.indicatorColor),
          ),
          Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 10), child: Text(text))),
        ],
      ),
    );
    showDialog(
      useRootNavigator: false,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showStackLoader(BuildContext context, String text) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.indicatorColor),
          ),
          Container(
              height: Get.height,
              color: Colors.transparent,
              margin: const EdgeInsets.only(left: 10),
              child: Text(text)),
        ],
      ),
    );
    showDialog(
      useRootNavigator: false,
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class LoadNetworkImage extends StatelessWidget {
  final String imageUrl;
  final circularRadius;
  final double? height;
  final double? width;
  //final Color color;

  const LoadNetworkImage(
      {super.key, required this.imageUrl,
      this.circularRadius,
      //   required this.color,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    //print("LoadNetworkImageURL>> $imageUrl");
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(circularRadius ?? 0.0)),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularRadius ?? 0.0)),
          //shape: BoxShape.circle
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          height: height,
          width: width,
          placeholder: (context, url) => Center(
            child: SizedBox(
              height: AppDimentions.pxh_20,
              child: FittedBox(
                fit: BoxFit.cover,
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                  backgroundColor: AppColors.inactiveIcons,
                  color: AppColors.indicatorColor,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) =>
              // Icon(Icons.error),
              Image.asset('assets/dummyImg.jpg'),
        ),
      ),
    );
  }
}
