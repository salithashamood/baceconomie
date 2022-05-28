import 'package:flutter/material.dart';
import 'package:baceconomie/models/quiz_history_model.dart';
import 'package:baceconomie/screens/quiz_history_details_screen.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import 'dash_board_screen.dart';

class QuizResultScreenAlong extends StatefulWidget {
  final int? point;
  final QuizHistoryModel? quizHistoryData;
  const QuizResultScreenAlong({Key? key, this.point, this.quizHistoryData})
      : super(key: key);

  @override
  _QuizResultScreenAlongState createState() => _QuizResultScreenAlongState();
}

class _QuizResultScreenAlongState extends State<QuizResultScreenAlong> {
  late double? percentage;
  bool isAnswerd = false;
  bool isLoading = true;
  bool isNewPoint = false;
  late int invitePoint;
  // var myDetails = db.collection('users').doc(appStore.userId);

  @override
  void initState() {
    super.initState();
    init();
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
  //   await db.collection('users').doc(widget.userModel!.id).get().then((value) {
  //     isAnswerd = value.get('isAnswerd');
  //     isNewPoint = value.get('isNewPoint');
  //   });
  //   print('isAnswerd : $isNewPoint');
  // }

  // getInvitedPoints() async {
  //   Future.delayed(Duration(seconds: 5)).then((value) async {
  //     await db
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
    //   for (var i = 0; i < 20; i++) {
    //     Future.delayed(Duration(seconds: 5)).then((value) {
    //       getinvitedPoint();
    //     });
    //   }
    // } else if (isNewPoint && isLoading) {
    //   for (var i = 0; i < 20; i++) {
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
                  Positioned(
                      top: 0,
                      height: 200,
                      width: 200,
                      child: Image.asset(resultWiseImage()!)),
                  Image.asset(ResultCompleteImage, height: 200, width: 200),
                  Text('${widget.quizHistoryData!.rightQuestion! * 5}',
                          style: boldTextStyle(color: colorPrimary, size: 30))
                      .paddingTop(30),
                  // Positioned(
                  //   top: 60,
                  //   // right: 10,
                  //   height: 300,
                  //   width: 250,
                  //   child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //           children: [
                  //             columnDetails(
                  //                 appStore.userProfileImage!,
                  //                 appStore.userName!,
                  //                 widget.point!,
                  //                 invitePoint),
                  //             20.width,
                  //             // columnDetails(
                  //             //   appStore.userProfileImage!,
                  //             //   appStore.userName!,
                  //             //   widget.point!,
                  //             // ),
                  //             columnDetails(
                  //                 widget.userModel!.image!,
                  //                 widget.userModel!.name!,
                  //                 invitePoint,
                  //                 widget.point!),
                  //           ],
                  //         );
                  // ),
                  Positioned(
                    // top: 80,
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
                child: Icon(Icons.home, color: colorPrimary).onTap(() {
                  DashboardScreen().launch(context, isNewTask: true);
                }),
              ).cornerRadiusWithClipRRect(defaultRadius),
            ),
          ],
        ),
      ),
    );
  }
}
