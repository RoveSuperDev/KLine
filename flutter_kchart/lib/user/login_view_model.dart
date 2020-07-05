import 'package:flutter_kchart/user/model/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class LoginViewModel with ChangeNotifier {
   UserEntity loginUser;

  // initParams() async {
  //   SharedPreferences pre = await SharedPreferences.getInstance();
  //   String userStr =  pre.get("user");
  //   Map<String,dynamic> userMap = json.decode(userStr);
  //   loginUser = UserEntity.fromJson(userMap);
  // }

  loginSucess(UserEntity userEntity) {
    loginUser = userEntity;
    notifyListeners();
  }
}