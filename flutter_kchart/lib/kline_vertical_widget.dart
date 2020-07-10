import 'package:flutter/material.dart';
import 'package:flutter_kchart/tools/main_top_bar_controller.dart';
import 'package:provider/provider.dart';
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
  KLineVerticalWidget({this.dataController});
  KLineDataController dataController;

  @override
  State<StatefulWidget> createState() {
    return _KLineVerticalWidgetState();
  }
}

class _KLineVerticalWidgetState extends State<KLineVerticalWidget>
    with TickerProviderStateMixin {
  KLineDataController dataController;

  Animation<Rect> timeRect; //动画值
  AnimationController timeAnimationController; //根据垂直信息号产生动画值
  RectTween timePosition; //设置动画初始与结尾值

  Animation<Rect> indicatorsRect;
  AnimationController indicatorsAnimationController;
  RectTween indicatorsPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dataController = widget.dataController;

    //动画的本质，实际上时通过动画控制器，不断的修改值
    //动画控制器是时间上的值
    //理解动画的本质；就是在每一帧到到来时。去修改值；
    //这样在下次渲染时进行绘制
    //vsync 实际上就是垂直同步信号
    //数据修改了。还要监听改变。要么手动监听。要么用动画控件
    //所有界面是以响应式
    timeAnimationController = new AnimationController(vsync: this);
    //RectTween描述起始位置；
    timePosition = new RectTween(
      begin: new Rect.fromLTRB(0.0, -100, 0, 0.0),
      end: new Rect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    );
    //起始的描述，用animationVC去生成位置；
    timeRect = timePosition.animate(timeAnimationController);

    //指标动画控制器
    indicatorsAnimationController = new AnimationController(vsync: this);
    indicatorsPosition = new RectTween(
      begin: new Rect.fromLTRB(0.0, -100, 0, 0.0),
      end: new Rect.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
    //provider 只有当数据变化时。其视图才会重新绘制；
    return ChangeNotifierProvider.value(
      value: dataController,
      builder: (BuildContext context, Widget child) {
        return Column(
          children: <Widget>[
            MainTopBar(periodButtonClick: () {
              periodShowOrHide();
            }, indicatorsShowOrHideClick: () {
              indicatorsShowOrHide();
            }),
            Builder(builder: (BuildContext context) {
              return Expanded(
                  child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height - 50 - 20,
                    width: MediaQuery.of(context).size.width,
                    child: KChartWidget(
                      Provider.of<KLineDataController>(context).displayDatas,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 50 - 20,
                      isLine: Provider.of<KLineDataController>(context).isLine,
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
                      )),
                  Offstage(
                    offstage: !dataController.showLoading,
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                  ),
                ],
              ));
            }),
          ],
        );
      },
    );
  }
}
