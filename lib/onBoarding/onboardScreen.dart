
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:truck_market_place/Auth/sign_in.dart';
import 'package:truck_market_place/Auth/sign_up.dart';
import 'package:truck_market_place/onBoarding/screenFirst.dart';
import 'package:truck_market_place/onBoarding/screenThird.dart';
import 'package:truck_market_place/onBoarding/secondScreen.dart';
import 'package:truck_market_place/widget/colors.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/route.dart';



class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int index = 0;
  final PageController _controller = PageController();
  List<Widget> pageList = [
    Center(
      child: ScreenFirst(),
    ),
    Center(
      child: ScreenSecond(),
    ),
    Center(
      child: ScreenThird(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (num) {
                setState(() {
                  index = num;
                });
              },
              children: pageList,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: AppDimentions.pxh100),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  index == 2 ? "Welcome, let’s get started!" : "",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: AppDimentions.sp16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: AppDimentions.pxh_20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        index == 0
                            ?
                            // _controller.animateToPage(2,
                            //     duration: Duration(milliseconds: 400),
                            //     curve: Curves.easeIn)
      
                            Navigator.of(context).pushAndRemoveUntil(
                                createRoute(SignIn()), (route) => false)
                            : index == 1
                                ? _controller.animateToPage(
                                    _controller.page!.toInt() - 1,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeIn)
                                : Navigator.of(context)
                                    .push(createRoute(SignIn()));
                      },
                      child: Container(
                        width: AppDimentions.pxw149,
                        height: AppDimentions.pxh_45,
                        decoration: BoxDecoration(
                          color: index == 0
                              ? AppColors.darkWhite
                              : index == 1
                                  ? AppColors.darkWhite
                                  : AppColors.light,
                          border: Border.all(
                              width: AppDimentions.px_1,
                              color: AppColors.secondary),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            index == 0
                                ? "Skip"
                                : index == 1
                                    ? "Back"
                                    : "Log in",
                            style: GoogleFonts.poppins(
                                color: AppColors.black,
                                fontSize: AppDimentions.sp14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        index == 0
                            ? _controller.animateToPage(
                                _controller.page!.toInt() + 1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeIn)
                            : index == 1
                                ? _controller.animateToPage(
                                    _controller.page!.toInt() + 1,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeIn)
                                : Navigator.of(context)
                                    .push(createRoute(SignUp()));
                      },
                      child: Container(
                        width: AppDimentions.pxw149,
                        height: AppDimentions.pxh_45,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          border: Border.all(
                              width: AppDimentions.px_1,
                              color: AppColors.secondary),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            index == 0
                                ? "Next"
                                : index == 1
                                    ? "Next"
                                    : "Sign up",
                            style: GoogleFonts.poppins(
                                color: AppColors.white,
                                fontSize: AppDimentions.sp14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppDimentions.pxw149,
              right: AppDimentions.pxw149,
              bottom: AppDimentions.pxh170,
              child: AnimatedSmoothIndicator(
                activeIndex: index,
                count: 3,
                effect: ExpandingDotsEffect(
                    dotHeight: AppDimentions.pxh_5,
                    dotWidth: AppDimentions.pxw10,
                    dotColor: AppColors.dotColor,
                    activeDotColor: AppColors.indicatorColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  void nextPage() {
    _controller.animateToPage(_controller.page!.toInt() + 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage() {
    _controller.animateToPage(_controller.page!.toInt() - 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void skipPage() {
    _controller.animateToPage(2,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }
}
