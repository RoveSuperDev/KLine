import 'package:flutter/foundation.dart';
import 'kchart/flutter_kchart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kchart/pointfigure/pure_kline_entity.dart';
import 'package:flutter_kchart/network/HttpKLine.dart';

enum RunningMode { RunningModeTrainning, RunningModeReal }

const int initLastDisplayIndex = 20;

class KLineDataController extends ChangeNotifier {
  List<KLineMainStateModel> mainStates;
  List<KLineSecondaryStateModel> secondaryStates;

  //默认显示的几个时间k线
  List<KLinePeriodModel> topPeriodItems;

  //点击更多展开时候的数据
  List<KLinePeriodModel> flodPeriodItems;

  MainState mainState;

  SecondaryState secondaryState;

  bool isLine;

  //处理行为的变化
  void Function(KLinePeriodModel) changePeriodClick;
  // void Function(String symbols) searchButtonClick;
  void Function() changeFigurePointClick;

  //处理数据
  List<KLineEntity> datas = []; //k线数据
  List<PureKlineEntity> pureKlineDatas = []; //点数图数据

  List<KLineEntity> displayDatas = []; //当前显示的数据
  List<PureKlineEntity> displayPureKlineDatas = []; //当前显示的点数图

  String currentSymbols = "btcusdt";
  KLinePeriodModel periodModel;

  RunningMode runningMode = RunningMode.RunningModeTrainning; //是否是训练模式
  int lastDisplayIndex = initLastDisplayIndex; //训练模式的初始值

  bool showLoading = true;

  KLineDataController() {
    mainStates = KLineMainStateModel.defaultModels();
    secondaryStates = KLineSecondaryStateModel.defaultModels();
    topPeriodItems = KLinePeriodModel.topModels();
    flodPeriodItems = KLinePeriodModel.foldModels();
    mainState = MainState.NONE;
    secondaryState = SecondaryState.NONE;
    isLine = true;
    periodModel = KLinePeriodModel.defaultModel();
    // currentPeriod = periodModel.period;
  }

  //数据发身更改变.去修改状态数据
  void changeMainState(MainState state) {
    mainState = state;
    notifyListeners();
  }

  void changeSecondaryState(SecondaryState state) {
    secondaryState = state;
    notifyListeners();
  }

  void changePeriod(KLinePeriodModel periodModel) {
    if (periodModel.name == this.periodModel.name) {
      return;
    }
    this.periodModel = periodModel;
    if (periodModel.name == "分时") {
      isLine = true;
    } else {
      isLine = false;
    }
    if (this
        .flodPeriodItems
        .map((e) => e.name)
        .toList()
        .contains(periodModel.name)) {
      this.topPeriodItems.last.name = periodModel.name;
    } else {
      this.topPeriodItems.last.name = "更多";
    }
    getKLineData();
  }

  void searchDataForSymbols(String toSymbols) {
    currentSymbols = toSymbols;
    getKLineData();
  }

  void changeModeTraning() {
    if (runningMode == RunningMode.RunningModeTrainning) {
      runningMode = RunningMode.RunningModeReal;
      lastDisplayIndex = datas.length - 1;
      displayDatas.clear();
      displayDatas = datas.sublist(0, lastDisplayIndex);
    } else if (runningMode == RunningMode.RunningModeReal) {
      runningMode = RunningMode.RunningModeTrainning;

      lastDisplayIndex = initLastDisplayIndex;
      displayDatas.clear();
      displayDatas = datas.sublist(0, lastDisplayIndex);
    }

    notifyListeners();
  }

  void hideKeyBord(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void changeLoading(bool loading) {
    showLoading = loading;
    notifyListeners();
  }


  void nextKLineIndex() {
    lastDisplayIndex++;
  }

  void getKLineData() async {
    datas.clear();
    displayDatas.clear();
    changeLoading(true);
    //既可以用同步的方式写代码。也可以用异步的方式写代码；
    datas = await HttpKLine.getKLine(periodModel.period, currentSymbols);

    //k线数据
    displayDatas = datas.sublist(0, lastDisplayIndex);

    //纯k线数据
    // pureKlineDatas = list.map((e) => PureKlineEntity.fromJson(e)).toList();
    // displayPureKlineDatas = pureKlineDatas.sublist(0,currentIndex);

    DataUtil.calculate(datas);
    changeLoading(false);
    notifyListeners();
  }
}
