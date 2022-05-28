import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/user_model.dart';
import 'package:baceconomie/screens/friend_screen.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class InvitingScreen extends StatefulWidget {
  final UserModel? userData;
  final UserModel? invitedData;
  final String? categoryId;
  final bool? isAccepted;
  const InvitingScreen(
      {Key? key,
      this.userData,
      this.invitedData,
      this.categoryId,
      this.isAccepted})
      : super(key: key);

  @override
  _InvitingScreenState createState() => _InvitingScreenState();
}

class _InvitingScreenState extends State<InvitingScreen> {
  String? catName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future getCatName() async {
    await locator
        .get<FirebaseFirestore>()
        .collection('categories')
        .doc(widget.categoryId)
        .get()
        .then((value) {
      catName = value.get('name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Container(
        child: Center(
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              color: Color(0xFFF0C191),
              border: Border(
                bottom: BorderSide(width: 12, color: colorPrimary),
                left: BorderSide(width: 12, color: colorPrimary),
                right: BorderSide(width: 12, color: colorPrimary),
                top: BorderSide(width: 12, color: colorPrimary),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  widget.isAccepted!
                      ? '${widget.invitedData!.name!} accepted your invitation.'
                      : '${widget.invitedData!.name!} invite you to do a quiz together',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                widget.isAccepted!
                    ? AppButton(
                        color: colorPrimary,
                        text: 'Go To Game',
                        textColor: Colors.white,
                        onTap: () async {
                          FriendsScreen(
                            inviteId: widget.invitedData!.id,
                            catId: widget.invitedData!.categoryId,
                            catName: catName,
                          ).launch(context);
                          await locator
                              .get<FirebaseFirestore>()
                              .collection('users')
                              .doc(locator.get<AppStore>().userId)
                              .update({
                            'isAccepted': false,
                            'isLoading': false,
                            'invitedId': widget.invitedData!.id,
                            'invitingId': '',
                            'categoryId': widget.categoryId,
                          }).then((value) async {
                            await locator
                                .get<FirebaseFirestore>()
                                .collection('users')
                                .doc(widget.invitedData!.id)
                                .update({
                              'invitedId': locator.get<AppStore>().userId,
                              'invitingId': ''
                            });
                          });
                        },
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppButton(
                            color: colorPrimary,
                            text: 'Decline',
                            textColor: Colors.white,
                            onTap: () async {
                              await locator
                                  .get<FirebaseFirestore>()
                                  .collection('users')
                                  .doc(locator.get<AppStore>().userId)
                                  .update({
                                'isAccepted': false,
                                'isLoading': false,
                                'invitingId': '',
                              }).then((value) async {
                                await locator
                                    .get<FirebaseFirestore>()
                                    .collection('users')
                                    .doc(widget.invitedData!.id)
                                    .update({
                                  'isAccepted': false,
                                  'invitingId': ''
                                });
                              });
                            },
                          ),
                          AppButton(
                            color: colorPrimary,
                            text: 'Accept',
                            textColor: Colors.white,
                            onTap: () async {
                              FriendsScreen(
                                inviteId: widget.invitedData!.id,
                                catId: widget.categoryId,
                                catName: catName,
                              ).launch(context);
                              await locator
                                  .get<FirebaseFirestore>()
                                  .collection('users')
                                  .doc(locator.get<AppStore>().userId)
                                  .update({
                                'isLoading': false,
                                'invitedId': widget.invitedData!.id,
                                'invitingId': '',
                                'categoryId': widget.categoryId,
                              }).then((value) async {
                                await locator
                                    .get<FirebaseFirestore>()
                                    .collection('users')
                                    .doc(widget.invitedData!.id)
                                    .update({
                                  'isAccepted': true,
                                  'isLoading': true,
                                  'invitedId': locator.get<AppStore>().userId,
                                  'invitingId': ''
                                });
                              });
                            },
                          ),
                        ],
                      ),
                Spacer(),
              ],
            ),
          ).paddingSymmetric(horizontal: 45),
        ),
      ),
    );
  }
}
