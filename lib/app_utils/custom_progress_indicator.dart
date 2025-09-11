import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:truck_market_place/widget/colors.dart';


// ignore: must_be_immutable
class CommmonProgressIndicator extends StatelessWidget {
  bool isLoading = false;

  CommmonProgressIndicator({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitDualRing(
      color: AppColors.primaryColor,
    );
    return isLoading
        ? Opacity(
            opacity: isLoading ? 1.0 : 0,
            child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                color: Colors.white.withOpacity(0.2),
                child: isLoading
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: spinkit)
                    : Container()),
          )
        : SizedBox(
            height: 0.0,
            width: 0.0,
          );
  }
}

final BehaviorSubject<bool> progressSink = BehaviorSubject<bool>();

Stream<bool> get progressStream => progressSink.stream;

void showLoader() {
  progressSink.sink.add(true);
}

customProgressDialog({
  required BuildContext context,
}) {
  return StreamBuilder<bool>(
      stream: progressStream,
      initialData: false,
      builder: (context, snapshot) {
        return CommmonProgressIndicator(
          isLoading: snapshot.data!,
        );
      });
}

void hideLoader() {
  progressSink.sink.add(false);
}
