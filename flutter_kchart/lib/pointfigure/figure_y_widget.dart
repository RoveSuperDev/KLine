import 'package:flutter/material.dart';

import 'package:flutter_kchart/pointfigure/figure_point.dart';


enum FigurePointYType { 
  left, right 
  }

class FigureYWidget extends StatelessWidget {
  List<List<FigurePoint>> figurePointList;
  double minAll;
  double maxAll;
  double gezhi;
  double myHeight;
  double lineHeight;
  FigurePointYType yType = FigurePointYType.left;

  FigureYWidget({
    @required this.figurePointList,
    @required this.maxAll,
    @required this.minAll,
    @required this.gezhi,
    this.yType,
    @required this.myHeight,
    @required this.lineHeight
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: yType == FigurePointYType.left?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children:linesWidget(context) ,
      ),
    );
  }

  List<Widget> linesWidget(BuildContext context) {
    List<Widget> lineList = [];

    double maxValue = (maxAll ~/ gezhi) * gezhi;
    // double lineHeight = myHeight / figurePointList.length;

    for (int i = 0; i < figurePointList.length; i++) {
      String yString = (maxValue - i * gezhi).toString();
      if (yType == FigurePointYType.left) {
        yString = yString + ' ';
      } else {
        yString = ' ' + yString;
      }

      double top = i * lineHeight;
      Widget lineWidget = onelineWidget(yString,lineHeight);
      lineList.add(lineWidget);
    }
    return lineList;
  }

  Widget onelineWidget(String string, double height) {
    return  
    Container(
      height: height,
      padding: yType == FigurePointYType.left ? EdgeInsets.only(right:5):EdgeInsets.only(left:5),
      child: Text(
        string,
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
        ),
    );
  }
}
