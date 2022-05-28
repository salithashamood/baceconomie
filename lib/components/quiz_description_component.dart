import 'package:flutter/material.dart';
import 'package:baceconomie/models/quiz_data.dart';
import 'package:baceconomie/utils/string.dart';
import 'package:nb_utils/nb_utils.dart';

class QuizDescriptionComponent extends StatefulWidget {
  static String tag = '/QuizDescriptionComponent';

  final QuizData? quizModel;

  QuizDescriptionComponent({this.quizModel});

  @override
  QuizDescriptionComponentState createState() =>
      QuizDescriptionComponentState();
}

class QuizDescriptionComponentState extends State<QuizDescriptionComponent> {
  // String university = 'Any';
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.quizModel!.imageUrl!.isNotEmpty
              ? Image.network(
                  widget.quizModel!.imageUrl!,
                  width: context.width(),
                  height: context.height() * 0.40,
                  fit: BoxFit.fill,
                ).cornerRadiusWithClipRRectOnly(
                  bottomLeft: defaultRadius.toInt(),
                  bottomRight: defaultRadius.toInt())
              : Container(),
          30.height,
          Text('About this quiz', style: boldTextStyle(size: 20))
              .paddingOnly(left: 16, right: 16),
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.circular(defaultRadius),
              border: Border.all(color: grey.withOpacity(0.3)),
              backgroundColor: Theme.of(context).cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quiz title', style: boldTextStyle()),
                8.height,
                Text(widget.quizModel!.quizTitle.validate(),
                    style: primaryTextStyle()),
                8.height,
                Divider(color: grey.withOpacity(0.3), thickness: 1),
                8.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lbl_quiz_description, style: boldTextStyle()),
                    8.height,
                    Text(widget.quizModel!.description.validate(),
                        style: primaryTextStyle()),
                    8.height,
                    Divider(color: grey.withOpacity(0.3), thickness: 1),
                    8.height,
                  ],
                ).visible(widget.quizModel!.description.validate().isNotEmpty),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('No of questions' + ":", style: boldTextStyle()),
                    4.width,
                    Text('20', softWrap: true, style: primaryTextStyle())
                        .expand(),
                  ],
                ),
                8.height,
                Divider(color: grey.withOpacity(0.3), thickness: 1),
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quiz duration', style: boldTextStyle()),
                    4.width,
                    Text('20' + " minutes",
                            softWrap: true, style: primaryTextStyle())
                        .expand(),
                  ],
                ),
                // 8.height,
                // Divider(color: grey.withOpacity(0.3), thickness: 1),
                // 8.height,
                // Text('Choose University', style: boldTextStyle()),
                // 8.height,
                // DropdownButtonFormField(
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //           borderSide: BorderSide(color: black))),
                //   value: university,
                //   items: ['Any', '1', '2', '3']
                //       .map((label) => DropdownMenuItem(
                //             child: Text(label.toString()),
                //             value: label,
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       university = value.toString();
                //     });
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
