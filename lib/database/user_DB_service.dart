import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/user_model.dart';
import 'package:baceconomie/utils/model_keys.dart';

import 'base_service.dart';

class UserDBService extends BaseService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  UserDBService() {
    ref = locator.get<FirebaseFirestore>().collection('users');
  }

  Future<UserModel> getUserById(String id) {
    return ref.where(CommonKeys.id, isEqualTo: id).limit(1).get().then(
      (res) {
        if (res.docs.isNotEmpty) {
          return UserModel.fromJson(
              res.docs.first.data() as Map<String, dynamic>);
        } else {
          throw 'User not found';
        }
      },
    );
  }

  Future<UserModel> getUserByEmail(String? email) {
    return ref.where(UserKeys.email, isEqualTo: email).limit(1).get().then(
      (res) {
        if (res.docs.isNotEmpty) {
          return UserModel.fromJson(
              res.docs.first.data() as Map<String, dynamic>);
        } else {
          throw 'User not found';
        }
      },
    );
  }

  Future<bool> isUserExist(String? email, String loginType) async {
    Query query = ref
        .limit(1)
        .where(UserKeys.loginType, isEqualTo: loginType)
        .where(UserKeys.email, isEqualTo: email);

    var res = await query.get();

    return res.docs.length == 1;
  }

  Future<bool> isUserExists(String? id) async {
    return await getUserByEmail(id).then(
      (value) {
        return true;
      },
    ).catchError(
      (e) {
        return false;
      },
    );
  }

  Future<UserModel> loginUser(String email, String password) async {
    var data = await ref
        .where(UserKeys.email, isEqualTo: email)
        .where(UserKeys.password, isEqualTo: password)
        .limit(1)
        .get();

    if (data.docs.isNotEmpty) {
      return UserModel.fromJson(data.docs.first.data() as Map<String, dynamic>);
    } else {
      throw 'User not found';
    }
  }

  Future<UserModel?> saveUser(
      String email, String password, String name) async {
    // ignore: unused_local_variable
    var data = await ref.doc(_auth.currentUser!.uid).set({
      'email': email,
      'name': name,
      'uid': _auth.currentUser!.uid,
    }).then((value) {
      print('Data Added');
    }).catchError((onError) {
      print('erro3: $onError');
      throw 'Can not added data';
    });
  }
}
