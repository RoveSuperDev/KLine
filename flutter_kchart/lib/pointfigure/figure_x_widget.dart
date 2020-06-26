import 'package:flutter/material.dart';
import 'package:flutter_kchart/pointfigure/figure_point.dart';

class FigureXWidget extends StatefulWidget {
  // int count = 10;
  List<List<FigurePoint>> figurePointList ;
  int maxDepth = 0;
  double mainChatHeight;
  double lineHeight;
  // FigureDataProcesser dataProcesser;
  FigureXWidget({this.figurePointList,this.maxDepth,this.mainChatHeight,this.lineHeight});
  @override
  _FigureXWidgetState createState() => _FigureXWidgetState();
}

class _FigureXWidgetState extends State<FigureXWidget> {
  int itemCount;
  double lineHeight = 0;
  @override
  void initState() {
    super.initState();
    itemCount = widget.maxDepth;
    lineHeight =widget.lineHeight;//  widget.mainChatHeight/widget.figurePointList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:5,right:5),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              return xWidget(index);
            }));
  }

  Widget xWidget(int index) {
   
    String  indexStr = (index%10).toString();
    return Container(
      width: lineHeight,
      child: Text(
       indexStr,
        style: TextStyle(
          fontSize: 8,
        ),
        ),
    );
  }
}
