import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baceconomie/components/question_controller.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: GetBuilder<QuestionController>(
          init: QuestionController(),
          builder: (controller) {
            return Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth * controller.animation.value,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    );
                  },
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                    child: Text(
                      '${(controller.animation.value * 60).round()} sec',
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
