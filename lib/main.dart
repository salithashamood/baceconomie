import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/screens/splash_screen.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initialize();
  setUp();
  defaultRadius = 12.0;
  defaultAppButtonRadius = 12.0;
  setOrientationPortrait();
  final appStore = locator.get<AppStore>();
  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
  if (appStore.isLoggedIn) {
    appStore.setUserId(getStringAsync(USER_ID));
    appStore.setName(getStringAsync(USER_DISPLAY_NAME));
    appStore.setUserEmail(getStringAsync(USER_EMAIL));
    appStore.setProfileImage(getStringAsync(USER_PHOTO_URL));
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Economie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const Center(
      //   child: Text("Grile drept"),
      // ),
      home: SplashScreen(),
    );
  }
}
