import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:baceconomie/models/quiz_data.dart';
import 'package:baceconomie/screens/selected_category_play.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../database/category_service.dart';
import '../database/quiz_service.dart';
import '../locator.dart';
import '../models/category_model.dart';

class QuizScreen extends StatefulWidget {
  static String tag = '/QuizScreen';

  final String? catName, catId;

  QuizScreen({this.catName, this.catId});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  int? subcategoryIndex;
  List<QuizData> quizData = [];
  String? subCatId;
  bool hasSubCat = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    locator.get<CategoryService>().subCategories(widget.catId!).then(
      (value) {
        if (value.isNotEmpty) {
          hasSubCat = true;
          setState(() {});
        }
      },
    ).catchError(
      (error) {
        log(error);
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: scaffoldColor),
        brightness: Brightness.dark,
        title: Text(
          '${widget.catName}',
          style: TextStyle(color: scaffoldColor),
        ),
        backgroundColor: colorPrimary,
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: locator.get<CategoryService>().subCategories(widget.catId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  CategoryModel mData = snapshot.data![index];

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    decoration: boxDecorationWithRoundedCorners(
                      // borderRadius: BorderRadius.circular(20),
                      backgroundColor: subcategoryIndex == index
                          ? colorPrimary
                          : context.cardColor,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      shape: Border(
                          bottom: BorderSide(
                        width: 1,
                        color: colorPrimary,
                      )),
                      title: Text(
                        mData.name!,
                        style: boldTextStyle(
                            color: subcategoryIndex == index
                                ? white
                                : Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ).onTap(
                    () {
                      subcategoryIndex = index;
                      subCatId = mData.id;
                      SelectedCategoryPlay(
                        catId: mData.id,
                        catName: mData.name,
                        isSub: true,
                      ).launch(context);
                      setState(() {});
                    },
                  );
                },
              );
            }
          }
          // return snapWidgetHelper(snapshot, defaultErrorMessage: errorSomethingWentWrong).center();
          return SizedBox();
        },
      ).paddingOnly(top: 16, right: 16, left: 16),
    );
  }
}
