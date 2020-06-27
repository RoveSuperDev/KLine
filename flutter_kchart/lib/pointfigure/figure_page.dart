import 'package:flutter/material.dart';
import 'package:flutter_kchart/pointfigure/pure_kline_entity.dart';
import 'package:flutter_kchart/pointfigure/figure_data_processer.dart';
import 'package:flutter_kchart/pointfigure/figure_point_render.dart';
import 'package:flutter_kchart/pointfigure/figure_y_widget.dart';
import 'package:flutter_kchart/pointfigure/figure_point_const.dart';
import 'package:flutter_kchart/pointfigure/figure_tool_bar.dart';
class FigurePage extends StatefulWidget {
  List<PureKlineEntity> kLineEntityList; //k线数据
  String currentSymbols ;//"btcustd"; //品种
  String currentPeriod;
  FigurePage({this.kLineEntityList,this.currentSymbols,this.currentPeriod});

  @override
  _FigurePageState createState() => _FigurePageState();
}

class _FigurePageState extends State<FigurePage> {
  FigureDataProcesser figureDataProcesser;
  String currentSymbols ;//"btcustd"; //品种
  String currentPeriod;

  @override
  void initState() {
    super.initState();
    currentSymbols = widget.currentSymbols;
    currentPeriod = widget.currentPeriod;
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
        body:  Listener(
        onPointerDown: (PointerDownEvent event){
            // dataController.hideKeyBord(context);
            hideKeyBord();
        },
        child: Container(
          //sigleChildScrollView防止溢出
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FigureToolBar(
                gezhi: figureDataProcesser.gezhi,
                reversCount: figureDataProcesser.reverse,
                refreshCallBack: (double gezhi,int reversCount){
                  //重新构建数据
                  
                  setState(() {
                    figureDataProcesser.gezhi = gezhi;
                    figureDataProcesser.reverse = reversCount;
                    figureDataProcesser.rebuild();
                  });
                }
              ),
              chartTop(),
              chartTopLine(),
              chartCenter(),
            ],
          )),
        ),
        ));
  }

  Widget chartTopLine() {
    return Container(
      margin: EdgeInsets.only(
        // bottom: 1,
        // top: 1,
          left: FigurePointChartConst.yLeftChartWidth,
          right: FigurePointChartConst.yRightChartWidth),
      color: Colors.black,
      height: 1,
    );
  }

  Widget chatLeftLine() {
    return Container(
      margin:EdgeInsets.only(
        // left: 1,
        // right: 1,
        top:0,
        bottom: FigurePointChartConst.xBottomAxisChartHeight
        ),
      color: Colors.black,
      width: 1,
    );
  }

  Widget chatRightLine() {
    return Container(
      margin:EdgeInsets.only(
        // left: 1,
        // right: 1,
        bottom: FigurePointChartConst.xBottomAxisChartHeight),
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
      child: 
      Row(
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
    String symbolStr = "品种:" + currentSymbols;
    String periodStr = "周期:" + currentPeriod;
    String gezhiStr =  "格值:" + figureDataProcesser.gezhi.toString();
    String reversalStr =  "反转数:" + figureDataProcesser.reverse.toString();
    String chartTopString = symbolStr + "  " + periodStr + "  " + gezhiStr + " " + reversalStr;

    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        chartTopString,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

   void hideKeyBord(){
     FocusScope.of(context).requestFocus(FocusNode());
  }
}
