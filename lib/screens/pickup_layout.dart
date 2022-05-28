import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/user_model.dart';
import 'package:baceconomie/screens/inviting_screen.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:nb_utils/nb_utils.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  const PickupLayout({Key? key, required this.scaffold}) : super(key: key);

  Stream<DocumentSnapshot> getInviting() {
    // if(locator.get<AppStore>().userId!.isNotEmpty){
    //   locator.get<FirebaseFirestore>().collection('users').doc(locator.get<AppStore>().userId!).snapshots();
    // }
    return locator
        .get<FirebaseFirestore>()
        .collection('users')
        .doc(locator.get<AppStore>().userId!)
        .snapshots();
    // return null;
  }

  Future<DocumentSnapshot?> getInvitingDetails(String id) async {
    log("====== $id======");
    print("====== $id======");
    if (id.isNotEmpty) {
      return locator.get<FirebaseFirestore>().collection('users').doc(id).get();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: getInviting(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          UserModel userModel =
              UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          if (userModel.isAccepted!) {
            log("===== isAcceted=== ${userModel.isAccepted!}");
            return FutureBuilder<DocumentSnapshot?>(
              future: getInvitingDetails(userModel.invitedId!),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  UserModel invitedUser = UserModel.fromJson(
                      snapshots.data!.data() as Map<String, dynamic>);
                  return InvitingScreen(
                    categoryId: invitedUser.categoryId,
                    invitedData: invitedUser,
                    userData: userModel,
                    isAccepted: true,
                  );
                } else {
                  return scaffold;
                }
              },
            );
          } else if (userModel.invitingId != null &&
              userModel.invitingId!.isNotEmpty) {
            log("===== invitingId= ${userModel.invitingId}");
            return FutureBuilder<DocumentSnapshot?>(
              future: getInvitingDetails(userModel.invitingId!),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  UserModel initedUser = UserModel.fromJson(
                      snapshots.data!.data() as Map<String, dynamic>);
                  return InvitingScreen(
                    categoryId: initedUser.categoryId,
                    invitedData: initedUser,
                    userData: userModel,
                    isAccepted: false,
                  );
                } else {
                  return scaffold;
                }
              },
            );
          } else {
            return scaffold;
          }
        } else {
          return scaffold;
        }
      },
    );
  }
}
