import 'httptool.dart';
import 'package:flutter_kchart/user/model/user_entity.dart';

class HttpUser {
  static const String url = "http://localhost:8889/user";

  static Future<UserEntity> registerUser(String email) async {
    // String url = "http://localhost:8888/user";
    Map<String, dynamic> params = {"email": email};
    Map<String, dynamic> results = await HttpTool.tool.post(url, params);
    if (results['error'] != null) {
      return null;
    }

    UserEntity user = UserEntity.fromJson(results);
    return user;
  }

  static login(String email, String pwd) async {
    if (email == null || pwd == null) {
      return;
    }
    String loginUrl = "$url?login=1";
    Map<String, dynamic> params = {"email": email};
    Map<String, dynamic> results = await HttpTool.tool.post(loginUrl, params);

    if (results == null) {
      return null;
    }
    UserEntity user = UserEntity.fromJson(results);
    return user;
  }

  void updateUser() {}

  void deleteUser() {}
}
