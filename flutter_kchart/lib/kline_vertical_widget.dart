import 'package:flutter/material.dart';
import 'package:flutter_kchart/tools/main_top_bar_controller.dart';
import 'kchart/kchat_widget.dart';
import 'package:flutter/services.dart';
import 'kchart/flutter_kchart.dart';
import 'dart:convert';
import 'dart:math';
import 'kline_moretime_widget.dart';
import 'kchart/chart_style.dart';
import 'kline_indicators_widget.dart';
import 'kline_data_controller.dart';
import 'package:flutter_kchart/tools/main_top_bar.dart';
import 'package:flutter_kchart/tools/main_top_hour_bar.dart';

class KLineVerticalWidget extends StatefulWidget {
  KLineVerticalWidget({@required this.datas, this.dataController});

  KLineDataController dataController;
  List<KLineEntity> datas = [];

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _KLineVerticalWidgetState();
  }
}

class _KLineVerticalWidgetState extends State<KLineVerticalWidget>
    with TickerProviderStateMixin {
  KLineDataController dataController;

  Animation<Rect> timeRect;
  AnimationController timeAnimationController;
  RectTween timePosition;

  Animation<Rect> indicatorsRect;
  AnimationController indicatorsAnimationController;
  RectTween indicatorsPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dataController = widget.dataController;

    //动画的本质，实际上时通过动画控制器，不断的修改值
    //时间动画控制器
    timeAnimationController = new AnimationController(vsync: this);
    timePosition = new RectTween(
      begin: new Rect.fromLTRB(0.0, -100, 0, 0.0),
      end: new Rect.fromLTRB(0.0, 5.0, 0.0, 0.0),
    );
    timeRect = timePosition.animate(timeAnimationController);

    //指标动画控制器
    indicatorsAnimationController = new AnimationController(vsync: this);
    indicatorsPosition = new RectTween(
      begin: new Rect.fromLTRB(0.0, -100, 0, 0.0),
      end: new Rect.fromLTRB(0.0, 5.0, 0.0, 0.0),
    );
    indicatorsRect = indicatorsPosition.animate(indicatorsAnimationController);
  }

  void indicatorsShowOrHide() {
    hidePeriod();
    if (indicatorsAnimationController.value == 0) {
      indicatorsAnimationController.animateTo(1.0,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    } else if (indicatorsAnimationController.value == 1) {
      indicatorsAnimationController.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void periodShowOrHide() {
    hideindicators();
    if (timeAnimationController.value == 0) {
      timeAnimationController.animateTo(1.0,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    } else {
      hidePeriod();
    }
  }

  void hidePeriod() {
    timeAnimationController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  void hideindicators() {
    indicatorsAnimationController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    //依赖于状态变化的widget相对于是provider
    return KLineDataWidgetController(
      dataController: dataController,
      child: Column(
        children: <Widget>[
          //头部工具
          MainTopBar(
            dataController: dataController,
            periodButtonClick: () {
              periodShowOrHide();
            },
            indicatorsShowOrHideClick: () {
              indicatorsShowOrHide();
            },
          ),

          Builder(builder: (BuildContext context) {
            return Expanded(
                child: Stack(
              children: <Widget>[
                Container(
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  child: KChartWidget(
                    widget.datas,
                    width: MediaQuery.of(context).size.width,
                    height: 450,
                    isLine: KLineDataWidgetController.of(context).isLine,
                    mainState: dataController.mainState,
                    secondaryState: dataController.secondaryState,
                    volState: VolState.VOL,
                    fractionDigits: 2,
                  ),
                ),

                //Stack 里绝对定位。给器一个动画
                RelativePositionedTransition(
                    rect: timeRect,
                    size: Size(0, 0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: MainTopHoursSelectBar(
                          dataController: dataController,
                          selectIndexCallBack: (int index) {
                            if (index ==
                                dataController.topPeriodItems.length - 1) {
                              periodShowOrHide();
                            } else {
                              hidePeriod();
                              hideindicators();
                              dataController.changePeriod(
                                  dataController.topPeriodItems[index]);
                            }
                          },
                          indicatorsShowOrHideCallBack: () {
                            indicatorsShowOrHide();
                          }),
                      //这个暂时留着吧
                      //  KlineMoreTimeWidght(
                      //   periods: dataController.flodPeriodItems,
                      //   hideClick: () {
                      //     hidePeriod();
                      //   },
                      // ),
                    )),
                RelativePositionedTransition(
                    rect: indicatorsRect,
                    size: Size(0, 0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: KlineIndicatorsWidget(
                        mainStates: dataController.mainStates,
                        secondaryStates: dataController.secondaryStates,
                        hideClick: () {
                          hideindicators();
                        },
                      ),
                    ))
              ],
            ));
          }),
        ],
      ),
    );
  }
}
