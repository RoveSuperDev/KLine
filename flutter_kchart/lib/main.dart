import 'package:flutter/material.dart';
import 'kchart/flutter_kchart.dart';
import 'kchart/chart_style.dart';
import 'kline_vertical_widget.dart';
import 'kline_data_controller.dart';
import 'pointfigure/figure_page.dart';
import 'package:flutter_kchart/pointfigure/pure_kline_entity.dart';
import 'network/httpkline.dart';
import 'user/login_page.dart';
import 'package:provider/provider.dart';
import 'user/login_view_model.dart';

// void main() => runApp(MyApp());
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = LoginViewModel();
    loginViewModel.initParams();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider<LoginViewModel>(
          create: (context) => loginViewModel,
          builder: (BuildContext context, Widget child) {
            LoginViewModel loginModel = Provider.of<LoginViewModel>(context);
            if (loginModel.loginUser == null) {
              return LoginPage();
            } else {
              return MyHomePage(title: '交易训练平台');
            }
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  KLineDataController dataController = KLineDataController();
  
  @override
  void initState() {
    super.initState();
    dataController.getKLineData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            FlatButton(
              child: Text('个人信息'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
            ),
          ],
        ),
        backgroundColor: ChartColors.bgColor,
        body: Listener(
          onPointerDown: (PointerDownEvent event) {
            dataController.hideKeyBord(context);
          },
          child: Stack(
            children: <Widget>[
              KLineVerticalWidget(dataController: dataController),
              Positioned(
                right: 30,
                 bottom: 30,
                  child: tradePadWidget()
              )
            ],
          ),
        ));
  }

  Widget tradePadWidget() {
    return Container(
      child: Column(
        children: [
          FlatButton(
            color: Colors.blue,
            child: Text("下一条"),
            onPressed: () {
              nextKLine();
            },
          ),
          FlatButton(
            color: Colors.blue,
            child: Text("买入"),
            onPressed: () {
              print("我要买入了");
            },
          ),
          FlatButton(
            color: Colors.blue,
            child: Text("卖出"),
            onPressed: () {
              print("我要卖出了");
            },
          ),
          // 所谓的重新随机；就是重新选择一个时间点；取出数据；
          FlatButton(
            color: Colors.blue,
            child: Text("重新随机"),
            onPressed: () {
              nextKLine();
            },
          ),
        ],
      ),
    );
  }

  void nextKLine() {
    dataController.nextKLineIndex();
  }
}
