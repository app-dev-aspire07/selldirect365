// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truck_market_place/onBoarding/onboardScreen.dart';
import 'package:truck_market_place/views/bottom_nav.dart';
import 'package:truck_market_place/widget/dimensions.dart';
import 'package:truck_market_place/widget/route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _fabAnimation;
  String? token;
  bool _showText = false;

 
 
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fabAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller?.forward();
    _controller?.addListener(() {
      setState(() {});
    });

    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _showText = true;
      });
    });

    Future.delayed(Duration(seconds: 3)).then((value) async {
      await autoLogin();
    });
  }

  autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    if (token != null) {
      print(token);
     
      await Navigator.of(context).pushAndRemoveUntil(
          createRoute(BottomNav(currentIndexx: 0)), (route) => false);
    } else {
    await Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => OnboardScreen(),
      ),
      (route) => false,
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(
          // color: AppColors.bottomWhite,
          // gradient: LinearGradient(
          //   colors: [
          //     AppColors.splashNew1,
          //     AppColors.splashNew2,
          //     AppColors.splashNew3,
          //     AppColors.splashNew4,
          //   ],
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: _fabAnimation?.value,
              child: Center(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/app_logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
           
            AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration: Duration(milliseconds: 800),
              child: Text(
                "Your Trusted Marketplace for Trucks",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: AppDimentions.sp16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            Align(
              alignment: Alignment.bottomRight,
              child: AnimatedOpacity(
                opacity: _showText ? 1.0 : 0.0,
                duration: Duration(milliseconds: 800),
                child: Text(
                  "Buy, Sell, Move – All in One Place.",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: AppDimentions.sp12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
