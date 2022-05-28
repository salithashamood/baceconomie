import 'package:baceconomie/models/drawer_item_model.dart';
import 'package:baceconomie/screens/leaderboard.dart';
import 'package:baceconomie/screens/my_quiz_history_screen.dart';
import 'package:baceconomie/screens/profile_screen.dart';
import 'package:baceconomie/screens/quiz_category_screen.dart';
import 'package:baceconomie/utils/images.dart';

import 'model_keys.dart';

String description =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";

List<DrawerItemModel> getDrawerItems() {
  List<DrawerItemModel> drawerItems = [];
  drawerItems.add(DrawerItemModel(name: 'Home', image: HomeImage));
  // drawerItems.add(DrawerItemModel(
  //   name: 'Online Quiz',
  //   image: onlineQuizImage,
  //   widget: TotalOnlineQuizScreen(),
  // ));
  //drawerItems.add(DrawerItemModel(
  //  name: 'Play Online Quiz',
  //  image: onlineQuizImage,
  //  widget: QuizCategoryScreen()));
  drawerItems.add(DrawerItemModel(
      name: 'Profile', image: ProfileImage, widget: ProfileScreen()));
  drawerItems.add(DrawerItemModel(
      name: 'Quiz Category',
      image: QuizCategoryImage,
      widget: QuizCategoryScreen()));
  drawerItems.add(DrawerItemModel(
      name: 'My Quiz History',
      image: QuizHistoryImage,
      widget: MyQuizHistoryScreen()));
  drawerItems.add(DrawerItemModel(
      name: 'Leaderboard', image: SettingImage, widget: Leaderboard()));
  // drawerItems.add(DrawerItemModel(
  //     name: 'Admin Login',
  //     image: QuizCategoryImage,
  //     widget: AdminLoginScreen()));
  // drawerItems.add(DrawerItemModel(
  //     name: 'Setting', widget: SettingScreen(), image: SettingImage));
  // drawerItems.add(DrawerItemModel(
  //     name: 'About Us', image: AboutUsImage, widget: AboutUsScreen()));
  // drawerItems.add(DrawerItemModel(name: 'Rate Us', image: RateUsImage));
  drawerItems.add(DrawerItemModel(name: 'Logout', image: LogoutImage));
  return drawerItems;
}

List<WalkThroughItemModel> getWalkThroughItems() {
  List<WalkThroughItemModel> walkThroughItems = [];
  walkThroughItems.add(
    WalkThroughItemModel(
      image: WalkThroughImage1,
      title: 'Grile pentru bacul la economie',
      subTitle:
          'Doresti sa participi la examenul de bacalaureat? Aceasta aplicatie a fost creată special pentru viitorii studenti pentru a-si testa cunostintele si  pentru a-si antrena spiritul competitiv.',
    ),
  );
  walkThroughItems.add(
    WalkThroughItemModel(
      image: WalkThroughImage2,
      title: 'Provoaca-ti Prietenii 🔥',
      subTitle:
          'Esti pregătit sa iti testezi cunostintele impreuna cu prietenii tai? Noile opțiuni ale aplicației iti permit sa iti inviti prietenii sa joace împotriva ta sau poți alege sa joci împotriva altor utilizatori ai aplicației noastre.',
    ),
  );
  walkThroughItems.add(
    WalkThroughItemModel(
      image: WalkThroughImage3,
      title: 'Vezi pe ce loc te clasezi',
      subTitle:
          'Datorită noilor opțiuni ale aplicației noastre poți vedea pe ce loc te clasezi In leaderboardul tarii tale, astfel iti poți maximiza sansele de a fi admis la facultate.',
    ),
  );
  return walkThroughItems;
}

List<DrawerItemModel> getQuestionTypeList() {
  List<DrawerItemModel> questionTypeList = [];
  questionTypeList
      .add(DrawerItemModel(image: OptionQuiz, name: QuestionTypeKeys.options));
  questionTypeList.add(
      DrawerItemModel(image: TruFalseQuiz, name: QuestionTypeKeys.trueFalse));

  return questionTypeList;
}

/*List<AddAnswerModel> getAddAnswerList() {
  List<AddAnswerModel> addAnswerList = [];
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer', color: addAnswerBgColor1));
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer', color: addAnswerBgColor2));
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer \n    (Optional)', color: colorPrimary));
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer \n    (Optional)', color: colorSecondary));

  return addAnswerList;
}*/

List<AddAnswerModel> getAddAnswerList() {
  List<AddAnswerModel> addAnswerList = [];
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer'));
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer'));
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer'));
  addAnswerList.add(AddAnswerModel(name: '+  Add Answer'));

  return addAnswerList;
}

List<AddAnswerModel> getTrueFalseAddAnswerList() {
  List<AddAnswerModel> addTrueFalseAnswerList = [];
  addTrueFalseAnswerList.add(AddAnswerModel(name: 'True'));
  addTrueFalseAnswerList.add(AddAnswerModel(name: 'False'));

  return addTrueFalseAnswerList;
}
