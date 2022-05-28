import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baceconomie/database/base_service.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/category_model.dart';

class CategoryService extends BaseService {
  CategoryService() {
    ref = locator.get<FirebaseFirestore>().collection('categories');
  }

  Future<List<CategoryModel>> categories() async {
    // return await ref.get().then((event) => event.docs.map((e) => CategoryModel.fromJson(e.data() as Map<String, dynamic>)).toList());
    return await locator
        .get<FirebaseFirestore>()
        .collection('categories')
        .where('parentCategoryId', isEqualTo: '')
        .get()
        .then((x) => x.docs
            .map(
                (y) => CategoryModel.fromJson(y.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<CategoryModel>> subCategories(String parentCategoryId) {
    return ref
        .where('parentCategoryId', isEqualTo: parentCategoryId)
        .get()
        .then((event) => event.docs
            .map(
                (e) => CategoryModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
    // return ref.get().then((event) => event.docs.map((e) => CategoryModel.fromJson(e.data())).toList());
  }
}
