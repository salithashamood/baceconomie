import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/quiz_data.dart';
import 'package:baceconomie/utils/model_keys.dart';
import 'base_service.dart';

class QuizService extends BaseService {
  QuizService() {
    ref = locator.get<FirebaseFirestore>().collection('quiz');
  }

  Future<List<QuizData>> getQuizByCatId(String? id) async {
    return await ref.where(QuizKeys.categoryId, isEqualTo: id).get().then(
        (event) => event.docs
            .map((e) => QuizData.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<QuizData>> getQuizBySubCatId(String id) async {
    return await ref.where('subcategoryId', isEqualTo: id).get().then((event) =>
        event.docs
            .map((e) => QuizData.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<QuizData>> getQuizByQuizId(String? id) async {
    return await ref.where(CommonKeys.id, isEqualTo: id).get().then((event) =>
        event.docs
            .map((e) => QuizData.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }
}
