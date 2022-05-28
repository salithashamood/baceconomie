import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:baceconomie/database/quiz_service.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/quiz_data.dart';
import 'package:baceconomie/models/user_model.dart';
import 'package:baceconomie/screens/quiz_description_screen.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class FriendsScreen extends StatefulWidget {
  final String? inviteId;
  final String? catName;
  final String? catId;
  const FriendsScreen({Key? key, this.inviteId, this.catName, this.catId})
      : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  UserModel userModel = UserModel();
  bool isLoading = true;
  QuizData quizData = QuizData();

  @override
  void initState() {
    super.initState();
    getInvitDetails();
    setLoading();
  }

  Future setLoading() async {
    await locator
        .get<FirebaseFirestore>()
        .collection('users')
        .doc(locator.get<AppStore>().userId)
        .update({
      'isTestUser': true,
    });
  }

  Stream<DocumentSnapshot> checkLoading() {
    return locator
        .get<FirebaseFirestore>()
        .collection('users')
        .doc(widget.inviteId)
        .snapshots();
  }

  Future getInvitDetails() async {
    await locator
        .get<FirebaseFirestore>()
        .collection('users')
        .where('id', isEqualTo: widget.inviteId)
        .get()
        .then((value) {
      value.docs.map((e) {
        userModel = UserModel.fromJson(e.data());
      }).toList();
      setState(() {
        isLoading = userModel.isLoading ?? true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      for (var i = 0; i < 100; i++) {
        Future.delayed(Duration(seconds: 2)).then((value) {
          getInvitDetails();
        });
      }
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: StreamBuilder<DocumentSnapshot>(
          stream: checkLoading(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.data() != null) {
              UserModel userModel = UserModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);
              if (userModel.isTestUser!) {
                return Scaffold(
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        35.height,
                        Text(
                          '${widget.catName ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        16.height,
                        Container(
                          height: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              columnDetails(
                                  locator.get<AppStore>().userProfileImage!,
                                  locator.get<AppStore>().userName!),
                              // 10.width,
                              columnDetails(userModel.image!, userModel.name!),
                            ],
                          ),
                        ),
                        8.height,
                        Expanded(
                          child: FutureBuilder<List<QuizData>>(
                            future: QuizService().getQuizByCatId(widget.catId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                snapshot.data!.map((data) {
                                  quizData = data;
                                }).toList();
                                return QuizDescriptionScreen(
                                  quizModel: quizData,
                                  userModel: userModel,
                                );
                              }
                              return Scaffold(
                                body: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // Future.delayed(Duration(seconds: 30)).then(
                //   (value) {
                //     DashboardScreen()
                //         .launch(context, isNewTask: true)
                //         .then((value) {
                //       final scaffold = ScaffoldMessenger.of(context);
                //       scaffold.showSnackBar(
                //         const SnackBar(
                //           content: Text('Friend has quit.'),
                //         ),
                //       );
                //     });
                //   },
                // );
                return const Scaffold(
                    body:
                        Center(child: Text('Waiting for friend to join....')));
              }
            } else {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
          }),
    );
  }

  columnDetails(String imageURL, String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        16.height,
        Container(
          width: 200,
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
      ],
    );
  }
}
