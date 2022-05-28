import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:baceconomie/components/quize_category_components.dart';
import 'package:baceconomie/database/category_service.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/category_model.dart';
import 'package:baceconomie/screens/quiz_screen.dart';
import 'package:baceconomie/screens/pickup_layout.dart';
import 'package:baceconomie/screens/selected_category_play.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class QuizCategoryScreen extends StatefulWidget {
  static String tag = '/QuizCategoryScreen';

  @override
  QuizCategoryScreenState createState() => QuizCategoryScreenState();
}

class QuizCategoryScreenState extends State<QuizCategoryScreen> {
  List<CategoryModel> categoryItems = [];
  bool isLoading = false;
  // List category = ['Biologie', 'Chimie'];

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
    return PickupLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: scaffoldColor),
          title: Text(
            'Quiz Category',
            style: TextStyle(color: scaffoldColor),
          ),
          backgroundColor: colorPrimary,
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: locator.get<CategoryService>().categories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<CategoryModel> data =
                      snapshot.data as List<CategoryModel>;
                  return SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 20,
                        children: List.generate(
                          data.length,
                          (index) {
                            CategoryModel? mData = data[index];
                            return QuizCategoryComponent(category: mData).onTap(
                              () async {
                                await locator
                                    .get<FirebaseFirestore>()
                                    .collection('users')
                                    .doc(locator.get<AppStore>().userId)
                                    .update({
                                  'categoryId': mData.id,
                                });
                                await locator
                                    .get<CategoryService>()
                                    .subCategories(mData.id!)
                                    .then(
                                  (value) {
                                    if (value.isNotEmpty) {
                                      QuizScreen(
                                        catId: mData.id,
                                        catName: mData.name,
                                      ).launch(context);
                                    } else {
                                      SelectedCategoryPlay(
                                        catId: mData.id,
                                        catName: mData.name,
                                        isSub: false,
                                      ).launch(context);
                                    }
                                  },
                                ).catchError(
                                  (error) {
                                    log(error);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
                return snapWidgetHelper(snapshot, errorWidget: emptyWidget());
              },
            ),
          ],
        ),
      ),
    );
  }
}
