import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:baceconomie/components/question_controller.dart';
import 'package:baceconomie/components/quiz_description_component.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/quiz_data.dart';
import 'package:baceconomie/models/user_model.dart';
import 'package:baceconomie/screens/quiz_questions_screen.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'dash_board_screen.dart';

class QuizDescriptionScreen extends StatefulWidget {
  static String tag = '/QuizDescriptionScreen';

  final QuizData? quizModel;
  final UserModel? userModel;

  QuizDescriptionScreen({this.quizModel, this.userModel});

  @override
  QuizDescriptionScreenState createState() => QuizDescriptionScreenState();
}

class QuizDescriptionScreenState extends State<QuizDescriptionScreen> {
  var myDetails = locator
      .get<FirebaseFirestore>()
      .collection('users')
      .doc(locator.get<AppStore>().userId);
  // QuizHistoryModel quizHistoryModel = QuizHistoryModel();
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return StreamBuilder<DocumentSnapshot>(
        stream: myDetails.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            UserModel userModel = UserModel.fromJson(
                snapshot.data!.data() as Map<String, dynamic>);

            if (userModel.invitedId == null) {
              return Scaffold(
                backgroundColor: scaffoldColor,
                body: Container(
                  child: Center(
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Color(0xFFF0C191),
                        border: Border(
                          bottom: BorderSide(width: 12, color: colorPrimary),
                          left: BorderSide(width: 12, color: colorPrimary),
                          right: BorderSide(width: 12, color: colorPrimary),
                          top: BorderSide(width: 12, color: colorPrimary),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            'Friend quit game',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          AppButton(
                            color: colorPrimary,
                            text: 'Go To Home',
                            textColor: Colors.white,
                            onTap: () async {
                              await myDetails.update({
                                'isAccepted': false,
                                'isLoading': false,
                                'invitedId': '',
                                'invitingId': '',
                                'categoryId': '',
                              }).then((value) {
                                DashboardScreen()
                                    .launch(context, isNewTask: true);
                              });
                            },
                          ),
                          Spacer(),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 45),
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          QuizDescriptionComponent(quizModel: widget.quizModel),
                          16.height,
                          gradientButton(
                            text: 'Start',
                            context: context,
                            onTap: () {
                              showConfirmDialog(
                                context,
                                'Do play quiz',
                                positiveText: 'Yes',
                                negativeText: 'No',
                              ).then(
                                (value) async {
                                  if (value ?? false) {
                                    await myDetails.update({
                                      'isAnswerd': false,
                                      'points': 0,
                                    });
                                    _controller.onInit();
                                    QuizQuestionsScreen(
                                      userModel: widget.userModel,
                                      quizData: widget.quizModel,
                                      quizType: QuizTypeCategory,
                                    ).launch(context);
                                  }
                                },
                              );
                            },
                          ).center(),
                          16.height,
                        ],
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 30,
                      child: CircleAvatar(
                        child: Icon(Icons.close, color: black),
                        backgroundColor: white,
                        radius: 15,
                      ).onTap(
                        () async {
                          await myDetails.update({
                            'invitedId': '',
                            'isAnswerd': true,
                          }).then((value) async {
                            await locator
                                .get<FirebaseFirestore>()
                                .collection('users')
                                .doc(widget.userModel!.id)
                                .update({'invitedId': ''});
                          });
                          DashboardScreen().launch(context, isNewTask: true);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return Container();
        });
  }
}
