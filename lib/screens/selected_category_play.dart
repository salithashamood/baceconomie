import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:baceconomie/database/quiz_service.dart';
import 'package:baceconomie/locator.dart';
import 'package:baceconomie/models/quiz_data.dart';
import 'package:baceconomie/models/user_model.dart';
import 'package:baceconomie/screens/pickup_layout.dart';
import 'package:baceconomie/screens/play_online_quiz_screen.dart';
import 'package:baceconomie/screens/quiz_description_screen_along.dart';
import 'package:baceconomie/store/appstore.dart';
import 'package:baceconomie/utils/colors.dart';
import 'package:baceconomie/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SelectedCategoryPlay extends StatefulWidget {
  final String? catName, catId;
  final bool isSub;
  const SelectedCategoryPlay(
      {Key? key, this.catName, this.catId, required this.isSub})
      : super(key: key);

  @override
  _SelectedCategoryPlayState createState() => _SelectedCategoryPlayState();
}

class _SelectedCategoryPlayState extends State<SelectedCategoryPlay> {
  QuizData quizData = QuizData();
  // ignore: unused_field
  int? _index;
  int? _indexS;
  bool isTyping = false;
  List<UserModel> userList = [];
  String query = '';
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  getUsers() async {
    try {
      var snapshot = await locator
          .get<FirebaseFirestore>()
          .collection('users')
          .where('id', isNotEqualTo: locator.get<AppStore>().userId)
          .get()
          .then((value) =>
              value.docs.map((e) => UserModel.fromJson(e.data())).toList());
      return snapshot;
    } catch (e) {
      // toast(e.toString());
    }
  }

  Future getQuiz() async {
    if (widget.isSub) {
      await QuizService()
          .getQuizBySubCatId(widget.catId!)
          .then((value) => value.map((e) {
                quizData = e;
              }).toList());
    } else {
      await QuizService()
          .getQuizByCatId(widget.catId)
          .then((value) => value.map((e) {
                quizData = e;
              }).toList());
    }
  }

  stopInvite(String id) async {
    await locator
        .get<FirebaseFirestore>()
        .collection('users')
        .doc(id)
        .update({'invitingId': ''});
  }

  @override
  void initState() {
    super.initState();
    getQuiz();
    getUserList();
  }

  getUserList() async {
    var snapshot = await locator
        .get<FirebaseFirestore>()
        .collection('users')
        .where('id', isNotEqualTo: locator.get<AppStore>().userId)
        .get();
    for (var i = 0; i < snapshot.docs.length; i++) {
      userList.add(UserModel.fromJson(snapshot.docs[i].data()));
    }
    return userList;
  }

  buildSuggestions(String query) {
    final List<UserModel> suggestionList = query.isEmpty
        ? []
        : userList.where((UserModel user) {
            String _getUsername = user.name?.toLowerCase() ?? '';
            String _query = query.toLowerCase();
            String _getName = user.name?.toLowerCase() ?? '';
            bool matchUsername = _getUsername.contains(_query);
            bool matchName = _getName.contains(_query);

            return (matchUsername || matchName);
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        bool _isSelected = index == _indexS;
        UserModel searchedUser = UserModel(
          id: suggestionList[index].id,
          name: suggestionList[index].name,
          image: suggestionList[index].image,
          invitedId: suggestionList[index].invitedId,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5),
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                child: searchedUser.image!.isNotEmpty
                    ? cachedImage(
                        searchedUser.image.validate(),
                        usePlaceholderIfUrlEmpty: true,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(60)
                    : Icon(
                        Feather.user,
                        size: 30,
                      ),
              ),
              title: Text(searchedUser.name!),
              trailing: _isSelected
                  ? Container(
                      width: 50,
                      child: Text('Invited'),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Invite',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ).onTap(
                          () {
                            showConfirmDialog(
                              context,
                              'Do you want invite ${searchedUser.name} ?',
                              positiveText: 'Yes',
                              negativeText: 'No',
                            ).then(
                              (value) async {
                                if (value) {
                                  if (searchedUser.invitedId != null) {
                                    setState(() {
                                      _indexS = index;
                                    });
                                    toast('Invited');
                                    await locator
                                        .get<FirebaseFirestore>()
                                        .collection('users')
                                        .doc(searchedUser.id)
                                        .update({
                                      'isLoading': true,
                                      'invitingId':
                                          locator.get<AppStore>().userId
                                    }).then((value) {
                                      // FriendsScreen(
                                      //   inviteId: userData.id,
                                      //   catId: widget.catId,
                                      //   catName: widget.catName,
                                      // ).launch(context);
                                    });
                                  } else {
                                    toast(
                                        '${searchedUser.name} is in another game');
                                  }
                                  Future.delayed(Duration(seconds: 60))
                                      .then((value) {
                                    setState(() {
                                      _indexS = null;
                                    });
                                    stopInvite(searchedUser.id!);
                                  });
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    ).expand();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyBoardVisible) {
      return PickupLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: scaffoldColor),
            title:
                Text('Select Option', style: TextStyle(color: scaffoldColor)),
            backgroundColor: colorPrimary,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.5),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Play Private',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ).onTap(() {
                  QuizDescriptionScreenAlong(
                    quizModel: quizData,
                  ).launch(context);
                }),
              ),
              1.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 0.5),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Play with Random Friend',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ).onTap(() {
                  PlayOnlineQuizScreen(
                          catId: widget.catId, catName: widget.catName)
                      .launch(context);
                }),
              ),
              1.height,
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(color: colorSecondary),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Invite Friends',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: PreferredSize(
                      preferredSize: Size.fromHeight(kToolbarHeight + 20),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: TextField(
                          key: _key,
                          focusNode: focusNode,
                          autofocus: false,
                          controller: searchController,
                          onChanged: (val) {
                            setState(() {
                              query = val;
                              isTyping = true;
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  isTyping = false;
                                });
                                searchController.clear();
                              },
                            ),
                            border: InputBorder.none,
                            hintText: 'Search',
                          ),
                        ),
                      ),
                    ),
                  ),
                  isTyping ? buildSuggestions(query) : Container(),
                  // FutureBuilder(
                  //     future: getUsers(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.done) {
                  //         List<UserModel> data =
                  //             snapshot.data as List<UserModel>;
                  //         return ListView.builder(
                  //           itemCount: data.length,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             bool _isSelected = index == _index;
                  //             UserModel userData = data[index];
                  //             return Padding(
                  //               padding:
                  //                   const EdgeInsets.symmetric(vertical: 8),
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                   border: Border(
                  //                     bottom: BorderSide(width: 0.5),
                  //                   ),
                  //                 ),
                  //                 child: ListTile(
                  //                   leading: CircleAvatar(
                  //                     radius: 25,
                  //                     child: userData.image!.isNotEmpty
                  //                         ? cachedImage(
                  //                             userData.image.validate(),
                  //                             usePlaceholderIfUrlEmpty:
                  //                                 true,
                  //                             height: 80,
                  //                             width: 80,
                  //                             fit: BoxFit.cover,
                  //                           ).cornerRadiusWithClipRRect(60)
                  //                         : Icon(
                  //                             Feather.user,
                  //                             size: 30,
                  //                           ),
                  //                   ),
                  //                   title: Text(userData.name!),
                  //                   trailing: _isSelected
                  //                       ? Container(
                  //                           width: 50,
                  //                           child: Text('Invited'),
                  //                         )
                  //                       : Container(
                  //                           decoration: BoxDecoration(
                  //                               border: Border.all(),
                  //                               borderRadius:
                  //                                   BorderRadius.circular(
                  //                                       10)),
                  //                           child: Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(8.0),
                  //                             child: Text(
                  //                               'Invite',
                  //                               style: TextStyle(
                  //                                 fontWeight:
                  //                                     FontWeight.w500,
                  //                                 fontSize: 15,
                  //                               ),
                  //                             ).onTap(() {
                  //                               showConfirmDialog(
                  //                                 context,
                  //                                 'Do you want invite ${userData.name} ?',
                  //                                 positiveText: 'Yes',
                  //                                 negativeText: 'No',
                  //                               ).then(
                  //                                 (value) async {
                  //                                   if (value ?? false) {
                  //                                     if (userData
                  //                                             .invitedId !=
                  //                                         null) {
                  //                                       stopInvite(data[
                  //                                               _index ?? 0]
                  //                                           .id!);
                  //                                       setState(() {
                  //                                         _index = index;
                  //                                       });
                  //                                       toast('Invited');
                  //                                       await locator.get<FirebaseFirestore>()
                  //                                           .collection(
                  //                                               'users')
                  //                                           .doc(
                  //                                               userData.id)
                  //                                           .update({
                  //                                         'isLoading': true,
                  //                                         'invitingId':
                  //                                             appStore
                  //                                                 .userId
                  //                                       }).then((value) {
                  //                                         // FriendsScreen(
                  //                                         //   inviteId: userData.id,
                  //                                         //   catId: widget.catId,
                  //                                         //   catName: widget.catName,
                  //                                         // ).launch(context);
                  //                                       });
                  //                                     } else {
                  //                                       toast(
                  //                                           '${userData.name} is in another game');
                  //                                     }
                  //                                     Future.delayed(
                  //                                             Duration(
                  //                                                 seconds:
                  //                                                     60))
                  //                                         .then((value) {
                  //                                       setState(() {
                  //                                         _index = null;
                  //                                       });
                  //                                       stopInvite(
                  //                                           userData.id!);
                  //                                     });
                  //                                   }
                  //                                 },
                  //                               );
                  //                             }),
                  //                           ),
                  //                         ),
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         );
                  //       } else {
                  //         return Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       }
                  //     },
                  //   ).expand(),
                ],
              ).expand(),
            ],
          ),
        ),
      );
    });
  }
}
