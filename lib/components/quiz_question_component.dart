import 'package:flutter/material.dart';
import 'package:baceconomie/models/question_data.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/widgets.dart';

class QuizQuestionComponent extends StatefulWidget {
  static String tag = '/QuizQuestionComponent1';

  final QuestionData? question;

  QuizQuestionComponent({this.question});

  @override
  QuizQuestionComponentState createState() => QuizQuestionComponentState();
}

class QuizQuestionComponentState extends State<QuizQuestionComponent> {
  bool isAnswered = false;
  bool isCorrect = false;
  String? correctAns;
  int? correctIndex;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setState(() {
      isAnswered = false;
      isCorrect = false;
      // correctIndex = 0;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${widget.question!.questionTitle}',
            style: boldTextStyle(size: 18), textAlign: TextAlign.center),
        30.height,
        widget.question!.image != null
            ? cachedImage(widget.question!.image!.validate(),
                height: 150, fit: BoxFit.cover, width: context.width())
            : Container(),
        16.height,
        Column(
          children: List.generate(
            widget.question!.optionList!.length,
            (index) {
              String mData = widget.question!.optionList![index];
              // setState(() {
              //   correctIndex = 0;
              // });
              for (var i = 0; i < 4; i++) {
                setState(() {
                  correctAns = widget.question!.optionList![i];
                });
                if (correctAns == widget.question!.correctAnswer) {
                  setState(() {
                    correctIndex = i;
                  });
                }
              }
              return Container(
                padding: EdgeInsets.all(16),
                width: context.width(),
                margin: EdgeInsets.only(bottom: 16),
                decoration: boxDecorationWithRoundedCorners(
                  border: isAnswered
                      ? isCorrect
                          ? null
                          : correctIndex == index
                              ? Border.all(color: blueColor)
                              : null
                      : null,
                  backgroundColor:
                      isCorrect && widget.question!.selectedOptionIndex == index
                          ? blueColor.withOpacity(0.3)
                          : widget.question!.selectedOptionIndex == index
                              ? redColor.withOpacity(0.3)
                              : scaffoldColor,
                ),
                child: Text(mData, style: primaryTextStyle()),
              ).onTap(
                () {
                  // setState(() {
                  //   correctIndex = 0;
                  // });
                  if (!isAnswered) {
                    // toast(correctIndex.toString());
                    setState(() {
                      isAnswered = true;
                      widget.question!.selectedOptionIndex = index;
                      log(widget.question!.optionList![index]);
                      widget.question!.answer =
                          widget.question!.optionList![index];
                    });
                    if (widget.question!.correctAnswer ==
                        widget.question!.answer) {
                      setState(() {
                        isCorrect = true;
                      });
                      // toast('correct Answer');
                    } else {
                      setState(() {
                        isCorrect = false;
                      });
                      // toast('wrong answer');
                    }
                    LiveStream().emit(answerQuestionStream, widget.question);
                  }
                  // isAnswered
                  //     ? null
                  //     : setState(
                  //         () {
                  //           isAnswered = true;
                  //           widget.question!.selectedOptionIndex = index;
                  //           log(widget.question!.optionList![index]);
                  //           widget.question!.answer =
                  //               widget.question!.optionList![index];
                  //           if (widget.question!.correctAnswer ==
                  //               widget.question!.answer) {
                  //             setState(() {
                  //               isCorrect = true;
                  //             });
                  //             toast('correct Answer');
                  //           } else {
                  //             for (var i = 0; i < 3; i++) {
                  //               setState(() {
                  //                 correctAns = widget.question!.optionList![i];
                  //               });
                  //               if (correctAns ==
                  //                   widget.question!.correctAnswer) {
                  //                 setState(() {
                  //                   currectIndex = i;
                  //                 });
                  //               }
                  //             }
                  //             setState(() {
                  //               isCorrect = false;
                  //             });
                  //             toast(currectIndex.toString());
                  //           }
                  //           LiveStream()
                  //               .emit(answerQuestionStream, widget.question);
                  //         },
                  //       );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
