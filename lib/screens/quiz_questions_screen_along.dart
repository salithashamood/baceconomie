import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:baceconomie/components/progress_bar.dart';
import 'package:baceconomie/components/question_controller.dart';
import 'package:baceconomie/components/quiz_question_component.dart';
import 'package:baceconomie/database/question_service.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/question_data.dart';
import 'package:baceconomie/models/quiz_data.dart';
import 'package:baceconomie/models/quiz_history_model.dart';
import 'package:baceconomie/models/user_model.dart';
import 'package:baceconomie/screens/quiz_result_screen_along.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class QuizQuestionsScreenAlong extends StatefulWidget {
  final QuizData? quizData;
  final String? quizType;
  const QuizQuestionsScreenAlong({Key? key, this.quizData, this.quizType})
      : super(key: key);

  submitQuiz() => createState().onSubmit();

  @override
  _QuizQuestionsScreenAlongState createState() =>
      _QuizQuestionsScreenAlongState();
}

class _QuizQuestionsScreenAlongState extends State<QuizQuestionsScreenAlong> {
  var myDetailsQuiz = locator
      .get<FirebaseFirestore>()
      .collection('users')
      .doc(locator.get<AppStore>().userId)
      .collection('alongQuizHistory');
  UserModel? userModel;
  // CountdownTimerController? countdownController;
  PageController? pageController;
  int? endTime;
  int rightAnswers = 0;
  int selectedPageIndex = 0;

  List<QuestionData> quizQuestionsList = [];
  List<QuestionData> questions = [];
  List<QuizAnswer> quizAnswer = [];

  String? oldLevel, newLevel;

  String? quizType, title, image;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setState(() {
      quizType = widget.quizType;
      title = widget.quizData!.quizTitle;
      image = widget.quizData!.imageUrl;
    });
    // endTime = DateTime.now().millisecondsSinceEpoch +
    //     Duration(minutes: widget.quizData!.quizTime!).inMilliseconds;

    // countdownController =
    //     CountdownTimerController(endTime: endTime!, onEnd: onEnd);

    pageController = PageController(initialPage: selectedPageIndex);

    LiveStream().on(
      answerQuestionStream,
      (s) {
        if (questions.contains(s)) {
          questions.remove(s);
        }
        questions.add(s as QuestionData);
      },
    );

    List ranId = [];
    var random = Random();
    widget.quizData!.questionRef!.forEach(
      (e) async {
        ranId.add(e.toString());
        // await questionService.questionById(e.toString()).then(
        //   (value) {
        //     quizQuestionsList.add(value);
        //     setState(() {});
        //   },
        // ).catchError(
        //   (e) {
        //     emptyWidget();
        //     throw e.toString();
        //   },
        // );
      },
    );
    for (var i = 0; i < 20; i++) {
      var id = ranId[random.nextInt(ranId.length)];
      await locator.get<QuestionService>().questionById(id).then(
        (value) {
          quizQuestionsList.add(value);
          setState(() {});
        },
      ).catchError(
        (e) {
          emptyWidget();
          throw e.toString();
        },
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    super.dispose();
    // countdownController!.dispose();
    pageController!.dispose();
    LiveStream().dispose(answerQuestionStream);
  }

  // void onEnd() {
  //   showInDialog(
  //     context,
  //     barrierDismissible: false,
  //     child: WillPopScope(
  //       onWillPop: () => Future.value(false),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Time over message'),
  //           16.height,
  //           Align(
  //             alignment: Alignment.centerRight,
  //             child: AppButton(
  //               text: 'Submit',
  //               onTap: submitQuiz,
  //               elevation: 0,
  //               color: blueColor,
  //               textColor: white,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> submitQuiz() async {
    // countdownController!.disposeTimer();
    locator.get<AppStore>().setLoading(true);

    questions.forEach(
      (element) {
        if (element.answer == element.correctAnswer) {
          rightAnswers++;
        }
      },
    );

    questions.forEach(
      (element) {
        quizAnswer.add(
          QuizAnswer(
            question: element.questionTitle.validate(),
            answers: element.answer.validate(value: 'Not Answered'),
            correctAnswer: element.correctAnswer.validate(),
          ),
        );
      },
    );

    QuizHistoryModel quizHistory = QuizHistoryModel();
    int point = POINT_PER_QUESTION * rightAnswers;

    quizHistory.userId = locator.get<AppStore>().userId;
    quizHistory.createdAt = DateTime.now();
    quizHistory.quizType = quizType;
    quizHistory.quizTitle = title.validate();
    quizHistory.image = image.validate();
    quizHistory.quizAnswers = quizAnswer;
    quizHistory.totalQuestion = quizAnswer.length.validate();
    quizHistory.rightQuestion = rightAnswers.validate();
    quizHistory.point = point;

    await myDetailsQuiz.add(quizHistory.toJson()).then(
      (value) async {
        value.update({
          'id': value.id,
        });
        quizHistory.id = value.id;
        // oldLevel = getLevel(points: getIntAsync(USER_POINTS));

        // setValue(USER_POINTS,
        //     getIntAsync(USER_POINTS) + POINT_PER_QUESTION * rightAnswers);

        // newLevel = getLevel(points: getIntAsync(USER_POINTS));

        locator.get<AppStore>().setLoading(false);
        // finish(context);
        // QuizResultScreenAlong(
        //   point: point,
        //   quizHistoryData: quizHistory,
        // ).launch(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => QuizResultScreenAlong(
                      point: point,
                      quizHistoryData: quizHistory,
                    ))).catchError((onError) => print(onError.toString()));
      },
    ).catchError(
      (e) {
        // print(e.toString());
        // toast(e.toString());
      },
    );
  }

  void onSubmit() {
    showConfirmDialog(
      context,
      'Want to submit',
      positiveText: 'Yes',
      negativeText: 'No',
      barrierDismissible: false,
    ).then((value) {
      if (value ?? false) {
        submitQuiz.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorPrimary,
                    colorSecondary,
                  ],
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${'Questions'} ${selectedPageIndex + 1}/20',
                        style: boldTextStyle(
                          color: white,
                          size: 20,
                        ),
                      ),
                      // CountdownTimer(
                      //   controller: countdownController,
                      //   onEnd: onEnd,
                      //   endTime: endTime,
                      //   textStyle: primaryTextStyle(color: white),
                      // ),
                    ],
                  ),
                  8.height,
                  ProgressBar(),
                  8.height,
                  AppButton(
                    text: 'End quiz',
                    color: white,
                    onTap: onSubmit,
                    textColor: colorPrimary,
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  )
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              top: MediaQuery.of(context).size.height * 0.26,
              child: Container(
                padding: EdgeInsets.all(30),
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: BorderRadius.circular(defaultRadius),
                  backgroundColor: Theme.of(context).cardColor,
                ),
                child: PageView(
                  physics: new NeverScrollableScrollPhysics(),
                  controller: _controller.pageController,
                  children: List.generate(
                    quizQuestionsList.length,
                    (index) {
                      if (quizQuestionsList.length == 0) {
                        return Container();
                      } else {
                        LiveStream().emit(
                            answerQuestionStream, quizQuestionsList[index]);

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              QuizQuestionComponent(
                                  question: quizQuestionsList[index]),
                              16.height,
                              if (index == 0 && 20 != 1)
                                AppButton(
                                  text: 'Next',
                                  color: colorPrimary,
                                  onTap: () {
                                    _controller.checkAns(
                                        selectedPageIndex, true);
                                    // pageController!.animateToPage(
                                    //   ++selectedPageIndex,
                                    //   duration: Duration(milliseconds: 250),
                                    //   curve: Curves.bounceInOut,
                                    // );
                                  },
                                  textColor: scaffoldColor,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 10),
                                )
                              else if (index > 0 && index < 20 - 1)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // AppButton(
                                    //     text: 'Previous',
                                    //     color: colorPrimary,
                                    //     onTap: () {
                                    //       _controller.checkAns(selectedPageIndex);
                                    //       // pageController!.animateToPage(
                                    //       //   --selectedPageIndex,
                                    //       //   duration: Duration(milliseconds: 250),
                                    //       //   curve: Curves.bounceInOut,
                                    //       // );
                                    //     },
                                    //     textColor: scaffoldColor,
                                    //     padding: EdgeInsets.symmetric(
                                    //         vertical: 6, horizontal: 10)),
                                    // 16.width,
                                    AppButton(
                                      text: 'Next',
                                      color: colorPrimary,
                                      onTap: () {
                                        _controller.checkAns(
                                            selectedPageIndex, true);
                                        // pageController!.animateToPage(
                                        //   ++selectedPageIndex,
                                        //   duration: Duration(milliseconds: 250),
                                        //   curve: Curves.bounceInOut,
                                        // );
                                      },
                                      textColor: scaffoldColor,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 10),
                                    ),
                                  ],
                                )
                              else if (index == 19 && 20 != 1)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // AppButton(
                                    //   text: 'Previous',
                                    //   color: colorPrimary,
                                    //   onTap: () {
                                    //     pageController!.animateToPage(
                                    //       --selectedPageIndex,
                                    //       duration: Duration(milliseconds: 250),
                                    //       curve: Curves.bounceInOut,
                                    //     );
                                    //   },
                                    //   textColor: scaffoldColor,
                                    //   padding: EdgeInsets.symmetric(
                                    //       vertical: 6, horizontal: 10),
                                    // ),
                                    // 16.width,
                                    AppButton(
                                      text: 'Submit',
                                      color: colorPrimary,
                                      onTap: onSubmit,
                                      textColor: scaffoldColor,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 10),
                                    ),
                                  ],
                                )
                              else if (index == 19)
                                AppButton(
                                  text: 'Submit',
                                  color: white,
                                  onTap: onSubmit,
                                  textStyle: boldTextStyle(),
                                  textColor: scaffoldColor,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 10),
                                ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  onPageChanged: (value) {
                    selectedPageIndex = value;
                    setState(() {});
                  },
                ),
              ),
            ),
            Observer(
                builder: (context) =>
                    Loader().visible(locator.get<AppStore>().isLoading)),
          ],
        ).withHeight(MediaQuery.of(context).size.height),
      ),
      onWillPop: () {
        return Future.value(false);
      },
    );
  }
}
