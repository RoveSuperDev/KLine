import 'package:flutter/material.dart';
import 'package:flutter_kchart/pointfigure/pure_kline_entity.dart';
import 'package:flutter_kchart/pointfigure/figure_data_processer.dart';
import 'package:flutter_kchart/pointfigure/figure_render.dart';

class FigurePage extends StatefulWidget {
  List<PureKlineEntity> kLineEntityList;//k线数据

  FigurePage(this.kLineEntityList);

  @override
  _FigurePageState createState() => _FigurePageState();
}

class _FigurePageState extends State<FigurePage> {
  FigureDataProcesser figureDataProcesser ;
  @override
  void initState() {
    super.initState();
    double min = 2.27;
    double gezhi = 0.2;
    double zhengdouble = min/gezhi;
    int zhengint = zhengdouble.toInt();
    print('我是日志:$zhengint');

    figureDataProcesser = FigureDataProcesser();
    figureDataProcesser.setPointList(widget.kLineEntityList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图'),
      ),
      body: Container(
        child:  SingleChildScrollView(
          child: CustomPaint(
          size: Size(2000,600),
          painter: FigurePointRender(figureDataProcesser.figurePointList),
        ),
        )
        
      ),
    );
  }
}