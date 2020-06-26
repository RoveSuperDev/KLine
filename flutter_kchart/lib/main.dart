import 'package:flutter/material.dart';
import 'kchart/flutter_kchart.dart';
import 'kchart/chart_style.dart';
import 'kline_vertical_widget.dart';
import 'kline_data_controller.dart';
import 'network/httptool.dart';
import 'pointfigure/figure_page.dart';
import 'package:flutter_kchart/pointfigure/pure_kline_entity.dart';

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
      home: MyHomePage(title: '威科夫者'),
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
  List<KLineEntity> datas = [];//k线数据
  List<PureKlineEntity> pureKlineDatas = [];//点数图数据
  
  String currentSymbols ;
  String currentPeriod;
 

  bool showLoading = true;

  KLineDataController dataController = KLineDataController();

  // MainTopBarController topBarController = MainTopBarController();

  @override
  void initState() {
    super.initState();
    // rootBundle.loadString('assets/depth.json').then((result) {
    //   final parseJson = json.decode(result);
    //   Map tick = parseJson['tick'];
    //   var bids = tick['bids'].map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();
    //   var asks = tick['asks'].map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();
    // });
    currentSymbols = "btcusdt" ;//当前代码
    currentPeriod =  dataController.periodModel.period;//当前周期
    dataController.changePeriodClick = (KLinePeriodModel model){
      // getData(model.period);
      currentPeriod = model.period;
      getData();
    };

    dataController.changeFigurePointClick = (){
       Navigator.push(
         context, 
         MaterialPageRoute(
            builder: (BuildContext context) {
              return FigurePage(kLineEntityList:pureKlineDatas ,currentPeriod: currentPeriod,currentSymbols: currentSymbols);
            }
        ));
    };

    dataController.searchButtonClick = (String selectedSymbols){
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
      ),
      backgroundColor: ChartColors.bgColor,
      body: Listener(
        onPointerDown: (PointerDownEvent event){
            dataController.hideKeyBord(context);
        },
        child: Stack(
        children: <Widget>[
          KLineVerticalWidget(datas: datas, dataController: dataController),
          Offstage(
            offstage: !showLoading,
            child:  Container(
                width: double.infinity,
                height: 450,
                alignment: Alignment.center,
                child: CircularProgressIndicator()
            ),
          ),
        ],
      ) ,
      )
    );
  }

  void getData() async {
  

    // setState(() {
    //   datas = [];
    //   showLoading = true;
    // });

    // rootBundle.loadString('assets/testbtc.json').then((result) {
    //   Map parseJson = json.decode(result);
    //   List list = parseJson["data"];
      
    //   pureKlineDatas = list.map((e) => PureKlineEntity.fromJson(e)).toList();
    //   showLoading = false;

    //   setState(() {});
    // });


    Map<String,dynamic> results = await  HttpTool.tool.get('https://api.huobi.pro/market/history/kline?period=${currentPeriod}&size=300&symbol=${currentSymbols}', null);
    List list = results["data"];
    datas = list.map((item) => KLineEntity.fromJson(item)).toList().reversed.toList().cast<KLineEntity>();

    pureKlineDatas = list.map((e) => PureKlineEntity.fromJson(e)).toList();
    //test

    // List subList =  pureKlineDatas.sublist(0,146);
    // pureKlineDatas = subList;
    //end
    DataUtil.calculate(datas);
    showLoading = false;
    setState(() {});
  }
}
