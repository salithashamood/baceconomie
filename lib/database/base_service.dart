import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baceconomie/utils/model_keys.dart';

abstract class BaseService {
  late CollectionReference ref;

  Future<DocumentReference> addDocument(Map<String, dynamic> data) async {
    var doc = await ref.add(data);
    doc.update({CommonKeys.id: doc.id});
    return doc;
  }

  Future<void> addDocumentWithCustomId(
      String id, Map<String, dynamic> data) async {
    return await ref.doc(id).set(data);
  }

  Future<void> updateDocument(Map<String, dynamic> data, String? id) async {
    return await ref.doc(id).update(data);
  }

  Future removeDocument(String id) => ref.doc(id).delete();
}
