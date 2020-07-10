import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_kchart/network/httpuser.dart';
import 'package:flutter_kchart/user/model/user_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kchart/user/login_view_model.dart';
import 'dart:convert' as convert;
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.blue,
      //center,column 排版工具
      //container 实际元素
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: new Card(
                // elevation: 5.0,
                // shape: new RoundedRectangleBorder(
                // borderRadius: BorderRadius.all(Radius.circular(10)),
                // ),
                color: Colors.white,
                //card 固定外边距左右30
                //高度是子元素内容决定
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Padding(
                  //整体给这个元素配置一个内边距
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
                  child: Column(
                    //在主轴上
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //从上到下
                      // Image(
                      // image: AssetImage('static/logo.png'),
                      // height: 90,
                      // width: 90,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(labelText: '请输入邮箱'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: '请输入密码'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),

                      FlatButton(
                        color: Colors.blue,
                        //button让子元素撑起来
                        child: Container(
                          //子元素在父元素位置
                          alignment: Alignment.center,
                          height: 50,
                          width: double.infinity,
                          child:
                              Text('登录', style: TextStyle(color: Colors.white)),
                        ),
                        onPressed: () {
                          gotoLogin(context);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),

                      FlatButton(
                        color: Colors.blue,
                        //button让子元素撑起来
                        child: Container(
                          //子元素在父元素位置
                          alignment: Alignment.center,
                          height: 50,
                          width: double.infinity,
                          child:
                              Text('注册', style: TextStyle(color: Colors.white)),
                        ),
                        onPressed: () {
                          register(context);
                        },
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    ));
  }

  void register(context) {
    String email = usernameController.text;
    // String password = passwordController.text;
    HttpUser.registerUser(email).then<UserEntity>((value) {
      if(value == null){
         Fluttertoast.showToast(msg: '注册失败', gravity: ToastGravity.CENTER);
         return;
      }

      Fluttertoast.showToast(msg: '注册成功', gravity: ToastGravity.CENTER);
    });
  }

  void gotoLogin(context) {
    String username = usernameController.text;
    String password = passwordController.text;
    
    HttpUser.login(username, password).then<UserEntity>((value) {
      if(value == null){
        Fluttertoast.showToast(msg: '登录成功', gravity: ToastGravity.CENTER);
        return;
      }
      Fluttertoast.showToast(msg: '登录成功', gravity: ToastGravity.CENTER);
      LoginViewModel viewModel =  Provider.of<LoginViewModel>(context, listen: false);
      viewModel.loginSucess(value);
     
      saveLoginUser(value);
    });

    // requestMyInfo(username,password).then<User>((va  lue){
    //显示Toast
    // print('完成${value.toJson()}');
    // if(value!=null){
    // Fluttertoast.showToast(msg: '登录成功',gravity: ToastGravity.CENTER);
    // StoreProvider storeProvider = Provider.of<StoreProvider>(context);
    // storeProvider.isLogined = true;
    // storeProvider.updateUserInfo(value);
    // }
    // });
  }

  void saveLoginUser(UserEntity user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String,dynamic> userMap = user.toJson();
    
     prefs.setString("user",convert.jsonEncode(userMap));
  }

  // Future<User> requestMyInfo(String name, String pwd) async {
  //   if(name == null || name.isEmpty){
  //     return null;
  //   }
  //   if(pwd == null || pwd.isEmpty){
  //     return null;
  //   }
  //   ResultDaoWrapData result = await UserDao.getUserInfo(name);
  //   return result.data;
  // }
}
