// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:baceconomie/components/quiz_history_component.dart';
import 'package:baceconomie/database/quiz_history_service.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/quiz_history_model.dart';
import 'package:baceconomie/screens/pickup_layout.dart';
import 'package:baceconomie/screens/quiz_history_details_screen.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class MyQuizHistoryScreen extends StatefulWidget {
  static String tag = '/MyQuizHistoryScreen';

  @override
  MyQuizHistoryScreenState createState() => MyQuizHistoryScreenState();
}

class MyQuizHistoryScreenState extends State<MyQuizHistoryScreen> {
  List<String> dropdownItems = [
    All,
    QuizTypeDaily,
    QuizTypeSelfChallenge,
    QuizTypeCategory
  ];
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    dropdownValue = dropdownItems.first;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            'History',
            style: TextStyle(color: scaffoldColor),
          ),
          backgroundColor: colorPrimary,

          iconTheme: IconThemeData(color: scaffoldColor),
          // actions: [
          //   PopupMenuButton(
          //     itemBuilder: (context) {
          //       return List.generate(
          //         dropdownItems.length,
          //         (index) {
          //           return PopupMenuItem(
          //             value: dropdownItems[index],
          //             child: Text('${dropdownItems[index]}',
          //                 style: primaryTextStyle(),),
          //           );
          //         },
          //       );
          //     },
          //     onSelected: (dynamic value) {
          //       dropdownValue = value;
          //       setState(() {});
          //     },
          //   ),
          // ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder(
              future: locator
                  .get<QuizHistoryService>()
                  .quizHistoryByQuizType(quizType: dropdownValue),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QuizHistoryModel> data =
                      snapshot.data as List<QuizHistoryModel>;
                  return data.isNotEmpty
                      ? ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            QuizHistoryModel? mData = data[index];
                            return QuizHistoryComponent(quizHistoryData: mData)
                                .onTap(
                              () {
                                QuizHistoryDetailScreen(quizHistoryData: mData)
                                    .launch(context);
                              },
                            );
                          },
                        )
                      : emptyWidget();
                }
                return snapWidgetHelper(snapshot,
                    defaultErrorMessage: errorSomethingWentWrong);
              },
            ).paddingAll(16),
          ],
        ),
      ),
    );
  }
}
