import 'package:flutter/material.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/screens/dash_board_screen.dart';
import 'package:baceconomie/screens/login_screen.dart';
import 'package:baceconomie/screens/walk_through_screen.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:baceconomie/utils/images.dart';
import 'package:baceconomie/utils/string.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    Future.delayed(
      Duration(seconds: 2),
      () {
        if (locator.get<AppStore>().isLoggedIn) {
          DashboardScreen().launch(context, isNewTask: true);
        } else {
          if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
            WalkThroughScreen().launch(context, isNewTask: true);
          } else {
            LoginScreen().launch(context, isNewTask: true);
          }
        }
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(appLogoImage, height: 150, width: 150),
            16.height,
            Text(lbl_online_quiz, style: boldTextStyle(size: 24)),
          ],
        ),
      ),
    );
  }
}
