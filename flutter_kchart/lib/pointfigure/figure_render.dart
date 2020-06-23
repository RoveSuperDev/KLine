
import 'package:flutter/material.dart';
import 'package:flutter_kchart/pointfigure/figure_point.dart';

class FigurePointRender extends CustomPainter {
  List<List<FigurePoint>> figurePointList;
  FigurePointRender(this.figurePointList);

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
    
    double lineHeight = size.height/ figurePointList.length;

    for(int i = 0;i< figurePointList.length;i++) {
      List<FigurePoint> lineList = figurePointList[i];
      for (int j = 0;j< lineList.length;j++){
        FigurePoint figurePoint = lineList[j];
       
         if(figurePoint.type != 0  && figurePoint.type !=1){
           continue;
         }

          double top = i *lineHeight;
          double left = j *lineHeight;
        //ltrb表示
         Rect pointRect = Rect.fromLTRB(left, top, left + lineHeight, top + lineHeight);

         if(figurePoint.type == 0){
            dotPaint.color = Colors.red;
             canvas.drawOval(pointRect, dotPaint);
         }else if(figurePoint.type == 1){
            dotPaint.color = Colors.green;
             canvas.drawOval(pointRect, dotPaint);
         }
      }
    }
  }
  
    @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawDot(){

  }
}