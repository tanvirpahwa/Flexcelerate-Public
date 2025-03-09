//allows the user id from firebase to be easily accessible
import 'package:flutter/cupertino.dart';

class Users {

  final String? uid;
  final UserData? userData;

  Users({ this.uid, this.userData });

}

class UserData {

  final String uid;
  late final String firstName;
  late final String lastName;
  late final String age;
  late final String height;
  late final String weight;
  late final String gender;
  late final ImageProvider? profilePhoto;
  final String? weightGoal;
  final int? calorieGoal;
  final int? stepsGoal;

  UserData({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    this.profilePhoto,
    this.weightGoal,
    this.calorieGoal,
    this.stepsGoal,
  });

}

class UserDataSingleton {

  static final UserDataSingleton _instance = UserDataSingleton._internal();

  factory UserDataSingleton() {
    return _instance;
  }

  UserData? _userData;

  UserData? get userData => _userData;

  void setUserData(UserData? userData) {
    _userData = userData;
  }

  UserDataSingleton._internal();

}