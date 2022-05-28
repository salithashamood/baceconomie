import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baceconomie/database/base_service.dart';
import 'package:baceconomie/models/quiz_history_model.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:baceconomie/utils/model_keys.dart';

import '../locator.dart';
import '../store/appstore.dart';

class QuizHistoryService extends BaseService {
  QuizHistoryService() {
    ref = locator.get<FirebaseFirestore>().collection('users');
  }

  Future<List<QuizHistoryModel>> quizHistoryByQuizType(
      {String? quizType}) async {
    if (quizType == All) {
      return await ref
          .doc(locator.get<AppStore>().userId)
          .collection('quizHistory')
          .orderBy('createdAt', descending: true)
          .get()
          .then(
            // ignore: unnecessary_cast
            (value) => value.docs
                .map((e) =>
                    QuizHistoryModel.fromJson(e.data() as Map<String, dynamic>))
                .toList(),
          );
    }
    return await ref
        .where(QuizHistoryKeys.userId,
            isEqualTo: locator.get<AppStore>().userId)
        .where(QuizHistoryKeys.quizType, isEqualTo: quizType)
        .orderBy(CommonKeys.createdAt, descending: true)
        .get()
        .then((value) => value.docs
            .map((e) =>
                QuizHistoryModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }
}
