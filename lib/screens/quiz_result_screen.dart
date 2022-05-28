import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/quiz_history_model.dart';
import 'package:baceconomie/models/user_model.dart';
import 'package:baceconomie/screens/quiz_history_details_screen.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/images.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dash_board_screen.dart';

class QuizResultScreen extends StatefulWidget {
  static String tag = '/QuizResultScreen';

  final QuizHistoryModel? quizHistoryData;
  // final String? oldLevel, newLevel;
  final int? point;
  final UserModel? userModel;

  QuizResultScreen({this.quizHistoryData, this.point, this.userModel});

  @override
  QuizResultScreenState createState() => QuizResultScreenState();
}

class QuizResultScreenState extends State<QuizResultScreen> {
  late double? percentage;
  var myDetails = locator
      .get<FirebaseFirestore>()
      .collection('users')
      .doc(locator.get<AppStore>().userId);

  @override
  void initState() {
    super.initState();
    init();
    // getinvitedPoint();
    // getInvitedPoints();
  }

  init() async {
    percentage = (widget.quizHistoryData!.rightQuestion! /
            widget.quizHistoryData!.totalQuestion!) *
        100;
    // Future.delayed(
    //   2.seconds,
    //   () {
    //     if (widget.oldLevel != widget.newLevel) {
    //       showInDialog(
    //         context,
    //         child: UpgradeLevelDialogComponent(level: widget.newLevel),
    //       );
    //     }
    //   },
    // );
  }

  String? resultWiseImage() {
    if (percentage! >= 0 && percentage! <= 30) {
      return ResultTryAgainImage;
    } else if (percentage! > 30 && percentage! <= 60) {
      return ResultAverageImage;
    } else if (percentage! > 60 && percentage! <= 90) {
      return ResultGoodJobImage;
    } else if (percentage! > 90) {
      return ResultExcellentImage;
    }
  }

  // getinvitedPoint() async {
  //   await locator.get<FirebaseFirestore>().collection('users').doc(widget.userModel!.id).get().then((value) {
  //     isAnswerd = value.get('isAnswerd');
  //     isNewPoint = value.get('isNewPoint');
  //   });
  //   print('isAnswerd : $isNewPoint');
  // }

  // getInvitedPoints() async {
  //   Future.delayed(Duration(seconds: 5)).then((value) async {
  //     await locator.get<FirebaseFirestore>()
  //         .collection('users')
  //         .doc(widget.userModel!.id)
  //         .get()
  //         .then((value) {
  //       invitePoint = value.get('points');
  //     }).then((value) async {
  //       await myDetails
  //           .collection('quizHistory')
  //           .doc(widget.quizHistoryData!.id)
  //           .update({
  //         'invitedPoint': invitePoint,
  //       }).then((value) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         print('point : $invitePoint');
  //       });
  //     });
  //   });
  // }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!isAnswerd) {
    //   for (var i = 0; i < 150; i++) {
    //     Future.delayed(Duration(seconds: 5)).then((value) {
    //       getinvitedPoint();
    //     });
    //   }
    // } else if (isNewPoint && isLoading) {
    //   for (var i = 0; i < 50; i++) {
    //     Future.delayed(Duration(seconds: 5)).then((value) {
    //       getInvitedPoints();
    //     });
    //   }
    // }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              width: context.width(),
              height: context.height(),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ResultBgImage), fit: BoxFit.fill),
              ),
            ),
            Container(
              height: context.height() * 0.90,
              width: context.width(),
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Image.asset(
                    ResultCardImage,
                    fit: BoxFit.fill,
                    width: context.width(),
                  ).paddingOnly(top: 100),
                  // Positioned(
                  //     top: 0,
                  //     height: 200,
                  //     width: 200,
                  //     child: Image.asset(resultWiseImage()!)),
                  // Image.asset(ResultCompleteImage, height: 200, width: 200),
                  // Text('${widget.quizHistoryData!.rightQuestion! * 10}',
                  //         style:
                  //             boldTextStyle(color: colorPrimary, size: 30))
                  //     .paddingTop(30),
                  Positioned(
                    top: context.height() * 0.15,
                    // right: 10,
                    height: context.height() * 0.4,
                    width: 250,
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: locator
                          .get<FirebaseFirestore>()
                          .collection('users')
                          .doc(widget.userModel!.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.data() != null) {
                          UserModel userModel = UserModel.fromJson(
                              snapshot.data!.data() as Map<String, dynamic>);
                          if (userModel.isAnswerd!) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                columnDetails(
                                    locator.get<AppStore>().userProfileImage!,
                                    locator.get<AppStore>().userName!,
                                    widget.point!,
                                    userModel.points!),
                                // columnDetails(
                                //   appStore.userProfileImage!,
                                //   appStore.userName!,
                                //   widget.point!,
                                // ),
                                columnDetails(
                                    widget.userModel!.image!,
                                    widget.userModel!.name!,
                                    userModel.points!,
                                    widget.point!),
                              ],
                            );

                            // return Center(
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Text('Waiting for friend response'),
                            //       16.height,
                            //       CircularProgressIndicator(),
                            //     ],
                            //   ),
                            // );
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Waiting for friend response'),
                                  16.height,
                                  CircularProgressIndicator(),
                                ],
                              ),
                            );
                          }
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Friend quit game',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: context.height() * 0.54,
                    bottom: 40,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              color: colorSecondary,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Total',
                                      style: boldTextStyle(color: white)),
                                  4.height,
                                  Text(
                                      '${widget.quizHistoryData!.totalQuestion}',
                                      style: boldTextStyle(color: white)),
                                ],
                              ),
                            ).cornerRadiusWithClipRRect(defaultRadius),
                            16.width,
                            Container(
                              width: 70,
                              height: 70,
                              color: blueColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Right',
                                      style: boldTextStyle(color: white)),
                                  4.height,
                                  Text(
                                      '${widget.quizHistoryData!.rightQuestion}',
                                      style: boldTextStyle(color: white)),
                                ],
                              ),
                            ).cornerRadiusWithClipRRect(defaultRadius),
                            16.width,
                            Container(
                              width: 70,
                              height: 70,
                              color: Colors.red,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Wrong',
                                      style: boldTextStyle(color: white)),
                                  4.height,
                                  Text(
                                    '${widget.quizHistoryData!.totalQuestion! - widget.quizHistoryData!.rightQuestion!}',
                                    style: boldTextStyle(color: white),
                                  ),
                                ],
                              ),
                            ).cornerRadiusWithClipRRect(defaultRadius),
                          ],
                        ),
                        16.height,
                        Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colorPrimary, colorSecondary],
                              begin: FractionalOffset.centerLeft,
                              end: FractionalOffset.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(defaultRadius),
                          ),
                          child: TextButton(
                            onPressed: () {
                              QuizHistoryDetailScreen(
                                      quizHistoryData: widget.quizHistoryData)
                                  .launch(context);
                            },
                            child: Text('See Answers',
                                style: primaryTextStyle(color: white)),
                            // onPressed: update,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 30,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(8),
                color: white,
                child: Icon(Icons.home, color: colorPrimary).onTap(
                  () async {
                    await myDetails.update({
                      'invitedId': '',
                      'isNewPoint': false,
                      'isTestUser': false,
                    }).then((value) async {
                      await locator
                          .get<FirebaseFirestore>()
                          .collection('users')
                          .doc(widget.userModel!.id)
                          .update({
                        'invitedId': '',
                        'isNewPoint': false,
                      });
                    }).then((value) async {
                      await myDetails
                          .collection('quizHistory')
                          .doc(widget.quizHistoryData!.id)
                          .update({
                        'point': widget.point,
                        'invitedPoint': widget.userModel!.points,
                      });
                    }).then((value) {
                      DashboardScreen().launch(context, isNewTask: true);
                    }).catchError((onError) {
                      print(onError);
                    });
                  },
                ),
              ).cornerRadiusWithClipRRect(defaultRadius),
            ),
          ],
        ),
      ),
    );
  }

  columnDetails(String imageURL, String name, int mypoints, int invitedPoints) {
    return Container(
      height: 250,
      width: 108,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (mypoints > invitedPoints)
              ? CircleAvatar(
                  radius: 30,
                  child: Image.asset(
                    'images/istockphoto-648236294-612x612.jpg',
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  height: 70,
                ),
          8.height,
          CircleAvatar(
            radius: 40,
            child: imageURL.isNotEmpty
                ? cachedImage(
                    imageURL,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(60)
                : Icon(
                    Feather.user,
                    size: 60,
                  ),
          ),
          7.height,
          Container(
            width: 150,
            child: RichText(
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
            ),
          ),
          5.height,
          Text(
            mypoints.toString(),
            style: TextStyle(
              color: mypoints > invitedPoints ? Colors.blue : Colors.red,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
