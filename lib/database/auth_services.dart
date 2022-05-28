import 'package:firebase_auth/firebase_auth.dart';
import 'package:baceconomie/database/user_DB_service.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/user_model.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:baceconomie/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithEmailPassword(
      {required String email,
      required String password,
      String? displayName}) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (value) async {
        final User user = value.user!;

        UserModel userModel = UserModel();

        userModel.email = user.email;
        userModel.id = user.uid;
        userModel.name = displayName.validate();
        userModel.password = password.validate();
        userModel.createdAt = DateTime.now();
        userModel.image = user.photoURL.validate();
        userModel.isAdmin = false;
        userModel.isOnline = false;
        userModel.isAnswerd = false;
        userModel.isLoading = false;
        userModel.isAccepted = false;
        userModel.isNewPoint = false;
        userModel.inviteId = '';
        userModel.invitedId = '';
        userModel.invitingId = '';
        userModel.isNotificationOn = false;
        userModel.isSuperAdmin = false;
        userModel.isTestUser = false;
        //userModel.masterPwd = '';

        if (!(await locator.get<UserDBService>().isUserExists(user.email))) {
          log('User not exits');
          print("USERRR ${user.uid}");
          await locator
              .get<UserDBService>()
              .addDocumentWithCustomId(user.uid, userModel.toJson())
              .then(
                (value) {},
              )
              .catchError(
            (e) {
              throw e;
            },
          );
        }

        return locator.get<UserDBService>().getUserByEmail(email).then(
          (user) async {
            await setValue(USER_ID, user.id);
            await setValue(USER_DISPLAY_NAME, user.name);
            await setValue(USER_EMAIL, user.email);
            await setValue(USER_POINTS, user.totalPoints.validate());
            await setValue(USER_PHOTO_URL, user.image.validate());
            // await setValue(USER_MASTER_PWD, user.masterPwd.validate());
            await setValue(IS_LOGGED_IN, true);

            locator.get<AppStore>().setLoggedIn(true);
            locator.get<AppStore>().setUserId(user.id);
            locator.get<AppStore>().setName(user.name);
            locator.get<AppStore>().setProfileImage(user.image);
            locator.get<AppStore>().setUserEmail(user.email);

            await locator.get<UserDBService>().updateDocument(
                {CommonKeys.updatedAt: DateTime.now()}, user.id);
          },
        ).catchError(
          (e) {
            throw e;
          },
        );
      },
    ).catchError(
      (error) async {
        if (!await isNetworkAvailable()) {
          throw 'Please check network connection';
        }
        log(error.toString());
        throw 'Enter valid email and password';
      },
    );
  }

  Future<void> signUpWithEmailPassword(
      {required String email, required String password, String? name}) async {
    await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then(
      (values) async {
        await signInWithEmailPassword(
            email: values.user!.email!, password: password, displayName: name);
      },
    ).catchError(
      (error) {
        print('error1 : $error');
        throw 'Email already exists';
      },
    );
  }

  Future<void> logout() async {
    await removeKey(USER_DISPLAY_NAME);
    await removeKey(USER_EMAIL);
    await removeKey(USER_PHOTO_URL);
    await removeKey(IS_LOGGED_IN);
    await removeKey(USER_POINTS);

    locator.get<AppStore>().setLoggedIn(false);
    locator.get<AppStore>().setUserId('');
    locator.get<AppStore>().setName('');
    locator.get<AppStore>().setUserEmail('');
    locator.get<AppStore>().setProfileImage('');
  }
}
