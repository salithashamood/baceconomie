// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
// ignore: unused_import
import 'package:nb_utils/nb_utils.dart';

// Include generated file
part 'appstore.g.dart';

// This is the class used by rest of your codebase
class AppStore = _AppStore with _$AppStore;

// The store-class
abstract class _AppStore with Store {
  @observable
  bool isLoading = false;

  @observable
  String? userName = '';

  @observable
  bool isLoggedIn = false;

  @observable
  String? userProfileImage = '';

  @observable
  String? userId = '';

  @observable
  String? userEmail = '';

@observable
  String? userFullName = '';

@observable
  bool isTester = false;

@observable
  int? totalPoints;

  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setLoggedIn(bool value) {
    isLoggedIn = value;
  }

  @action
  void setName(String? name) {
    userName = name;
  }

  @action
  void setUserId(String? value) {
    userId = value;
  }

  @action
  void setUserEmail(String? value) {
    userEmail = value;
  }

  @action
  void setTotalPoints(int? value) {
    totalPoints = value;
  }

  @action
  void setProfileImage(String? image) {
    userProfileImage = image;
  }

  @action
  void setFullName(String? name) {
    userFullName = name;
  }

  @action
  void setUserProfile(String? image) {
    userProfileImage = image;
  }
}
