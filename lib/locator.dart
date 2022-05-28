import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:baceconomie/store/appstore.dart';

import 'database/auth_services.dart';
import 'database/category_service.dart';
import 'database/question_service.dart';
import 'database/quiz_history_service.dart';
import 'database/user_DB_service.dart';

final locator = GetIt.instance;

setUp() {
  locator.registerLazySingleton<AppStore>(() => AppStore());
  locator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<UserDBService>(() => UserDBService());
  locator.registerLazySingleton<CategoryService>(() => CategoryService());
  locator.registerLazySingleton<QuestionService>(() => QuestionService());
  locator.registerLazySingleton<QuizHistoryService>(() => QuizHistoryService());
}


  // AppStore appStore = AppStore();

  // FirebaseFirestore db = FirebaseFirestore.instance;

  // AuthService authService = AuthService();

  // UserDBService userDBService = UserDBService();

  // CategoryService categoryService = CategoryService();

  // QuestionService questionService = QuestionService();

  // QuizHistoryService quizHistoryService = QuizHistoryService();