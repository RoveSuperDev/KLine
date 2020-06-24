import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_kchart/pointfigure/figure_point.dart';

class FigurePointRender extends CustomPainter {
  List<List<FigurePoint>> figurePointList;
  double minAll;
  double maxAll;
  FigurePointRender(this.figurePointList,this.minAll,this.maxAll);

  final Paint dotPaint = Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.high
    ..strokeWidth = 3.0
    ..color = Colors.red;

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawRect(Rect.fromLTRB(10, 10, 20, 20), dotPaint);
    dotPaint.color = Colors.grey;
    canvas.drawRect(Rect.fromLTRB(0, 0,size.width,size.height), dotPaint);
    
    // double lineHeight = size.height/ figurePointList.length;
    double lineHeight = 15;
    // double leftMargin = 40;

    for(int i = 0;i< figurePointList.length;i++) {
      List<FigurePoint> lineList = figurePointList[i];

      for (int j = 0;j< lineList.length;j++){
        FigurePoint figurePoint = lineList[j];
       
         if(figurePoint.type != 0  && figurePoint.type !=1){
           continue;
         }

         double top = i *lineHeight;
        double left = j *lineHeight;
        Offset offset = Offset(left,top);
         if(figurePoint.type == 0){
            canvas.drawParagraph(paragraphText(figurePoint.type),offset);
         }else if(figurePoint.type == 1){
            canvas.drawParagraph(paragraphText(figurePoint.type), offset);
         }
      }
    }
  }
  
  Paragraph paragraphText(int type){
    ParagraphBuilder pb = ParagraphBuilder(
      ParagraphStyle(
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        fontSize: 15
    ));
    // TextStyle st = TextStyle(color: Colors.red);
    // pb.pushStyle(ui.st);
    // pb.pushStyle(TextStyle(color: Color(0xff00ff00)));

    if(type == 1){
      pb.addText('x');
    }else{
      pb.addText('o');
    }
    ParagraphConstraints pc = ParagraphConstraints(width:10);
    Paragraph paragraph = pb.build()..layout(pc);
    return paragraph;
  }

    @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawLeftZuobiao() {

  }
  void drawDot(){

  }
}