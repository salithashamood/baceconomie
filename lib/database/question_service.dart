import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baceconomie/database/base_service.dart';
import 'package:baceconomie/database/category_service.dart';
import 'package:baceconomie/models/question_data.dart';
import 'package:baceconomie/utils/model_keys.dart';

import '../locator.dart';

class QuestionService extends BaseService {
  QuestionService() {
    ref = locator.get<FirebaseFirestore>().collection('question');
  }

  Future<QuestionData> questionById(String id) async {
    //return await ref.where('id', isEqualTo: id).limit(1).get().then((value) => QuestionModel.fromJson(value.docs.first.data()));
    return await ref
        .where(CommonKeys.id, isEqualTo: id)
        .limit(1)
        .get()
        .then((ress) {
      if (ress.docs.isNotEmpty) {
        return QuestionData.fromJson(
            ress.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'Not available';
      }
    }).catchError((onError) {
      print('onError :$onError');
    });
  }

  Future<List<QuestionData>> questionByCatId(String? catId) async {
    return await ref
        .where(QuestionKeys.category,
            isEqualTo: locator.get<CategoryService>().ref.doc(catId))
        .get()
        .then(
      (event) {
        return event.docs
            .map((e) => QuestionData.fromJson(e.data() as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
