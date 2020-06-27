import 'package:flutter/material.dart';
import 'package:flutter_kchart/kline_data_controller.dart';

class MainTopHoursSelectBar extends StatefulWidget {
  KLineDataController dataController;
  Function(int index) selectIndexCallBack;
  Function() indicatorsShowOrHideCallBack;
  MainTopHoursSelectBar(
      {this.dataController,
      this.selectIndexCallBack,
      this.indicatorsShowOrHideCallBack});

  @override
  _MainTopHourBarState createState() => _MainTopHourBarState();
}

class _MainTopHourBarState extends State<MainTopHoursSelectBar>
    with TickerProviderStateMixin {
  TabController controller;
  KLineDataController dataController;
  Function(int index) selectIndexCallBack;
  Function() indicatorsShowOrHideCallBack;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataController = widget.dataController;
    controller = TabController(
        initialIndex: 0,
        length: dataController.topPeriodItems.length,
        vsync: this);
    controller.addListener(() {});
    selectIndexCallBack = widget.selectIndexCallBack;
    indicatorsShowOrHideCallBack = widget.indicatorsShowOrHideCallBack;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white ,//Color(0xff131E30),
      child: Row(
        children: <Widget>[
          Builder(builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width - 40,
              child: TabBar(
                tabs: dataController.topPeriodItems
                    .map((e) => Tab(text: e.name))
                    .toList(),
                labelStyle: TextStyle(fontSize: 12),
                controller: controller,
                labelPadding: EdgeInsets.all(0),
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Color(0xff1E80D2),
                unselectedLabelColor: Color(0xff6882A1), //36 128 210
                onTap: (int index) {
                  selectIndexCallBack(index);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
