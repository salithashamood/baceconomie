import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baceconomie/components/question_controller.dart';
import 'package:baceconomie/components/quiz_description_component.dart';
import 'package:baceconomie/models/quiz_data.dart';
import 'package:baceconomie/screens/quiz_questions_screen_along.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class QuizDescriptionScreenAlong extends StatefulWidget {
  final QuizData? quizModel;
  const QuizDescriptionScreenAlong({Key? key, this.quizModel})
      : super(key: key);

  @override
  _QuizDescriptionScreenAlongState createState() =>
      _QuizDescriptionScreenAlongState();
}

class _QuizDescriptionScreenAlongState
    extends State<QuizDescriptionScreenAlong> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
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
                      (value) {
                        if (value ?? false) {
                          _controller.onInit();
                          QuizQuestionsScreenAlong(
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
              () {
                finish(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
