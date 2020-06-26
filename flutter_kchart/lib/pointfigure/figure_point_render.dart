import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_kchart/pointfigure/figure_point.dart';

class FigurePointRender extends CustomPainter {
  List<List<FigurePoint>> figurePointList;
  double minAll;
  double maxAll;
  double gezhi;
  int maxDepth;
  double lineHeight;
  FigurePointRender(this.figurePointList, this.minAll, this.maxAll, this.gezhi,
      this.maxDepth,this.lineHeight);

  double allMargin = 0;

  final Paint pointPaint = Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.high
    ..strokeWidth = 1.0
    ..color = Color.fromRGBO(240, 240, 240, 1);

  @override
  void paint(Canvas canvas, Size size) {
    double chartWidth = size.width;
    //绘制点数
    for (int i = 0; i < figurePointList.length; i++) {
      List<FigurePoint> lineList = figurePointList[i];
      Offset p1 = Offset(2, i * lineHeight);
      Offset p2 = Offset(size.width - 2, i * lineHeight);
      drawSeparateLine(canvas, p1, p2);

      for (int j = 0; j < lineList.length; j++) {
        FigurePoint figurePoint = lineList[j];
        if (figurePoint.type != 0 && figurePoint.type != 1) {
          continue;
        }

        double top = i * lineHeight;
        double left = j * lineHeight;
        Offset offset = Offset(left + 4, top  -2) ;//-5修正绘制文本问题
        drawDot(canvas, figurePoint.type, offset);
      }
    }
    
    //绘制垂直分割线
    for (int i = 0; i < chartWidth / lineHeight; i++) {
      double p1top = 2; // i * lineHeight;
      double p1left = i * lineHeight;
      Offset p1 = Offset(p1left, p1top);

      double p2top = figurePointList.length * lineHeight - 2;
      double p2left = i * lineHeight;
      Offset p2 = Offset(p2left, p2top);
      drawSeparateLine(canvas, p1, p2);
    }

    //绘制底下边框
    {
      Offset p1 = Offset(-200, figurePointList.length * lineHeight);
      Offset p2 = Offset(size.width + 200, figurePointList.length * lineHeight);
      drawBorderLine(canvas, p1, p2);
    }

    //绘制底下横坐标
     for (int i = 0; i < chartWidth / lineHeight; i++) {
      double p2top = figurePointList.length * lineHeight - 2 + 10 - 2;
      double p2left = i * lineHeight + 5;
      Offset p2 = Offset(p2left, p2top);
      if(i%5 == 0){
          drawText(canvas, i.toString(),p2,Colors.black,10);
      }
    }
  }

  void drawSeparateLine(Canvas canvas, Offset p1, Offset p2) {
    pointPaint.color = Color.fromRGBO(240, 240, 240, 1);
    canvas.drawLine(p1, p2, pointPaint);
  }

  void drawBorderLine(Canvas canvas, Offset p1, Offset p2){
    pointPaint.color = Colors.black;
    canvas.drawLine(p1, p2, pointPaint);
  }

  void drawDot(Canvas canvas, int type, Offset offset) {
    String dotText = "o";
    Color dotColor = Colors.blue;
    if (type == 1) {
      dotText = "x";
      dotColor = Colors.red;
    }
    drawText(canvas, dotText, offset, dotColor,15);
  }

  void drawText(Canvas canvas, String text, Offset offset, Color textColor,double fontSize) {
    TextSpan span = TextSpan(
        text: text,
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
            fontSize: fontSize,
            color: textColor));
    TextPainter textPainter =
        TextPainter(text: span, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
