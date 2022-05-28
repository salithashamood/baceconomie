import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:baceconomie/database/file_storage_service.dart';
import 'package:baceconomie/database/user_DB_service.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/screens/pickup_layout.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:baceconomie/utils/model_keys.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController nameController =
      TextEditingController(text: locator.get<AppStore>().userName);

  PickedFile? image;

  FocusNode nameFocus = FocusNode();

  int? points = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await locator
        .get<FirebaseFirestore>()
        .collection('users')
        .doc(locator.get<AppStore>().userId)
        .get()
        .then((value) {
      setState(() {
        points = value.get('totalPoints');
      });
    });
  }

  Widget profileImage() {
    if (image != null) {
      return Image.file(
        File(image!.path),
        height: 130,
        width: 130,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    } else {
      if (locator.get<AppStore>().userProfileImage.validate().isNotEmpty) {
        return cachedImage(
          locator.get<AppStore>().userProfileImage.validate(),
          height: 130,
          width: 130,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        );
      } else {
        return Icon(Icons.person_outline_rounded).paddingAll(16);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future update() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      locator.get<AppStore>().setLoading(true);
      setState(() {});

      Map<String, dynamic> req = {};

      if (nameController.text != locator.get<AppStore>().userName) {
        req.putIfAbsent(UserKeys.name, () => nameController.text.trim());
      }

      if (image != null) {
        await uploadFile(file: File(image!.path), prefix: 'userProfiles').then(
          (path) async {
            req.putIfAbsent(UserKeys.photoUrl, () => path);

            await setValue(USER_PHOTO_URL, path);
            locator.get<AppStore>().setProfileImage(path);
          },
        ).catchError(
          (e) {
            // toast(e.toString());
          },
        );
      }

      await locator
          .get<UserDBService>()
          .updateDocument(req, locator.get<AppStore>().userId)
          .then(
        (value) async {
          locator.get<AppStore>().setLoading(false);
          locator.get<AppStore>().setName(nameController.text);
          setValue(USER_DISPLAY_NAME, nameController.text);

          finish(context);
        },
      );
    }
  }

  Future getImage() async {
    image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: scaffoldColor),
          title: Text(
            'Profile',
            style: TextStyle(color: scaffoldColor),
          ),
          backgroundColor: colorPrimary,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: <Widget>[
                        Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 16,
                          margin: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80)),
                          child: profileImage(),
                        ),
                        Positioned(
                          child: CircleAvatar(
                            backgroundColor: colorPrimary,
                            radius: 12,
                            child: Icon(
                              Icons.edit,
                              color: black,
                              size: 20,
                            ).onTap(
                              () {
                                getImage();
                              },
                            ),
                          ),
                          right: 1,
                          bottom: 1,
                        ).visible(true),
                      ],
                    ).paddingOnly(top: 16, bottom: 16).center(),
                    Observer(
                        builder: (context) => Text(
                                locator.get<AppStore>().userName!,
                                style: boldTextStyle(size: 20))
                            .center()),
                    4.height,
                    Text('Points $points',
                            style: boldTextStyle(size: 18, color: colorPrimary))
                        .center(),
                    16.height,
                    Divider(),
                    16.height,
                    Text('Name', style: primaryTextStyle()),
                    8.height,
                    AppTextField(
                      controller: nameController,
                      textFieldType: TextFieldType.NAME,
                      focus: nameFocus,
                      decoration: inputDecoration(hintText: 'Name hint'),
                    ),
                    16.height,
                    Text('Email id', style: primaryTextStyle()),
                    8.height,
                    Text(locator.get<AppStore>().userEmail!,
                        style: boldTextStyle()),
                    30.height,
                    Container(
                      width: context.width(),
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorPrimary,
                            colorSecondary,
                          ],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(defaultRadius),
                      ),
                      child: TextButton(
                        child: Text('Update profile',
                            style: primaryTextStyle(color: white)),
                        onPressed: update,
                      ),
                    ),
                  ],
                ).paddingOnly(left: 16, right: 16),
              ),
            ),
            Observer(
              builder: (context) =>
                  Loader().visible(locator.get<AppStore>().isLoading),
            ),
          ],
        ),
      ),
    );
  }
}
