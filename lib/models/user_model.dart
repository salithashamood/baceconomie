import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baceconomie/utils/model_keys.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? image;
  String? password;
  String? loginType;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isNotificationOn;
  int? themeIndex;
  String? appLanguage;
  String? oneSignalPlayerId;
  bool? isAdmin;
  bool? isSuperAdmin;
  bool? isTestUser;
  bool? isOnline = false;
  int? points;
  String? inviteId;
  String? invitedId;
  bool? isLoading = false;
  String? categoryId;
  bool? isAnswerd = false;
  bool? isNewPoint = false;
  int? totalPoints;
  String? invitingId;
  bool? isAccepted = false;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.image,
    this.password,
    this.loginType,
    this.createdAt,
    this.updatedAt,
    this.isNotificationOn,
    this.themeIndex,
    this.appLanguage,
    this.oneSignalPlayerId,
    this.isAdmin,
    this.isSuperAdmin,
    this.isTestUser,
    this.isOnline,
    this.points,
    this.inviteId,
    this.invitedId,
    this.isLoading,
    this.categoryId,
    this.isAnswerd,
    this.isNewPoint,
    this.totalPoints,
    this.invitingId,
    this.isAccepted,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[CommonKeys.id],
      name: json[UserKeys.name],
      email: json[UserKeys.email],
      image: json[UserKeys.photoUrl],
      password: json[UserKeys.password],
      loginType: json[UserKeys.loginType],
      isNotificationOn: json[UserKeys.isNotificationOn],
      themeIndex: json[UserKeys.themeIndex],
      appLanguage: json[UserKeys.appLanguage],
      oneSignalPlayerId: json[UserKeys.oneSignalPlayerId],
      isAdmin: json[UserKeys.isAdmin],
      isSuperAdmin: json[UserKeys.isSuperAdmin],
      isTestUser: json[UserKeys.isTestUser],
      isOnline: json['isOnline'],
      inviteId: json['inviteId'],
      invitedId: json['invitedId'],
      isLoading: json['isLoading'],
      categoryId: json['categoryId'],
      isAnswerd: json['isAnswerd'],
      isNewPoint: json['isNewPoint'],
      totalPoints: json['totalPoints'],
      invitingId: json['invitingId'],
      isAccepted: json['isAccepted'],
      points: json[UserKeys.points],
      createdAt: json[CommonKeys.createdAt] != null
          ? (json[CommonKeys.createdAt] as Timestamp).toDate()
          : null,
      updatedAt: json[CommonKeys.updatedAt] != null
          ? (json[CommonKeys.updatedAt] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[UserKeys.name] = this.name;
    data[UserKeys.email] = this.email;
    data[UserKeys.photoUrl] = this.image;
    data[UserKeys.password] = this.password;
    data[UserKeys.loginType] = this.loginType;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[UserKeys.isNotificationOn] = this.isNotificationOn;
    data[UserKeys.themeIndex] = this.themeIndex;
    data[UserKeys.appLanguage] = this.appLanguage;
    data[UserKeys.oneSignalPlayerId] = this.oneSignalPlayerId;
    data[UserKeys.isAdmin] = this.isAdmin;
    data[UserKeys.isSuperAdmin] = this.isSuperAdmin;
    data[UserKeys.isTestUser] = this.isTestUser;
    data['isOnline'] = this.isOnline;
    data[UserKeys.points] = this.points;
    data['inviteId'] = this.inviteId;
    data['invitedId'] = this.invitedId;
    data['isLoading'] = this.isLoading;
    data['categoryId'] = this.categoryId;
    data['isAnswerd'] = this.isAnswerd;
    data['isNewPoint'] = this.isNewPoint;
    data['totalPoints'] = this.totalPoints;
    data['invitingId'] = this.invitingId;
    data['isAccepted'] = this.isAccepted;
    return data;
  }
}
