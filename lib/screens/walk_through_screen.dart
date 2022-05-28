import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:baceconomie/models/drawer_item_model.dart';
import 'package:baceconomie/screens/login_screen.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:baceconomie/utils/data_providers.dart';
import 'package:nb_utils/nb_utils.dart';

class WalkThroughScreen extends StatefulWidget {
  static String tag = '/WalkThroughScreen';

  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController? pageController;
  int currentPage = 0;
  List<WalkThroughItemModel> pages = getWalkThroughItems();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    pageController = PageController(initialPage: currentPage);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        height: context.height(),
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              children: List.generate(
                pages.length,
                (index) {
                  return Column(
                    children: [
                      Image.asset(pages[index].image!,
                          width: context.width(),
                          height: context.height() * 0.5,
                          fit: BoxFit.cover),
                      50.height,
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              pages[index].title!,
                              style: boldTextStyle(
                                  size: context.width() > 450 ? 30 : 20),
                              textAlign: TextAlign.center,
                            ).paddingOnly(
                                left: context.width() > 450 ? 30 : 20,
                                right: context.width() > 450 ? 30 : 20),
                            30.height,
                            Text(
                              pages[index].subTitle!,
                              textAlign: TextAlign.center,
                            ).paddingOnly(
                                left: context.width() > 450 ? 30 : 20,
                                right: context.width() > 450 ? 30 : 20),
                          ],
                        ),
                      ),
                      16.height,
                    ],
                  );
                },
              ),
              onPageChanged: (value) {
                currentPage = value;
                setState(() {});
              },
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      await setValue(IS_FIRST_TIME, false);
                      LoginScreen().launch(context);
                    },
                    child: Text('Skip', style: boldTextStyle(color: grey)),
                  ),
                  DotIndicator(
                    pages: pages,
                    pageController: pageController!,
                    indicatorColor: colorPrimary,
                  ),
                  AppButton(
                    child: currentPage != 2
                        ? Icon(Icons.navigate_next, color: white, size: 30)
                        : Text(
                            'Get Started',
                            style: boldTextStyle(color: white),
                          ),
                    color: colorPrimary,
                    onTap: () async {
                      if (currentPage != 2) {
                        pageController!.animateToPage(++currentPage,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.bounceInOut);
                      } else {
                        await setValue(IS_FIRST_TIME, false);
                        LoginScreen().launch(context, isNewTask: true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
