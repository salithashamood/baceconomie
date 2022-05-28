import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/screens/friend_screen.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:nb_utils/nb_utils.dart';

class PlayOnlineQuizScreen extends StatefulWidget {
  final String? catName, catId;

  const PlayOnlineQuizScreen({Key? key, this.catName, this.catId})
      : super(key: key);
  @override
  PlayOnlineQuizScreenState createState() => PlayOnlineQuizScreenState();
}

class PlayOnlineQuizScreenState extends State<PlayOnlineQuizScreen> {
  TextEditingController quizCodeController = TextEditingController();
  // bool isLoading = false;
  var myDetails = locator
      .get<FirebaseFirestore>()
      .collection('users')
      .doc(locator.get<AppStore>().userId);
  final random = Random();
  String? inviteId;
  String? invitedId;
  List document = [];
  String? friendId;
  bool isLoop = true;
  bool isBackButton = false;

  @override
  void initState() {
    super.initState();
    init();
    searchUser();
  }

  Future<void> init() async {
    print(widget.catId);
    await myDetails.update({
      'isTestUser': false,
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<bool> _willPopCallback() async {
    setState(() {
      isBackButton = true;
    });
    await myDetails.update({
      'invitedId': '',
      'inviteId': '',
      'isOnline': false,
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body:
            // !isLoading
            //     ? Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text('Play online quiz', style: boldTextStyle(size: 22)),
            //           16.height,
            //           Container(
            //             decoration: boxDecorationWithRoundedCorners(
            //                 boxShadow: defaultBoxShadow(),
            //                 backgroundColor: colorSecondary),
            //             child: Column(
            //               children: [
            //                 Text(
            //                   'Search Friend...',
            //                   style: boldTextStyle(size: 20),
            //                 ),
            //                 16.height,
            //                 AppButton(
            //                   width: context.width(),
            //                   color: black,
            //                   child: Text('Search',
            //                       style: boldTextStyle(color: Colors.white)),
            //                   onTap: () {
            //                     searchUser();
            //                   },
            //                 )
            //               ],
            //             ).paddingAll(16),
            //           ),
            //         ],
            //       ).paddingAll(16)
            //     :
            Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Searching Friends.......'),
              16.height,
              CircularProgressIndicator(),
              50.height,
              AppButton(
                color: black,
                child: Text('Stop', style: boldTextStyle(color: Colors.white)),
                onTap: () async {
                  setState(() {
                    isBackButton = true;
                  });
                  await myDetails.update({
                    'invitedId': '',
                    'inviteId': '',
                    'isOnline': false,
                  }).then((value) {
                    finish(context);
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  searchUser() async {
    await myDetails.update({
      'isOnline': true,
    }).then((value) async {
      while (isLoop && !isBackButton) {
        await myDetails.get().then((value) async {
          // setState(() {
          //   isLoading = true;
          // });
          if (value.get('invitedId') != '') {
            await myDetails.update({
              'isLoading': false,
              'isOnline': false,
              'inviteId': '',
            });
            setState(() {
              invitedId = value.get('invitedId');
              friendId = invitedId;
              isLoop = false;
            });
            // print('success 1');
            // toast('success 1');
            FriendsScreen(
              inviteId: friendId,
              catId: widget.catId,
              catName: widget.catName,
            ).launch(context);
          } else {
            Future.delayed(Duration(seconds: 1)).then((value) async {
              await locator
                  .get<FirebaseFirestore>()
                  .collection('users')
                  .where('isOnline', isEqualTo: true)
                  .where('categoryId', isEqualTo: widget.catId)
                  .get()
                  .then((value) async {
                value.docs.forEach((element) {
                  if (locator.get<AppStore>().userId != element.id) {
                    document.add(element.id);
                  }
                });
                var element = document[random.nextInt(document.length)];
                await locator
                    .get<FirebaseFirestore>()
                    .collection('users')
                    .doc(element)
                    .update({'inviteId': locator.get<AppStore>().userId}).then(
                        (value) async {
                  await locator
                      .get<FirebaseFirestore>()
                      .collection('users')
                      .doc(locator.get<AppStore>().userId)
                      .get()
                      .then((value) {
                    setState(() {
                      inviteId = value.get('inviteId');
                    });
                    // toast(inviteId);
                    Future.delayed(Duration(seconds: 10)).then((value) async {
                      if (inviteId == element) {
                        await locator
                            .get<FirebaseFirestore>()
                            .collection('users')
                            .doc(element)
                            .update({
                          'inviteId': '',
                          'invitedId': locator.get<AppStore>().userId,
                          'isLoading': false,
                        }).then((value) async {
                          await myDetails.update({
                            'inviteId': '',
                            'invitedId': element,
                            'isOnline': false,
                            'isLoading': false,
                          }).then((value) {
                            // print('success 2');
                            // toast('success 2');
                            setState(() {
                              friendId = inviteId;
                              isLoop = false;
                            });
                            FriendsScreen(
                              inviteId: friendId,
                              catId: widget.catId,
                              catName: widget.catName,
                            ).launch(context);
                          });
                        });
                      } else {
                        print('bad');
                        if (!isBackButton) {
                          searchUser();
                        } else {
                          await myDetails.update({
                            'invitedId': '',
                            'inviteId': '',
                            'isOnline': false,
                          });
                        }
                      }
                    });
                  });
                });
              });
            });
          }
        });
        break;
      }
      if (!isLoop) {
        FriendsScreen(
          inviteId: friendId,
          catId: widget.catId,
          catName: widget.catName,
        ).launch(context);
      }
    });

    return null;
  }
}
