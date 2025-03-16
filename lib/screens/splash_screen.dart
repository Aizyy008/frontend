import "dart:async";
import "package:user_subscription_management/controllers/profile_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:user_subscription_management/utils/colors_util.dart";
import "package:http/http.dart" as http;
import "../components/bottom_nav_bar.dart";
import "../controllers/profile_controller.dart";
import "../utils/screen_util.dart";
import "login_screen.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();
final profileController = ProfileController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.checkJwtToken(context);
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenUtils(context);
    return Scaffold(
      backgroundColor: ColorConverter.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.subscriptions, color: ColorConverter.white,size: 30,),
              SizedBox(width: screenSize.width * 0.03,),
              Text("SubscriEase",  style: TextStyle(
                  color: ColorConverter.white,
                  fontWeight: FontWeight.w600,
                fontSize: 35
              ),),
            ],
          ),
          SizedBox(height: screenSize.height * 0.02,),
          Text("Manage Subscriptions, Effortlessly!",  style: TextStyle(
              color: ColorConverter.white,
              fontWeight: FontWeight.w400,
          ),),
        ],
      ),
    );
  }
}
