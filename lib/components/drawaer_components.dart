import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:baceconomie/database/auth_services.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/drawer_item_model.dart';
import 'package:baceconomie/screens/login_screen.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/constants.dart';
import 'package:baceconomie/utils/data_providers.dart';
import 'package:baceconomie/utils/string.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class DrawerComponent extends StatefulWidget {
  static String tag = '/DrawerComponent';

  @override
  DrawerComponentState createState() => DrawerComponentState();
}

class DrawerComponentState extends State<DrawerComponent> {
  List<DrawerItemModel> drawerItemsList = getDrawerItems();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  void logout() {
    locator.get<AuthService>().logout().then((value) {
      LoginScreen().launch(context, isNewTask: true);
    }).catchError((e) {
      // toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: context.width(),
        height: context.height(),
        color: Theme.of(context).cardColor,
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Observer(
                builder: (context) => locator
                        .get<AppStore>()
                        .userProfileImage
                        .validate()
                        .isEmpty
                    ? Icon(
                        Icons.person_outline,
                        size: 40,
                        color: Theme.of(context).iconTheme.color,
                      )
                    : cachedImage(
                            locator.get<AppStore>().userProfileImage.validate(),
                            usePlaceholderIfUrlEmpty: true,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover)
                        .cornerRadiusWithClipRRect(60),
              ),
              title: Observer(
                  builder: (context) => Text(locator.get<AppStore>().userName!,
                      style: boldTextStyle())),
              onTap: () {
                finish(context);
                // ProfileScreen().launch(context);
              },
            ).paddingAll(8),
            Text(locator.get<AppStore>().userEmail!,
                    style: secondaryTextStyle())
                .paddingLeft(16),
            Divider(height: 20),
            Column(
              children: List.generate(
                drawerItemsList.length,
                (index) {
                  DrawerItemModel mData = drawerItemsList[index];

                  return SettingItemWidget(
                    leading: Image.asset(mData.image!, height: 30, width: 30),
                    title: mData.name!,
                    onTap: () {
                      if (mData.widget != null) {
                        LiveStream().emit(HideDrawerStream, true);
                        mData.widget.launch(context);
                      }
                      if (mData.name == lbl_home) {
                        finish(context);
                      } else if (mData.name == 'Logout') {
                        showConfirmDialog(context, 'Do you want to logout',
                                positiveText: 'Yes', negativeText: 'No')
                            .then(
                          (value) {
                            if (value ?? false) {
                              logout();
                            }
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
