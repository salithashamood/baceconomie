// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic


mixin _$AppStore on _AppStore, Store {
  final _$isLoadingAtom = Atom(name: '_AppStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$userNameAtom = Atom(name: '_AppStore.userName');

  @override
  String? get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String? value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  final _$isLoggedInAtom = Atom(name: '_AppStore.isLoggedIn');

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  final _$userProfileImageAtom = Atom(name: '_AppStore.userProfileImage');

  @override
  String? get userProfileImage {
    _$userProfileImageAtom.reportRead();
    return super.userProfileImage;
  }

  @override
  set userProfileImage(String? value) {
    _$userProfileImageAtom.reportWrite(value, super.userProfileImage, () {
      super.userProfileImage = value;
    });
  }

  final _$userIdAtom = Atom(name: '_AppStore.userId');

  @override
  String? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(String? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  final _$userEmailAtom = Atom(name: '_AppStore.userEmail');

  @override
  String? get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String? value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }


  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  

  

  @override
  void setLoading(bool value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoggedIn(bool value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoggedIn');
    try {
      return super.setLoggedIn(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setName(String? name) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setName');
    try {
      return super.setName(name);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserId(String? value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setUserId');
    try {
      return super.setUserId(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserEmail(String? value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setUserEmail');
    try {
      return super.setUserEmail(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTotalPoints(int? value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.totalPoints');
    try {
      return super.setTotalPoints(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProfileImage(String? image) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setProfileImage');
    try {
      return super.setProfileImage(image);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
userName: ${userName},
isLoggedIn: ${isLoggedIn},
userProfileImage: ${userProfileImage},
userId: ${userId},
userEmail: ${userEmail},
    ''';
  }

  @override
  void setFullName(String? name) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setFullName');
    try {
      return super.setFullName(name);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserProfile(String? image) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setUserProfile');
    try {
      return super.setUserProfile(image);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  final _$isTesterAtom = Atom(name: '_AppStore.isTester');

  @override
  bool get isTester {
    _$isTesterAtom.reportRead();
    return super.isTester;
  }
}
