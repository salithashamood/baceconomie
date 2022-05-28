// ignore: unused_import
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:baceconomie/models/quiz_history_model.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../locator.dart';

class QuizHistoryComponent extends StatefulWidget {
  static String tag = '/QuizHistoryComponent';

  final QuizHistoryModel? quizHistoryData;

  QuizHistoryComponent({this.quizHistoryData});

  @override
  QuizHistoryComponentState createState() => QuizHistoryComponentState();
}

class QuizHistoryComponentState extends State<QuizHistoryComponent> {
  int point = 0;
  int invitedPoint = 0;
  String photoURL = '';
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
    setState(() {
      point = widget.quizHistoryData!.point!;
      invitedPoint = widget.quizHistoryData!.invitedPoint!;
    });

    await locator
        .get<FirebaseFirestore>()
        .collection('users')
        .doc(widget.quizHistoryData!.invitedId)
        .get()
        .then((value) {
      photoURL = value.get('photoUrl');
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.only(bottom: 25, left: 16, right: 16),
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: BorderRadius.circular(50),
          backgroundColor: Theme.of(context).cardColor),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          10.width,
          point > invitedPoint
              ? Text(
                  'Win',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )
              : Text('Lose',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
          16.width,
          16.width,
          Text(
            'vs',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          16.width,
          CircleAvatar(
            radius: 25,
            child: locator.get<AppStore>().userProfileImage!.isNotEmpty
                ? cachedImage(
                        locator.get<AppStore>().userProfileImage.validate(),
                        usePlaceholderIfUrlEmpty: true,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover)
                    .cornerRadiusWithClipRRect(60)
                : Icon(
                    Feather.user,
                    size: 30,
                  ),
          ),
          16.width,
          Text(
            point.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          10.width,
        ],
      ),
      // Row(
      //   children: [
      //     widget.quizHistoryData!.quizType != QuizTypeSelfChallenge ? Image.network(widget.quizHistoryData!.image!, height: 100, fit: BoxFit.fill).cornerRadiusWithClipRRect(defaultRadius).expand(flex: 2) : SizedBox(),
      //     widget.quizHistoryData!.quizType != QuizTypeSelfChallenge ? 16.width : SizedBox(),
      //     Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text('${widget.quizHistoryData!.quizTitle}', maxLines: 2, overflow: TextOverflow.ellipsis, style: primaryTextStyle()),
      //         8.height,
      //         Text('Score: ${widget.quizHistoryData!.rightQuestion}/${widget.quizHistoryData!.totalQuestion}', style: boldTextStyle()),
      //         8.height,
      //         Text('${DateFormat('dd-MM-yyyy kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(widget.quizHistoryData!.createdAt!.microsecondsSinceEpoch))}', style: secondaryTextStyle()),
      //       ],
      //     ).expand(flex: 3),
      //   ],
      // ),
    );
  }
}
