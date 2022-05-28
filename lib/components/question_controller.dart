import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:baceconomie/screens/quiz_questions_screen.dart';
import 'package:baceconomie/screens/quiz_questions_screen_along.dart';
// ignore: unused_import
import 'package:nb_utils/nb_utils.dart';

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  AnimationController? _animationController;
  Animation? _animation;
  Animation get animation => this._animation!;
  int page = 0;
  bool _isOnlyMe = false;

  PageController? _pageController;
  PageController get pageController => _pageController!;

  @override
  void onInit() {
    page = 0;
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!)
          ..addListener(() {
            update();
          });

    _animationController!.forward().whenComplete(nextQuestion);

    _pageController = PageController();
    super.onInit();
  }

  void checkAns(int selectPage, bool isOnlyMe) {
    _animationController!.stop();
    page = selectPage;
    _isOnlyMe = isOnlyMe;

    Future.delayed(Duration(seconds: 1), () {
      nextQuestion.call();
    });
  }

  void nextQuestion() {
    page = page + 1;
    if (page < 20) {
      _pageController!.animateToPage(
        page,
        duration: Duration(milliseconds: 250),
        curve: Curves.bounceInOut,
      );

      _animationController!.reset();

      _animationController!.forward().whenComplete(nextQuestion);
    } else {
      // _animationController!.reset();
      // _animationController!.forward();
      _isOnlyMe
          ? QuizQuestionsScreenAlong().submitQuiz()
          : QuizQuestionsScreen().createState().submitQuiz();
    }
  }

  @override
  void onClose() {
    super.onClose();
    _animationController!.dispose();
    _pageController!.dispose();
  }
}
