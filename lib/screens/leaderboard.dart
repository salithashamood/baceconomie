import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:baceconomie/components/leaderboard_component.dart';
import 'package:baceconomie/models/user_model.dart';
import 'package:baceconomie/screens/pickup_layout.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../locator.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  getUsers() async {
    return await locator
        .get<FirebaseFirestore>()
        .collection('users')
        .orderBy('totalPoints', descending: true)
        .get()
        .then((value) =>
            value.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            'Leaderboard',
            style: TextStyle(color: scaffoldColor),
          ),
          backgroundColor: colorPrimary,

          iconTheme: IconThemeData(color: scaffoldColor),
          // actions: [
          //   PopupMenuButton(
          //     itemBuilder: (context) {
          //       return List.generate(
          //         dropdownItems.length,
          //         (index) {
          //           return PopupMenuItem(
          //             value: dropdownItems[index],
          //             child: Text('${dropdownItems[index]}',
          //                 style: primaryTextStyle(),),
          //           );
          //         },
          //       );
          //     },
          //     onSelected: (dynamic value) {
          //       dropdownValue = value;
          //       setState(() {});
          //     },
          //   ),
          // ],
        ),
        body: FutureBuilder(
          future: getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<UserModel> data = snapshot.data as List<UserModel>;
              return data.isNotEmpty
                  ? ListView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        UserModel? mData = data[index];
                        if (index == 0) {
                          return Container(
                            width: context.width(),
                            height: 150,
                            decoration: boxDecorationWithShadow(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('1',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: context.width() > 450
                                                ? 40
                                                : 35))
                                    .paddingOnly(left: 20, right: 7),
                                CircleAvatar(
                                  radius: context.width() > 450 ? 50 : 40,
                                  child: mData.image!.isNotEmpty
                                      ? cachedImage(mData.image.validate(),
                                              usePlaceholderIfUrlEmpty: true,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover)
                                          .cornerRadiusWithClipRRect(60)
                                      : Icon(
                                          Feather.user,
                                          size: 90,
                                        ),
                                ).paddingAll(context.width() > 450 ? 5 : 2),
                                Container(
                                  width: 150,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: mData.name!,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              context.width() > 450 ? 24 : 19),
                                    ),
                                  ),
                                ).paddingLeft(4),
                                Spacer(),
                                Text(
                                  mData.totalPoints.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          context.width() > 450 ? 25 : 18),
                                ).paddingRight(context.width() > 450 ? 35 : 5),
                              ],
                            ),
                          ).paddingOnly(bottom: 25, left: 4, right: 4);
                        } else {
                          return LeaderboardComponent(
                            userModel: mData,
                            index: index + 1,
                          );
                        }
                      },
                    )
                  : emptyWidget();
            }

            return snapWidgetHelper(snapshot,
                defaultErrorMessage: errorSomethingWentWrong);
          },
        ).paddingAll(0),
      ),
    );
  }
}
