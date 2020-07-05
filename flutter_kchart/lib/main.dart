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
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider<LoginViewModel>(
        create: (context) => LoginViewModel(),
        builder: (BuildContext context, Widget child){
         LoginViewModel loginModel =  Provider.of<LoginViewModel>(context);
          if(loginModel.loginUser==null){
              return  LoginPage();
          }else{
              return MyHomePage(title: '交易训练平台');
          }
        },
        // child:  Provider.value(value: null) MyHomePage(title: '交易训练平台'), 
      )
      // MyHomePage(title: '交易训练平台'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<KLineEntity> datas = []; //k线数据
  List<PureKlineEntity> pureKlineDatas = []; //点数图数据

  List<KLineEntity> displayDatas = []; //当前显示的数据
  List<PureKlineEntity> displayPureKlineDatas = [];

  String currentSymbols;
  String currentPeriod;
  int currentIndex = 20;

   bool showLoading = true;

  KLineDataController dataController = KLineDataController();

  @override
  void initState() {
    super.initState();
    // rootBundle.loadString('assets/depth.json').then((result) {
    //   final parseJson = json.decode(result);
    //   Map tick = parseJson['tick'];
    //   var bids = tick['bids'].map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();
    //   var asks = tick['asks'].map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();
    // });

    currentSymbols = "btcusdt"; //当前代码
    currentPeriod = dataController.periodModel.period; //当前周期
    dataController.changePeriodClick = (KLinePeriodModel model) {
      // getData(model.period);
      currentPeriod = model.period;
      getData();
    };

    dataController.changeFigurePointClick = () {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return FigurePage(
            kLineEntityList: pureKlineDatas,
            currentPeriod: currentPeriod,
            currentSymbols: currentSymbols);
      }));
    };

    dataController.searchButtonClick = (String selectedSymbols) {
      currentSymbols = selectedSymbols;
      getData();
    };

    getData();
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
                // LoginPage
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return  LoginPage();
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
              KLineVerticalWidget(
                  datas: displayDatas, dataController: dataController),
              Offstage(
                offstage: !showLoading,
                child: Container(
                    width: double.infinity,
                    height: 450,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator()),
              ),
              Positioned(right: 30, bottom: 30, child: tradePadWidget())
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
    currentIndex++;
    setState(() {
      displayDatas = datas.sublist(0, currentIndex);
      // displayPureKlineDatas = pureKlineDatas.sublist(0,currentIndex);
    });
  }

  void getData() async {
    //既可以用同步的方式写代码。也可以用异步的方式写代码；
    datas = await HttpKLine.getKLine(currentPeriod, currentSymbols);

    //k线数据
    // datas = list.map((item) => KLineEntity.fromJson(item)).toList().reversed.toList().cast<KLineEntity>();
    displayDatas = datas.sublist(0, currentIndex);

    //纯k线数据
    // pureKlineDatas = list.map((e) => PureKlineEntity.fromJson(e)).toList();
    // displayPureKlineDatas = pureKlineDatas.sublist(0,currentIndex);

    DataUtil.calculate(datas);
    showLoading = false;
    setState(() {});
  }
}
