import 'package:flutter/material.dart';
import 'package:flutter_kchart/pointfigure/figure_x_widget.dart';
import 'package:flutter_kchart/pointfigure/pure_kline_entity.dart';
import 'package:flutter_kchart/pointfigure/figure_data_processer.dart';
import 'package:flutter_kchart/pointfigure/figure_point_render.dart';
import 'package:flutter_kchart/pointfigure/figure_y_widget.dart';
import 'package:flutter_kchart/pointfigure/figure_point_const.dart';

class FigurePage extends StatefulWidget {
  List<PureKlineEntity> kLineEntityList; //k线数据
  String symbols = "btcustd"; //品种
  FigurePage(this.kLineEntityList);

  @override
  _FigurePageState createState() => _FigurePageState();
}

class _FigurePageState extends State<FigurePage> {
  FigureDataProcesser figureDataProcesser;
  int reversal = 1;
  @override
  void initState() {
    super.initState();

    figureDataProcesser = FigureDataProcesser();
    figureDataProcesser.setPointList(widget.kLineEntityList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white,
          title: Text('点数图'),
        ),
        body: Container(
          //sigleChildScrollView防止溢出
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              chartTop(),
              chartTopLine(),
              chartCenter(),
            ],
          )),
        ));
  }

  Widget chartTopLine() {
    return Container(
      margin: EdgeInsets.only(
          left: FigurePointChartConst.yLeftChartWidth,
          right: FigurePointChartConst.yRightChartWidth),
      color: Colors.black,
      height: 1,
    );
  }

  Widget chatLeftLine() {
    return Container(
      margin:
          EdgeInsets.only(bottom: FigurePointChartConst.xBottomAxisChartHeight),
      color: Colors.black,
      width: 1,
    );
  }

  Widget chatRightLine() {
    return Container(
      margin:
          EdgeInsets.only(bottom: FigurePointChartConst.xBottomAxisChartHeight),
      color: Colors.black,
      width: 1,
    );
  }

//中间行
  Widget chartCenter() {
    return Container(
      height: figureDataProcesser.mainChartHeight +
          FigurePointChartConst.xBottomAxisChartHeight,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          chartCenterLeft(),
          chatLeftLine(),
          Expanded(child: chartCenterMain()),
          chatRightLine(),
          chartCenterRight()
        ],
      ),
    );
  }

  Widget chartCenterLeft() {
    return Container(
        width: FigurePointChartConst.yLeftChartWidth,
        child: FigureYWidget(
          figurePointList: figureDataProcesser.figurePointList,
          maxAll: figureDataProcesser.maxAll,
          minAll: figureDataProcesser.minAll,
          gezhi: figureDataProcesser.gezhi,
          yType: FigurePointYType.left,
          myHeight: figureDataProcesser.mainChartHeight,
          lineHeight: figureDataProcesser.lineHeight,
        ));
  }

  Widget chartCenterRight() {
    return Container(
      width: FigurePointChartConst.yRightChartWidth,
      child: FigureYWidget(
        figurePointList: figureDataProcesser.figurePointList,
        maxAll: figureDataProcesser.maxAll,
        minAll: figureDataProcesser.minAll,
        gezhi: figureDataProcesser.gezhi,
        yType: FigurePointYType.right,
        myHeight: figureDataProcesser.mainChartHeight,
        lineHeight: figureDataProcesser.lineHeight,
      ),
    );
  }

  Widget chartCenterMain() {
    double rightEmpty = 200;
    return  ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CustomPaint(
              size: Size(
                  figureDataProcesser.maxDepth *
                          figureDataProcesser.lineHeight +
                      rightEmpty,
                  figureDataProcesser.mainChartHeight +
                      FigurePointChartConst.xBottomAxisChartHeight),
              painter: FigurePointRender(
                  figureDataProcesser.figurePointList,
                  figureDataProcesser.minAll,
                  figureDataProcesser.maxAll,
                  figureDataProcesser.gezhi,
                  figureDataProcesser.maxDepth,
                  figureDataProcesser.lineHeight),
            )
          ],
        );
  }

//头部行
  Widget chartTop() {
    String chartTopString = "品种:" +
        widget.symbols +
        "  " +
        "格值:" +
        figureDataProcesser.gezhi.toString() +
        "  " +
        "反转数:" +
        reversal.toString();
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        chartTopString,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
