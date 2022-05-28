import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:baceconomie/components/drawaer_components.dart';
import 'package:baceconomie/components/quize_category_components.dart';
import 'package:baceconomie/database/category_service.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/category_model.dart';
import 'package:baceconomie/screens/quiz_screen.dart';
import 'package:baceconomie/screens/pickup_layout.dart';
import 'package:baceconomie/screens/quiz_category_screen.dart';
import 'package:baceconomie/screens/selected_category_play.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:baceconomie/utils/images.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.dark);

    await 5.seconds.delay;
    LiveStream().on(
      HideDrawerStream,
      (s) {
        scaffoldKey.currentState!.openEndDrawer();
      },
    );
  }

  // @override
  // void afterFirstLayout(BuildContext context) {
  //   OneSignal.shared.setNotificationOpenedHandler(
  //     (OSNotificationOpenedResult result) {
  //       if (result.notification.additionalData!.containsKey('id')) {
  //         String quizId = result.notification.additionalData!['id'];

  //         QuizService().getQuizByQuizId(quizId).then(
  //           (value) {
  //             QuizDescriptionScreen(quizModel: value.first).launch(context);
  //           },
  //         ).catchError(
  //           (e) {
  //             toast(e.toString());
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  void dispose() {
    LiveStream().dispose(HideDrawerStream);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          await 2.seconds.delay;
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: DrawerComponent(),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  brightness: Brightness.dark,
                  backgroundColor: colorPrimary,
                  iconTheme: IconThemeData(color: scaffoldColor),
                  title: Text(
                    mAppName,
                    style: TextStyle(color: Colors.black),
                  ),
                  centerTitle: true,
                  pinned: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(defaultRadius),
                        bottomRight: Radius.circular(defaultRadius)),
                  ),
                  expandedHeight: context.height() * 0.5,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Image.asset(DashboardImage, fit: BoxFit.cover),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: locator.get<CategoryService>().categories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<CategoryModel> data =
                            snapshot.data as List<CategoryModel>;
                        return ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: 30),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Choose Categories',
                                    style: boldTextStyle(
                                        size: context.width() > 450 ? 22 : 18)),
                                Text(
                                  'See All',
                                  style: boldTextStyle(
                                      color: colorPrimary,
                                      size: context.width() > 450 ? 22 : 18),
                                ).onTap(
                                  () {
                                    QuizCategoryScreen().launch(context);
                                  },
                                ),
                              ],
                            ).paddingOnly(left: 16, right: 16),
                            16.height,
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.all(16),
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 20,
                                children: List.generate(
                                  data.length,
                                  (index) {
                                    CategoryModel? mData = data[index];
                                    return QuizCategoryComponent(
                                            category: mData)
                                        .onTap(
                                      () async {
                                        await locator
                                            .get<FirebaseFirestore>()
                                            .collection('users')
                                            .doc(locator.get<AppStore>().userId)
                                            .update({
                                          'categoryId': mData.id,
                                        });
                                        await locator
                                            .get<CategoryService>()
                                            .subCategories(mData.id!)
                                            .then(
                                          (value) {
                                            if (value.isNotEmpty) {
                                              QuizScreen(
                                                catId: mData.id,
                                                catName: mData.name,
                                              ).launch(context);
                                            } else {
                                              SelectedCategoryPlay(
                                                catId: mData.id,
                                                catName: mData.name,
                                                isSub: false,
                                              ).launch(context);
                                            }
                                          },
                                        ).catchError(
                                          (error) {
                                            log(error);
                                          },
                                        );
                                        // PlayOnlineQuizScreen(
                                        //   catId: mData.id,
                                        //   catName: mData.name,
                                        // ).launch(context);
                                        // QuizScreen(catId: mData.id, catName: mData.name).launch(context);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return snapWidgetHelper(snapshot,
                          errorWidget: emptyWidget());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
