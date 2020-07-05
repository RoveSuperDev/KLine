import 'package:flutter/material.dart';
import 'package:flutter_kchart/tools/colors_golabal.dart';
import 'package:flutter_kchart/kline_data_controller.dart';

class MainTopBar extends StatefulWidget {
  //widget里的对象;
  //widget可以重建；所以传值的后需要保存在其所在的状态里；

  KLineDataController dataController; //KLineDataController();
  Function periodButtonClick;
  Function indicatorsShowOrHideClick;
  Function modeButtonClick;
  MainTopBar(
      {this.dataController,
      this.periodButtonClick,
      this.indicatorsShowOrHideClick,
      this.modeButtonClick});
  @override
  _MainTopBarState createState() => _MainTopBarState();
}

class _MainTopBarState extends State<MainTopBar> {
  //状态里的对象
  KLineDataController dataController;
  Function periodButtonClick;
  Function indicatorsShowOrHideClick;
  Function modeButtonClick;
  TextEditingController textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataController = widget.dataController;
    periodButtonClick = widget.periodButtonClick;
    indicatorsShowOrHideClick = widget.indicatorsShowOrHideClick;
    modeButtonClick = widget.modeButtonClick;

    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              modeSelectWidget(),
              symbolsInput(),
              searchButton(),
              periodButton(),
              figurePointButton(),
              weisiWaveButton(),
              zhibaioButton()
            ],
          ),
        ));
  }

  Widget modeSelectWidget() {
    return Container(
      child: FlatButton(
        child: Text(dataController.modeTraning ?'训练模式':'实盘模式'),
        onPressed: () {
            modeButtonClick();
        },
      ),
    );
  }

  Widget symbolsInput() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      width: 100,
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(hintText: "示例btcusdt"),
        autofocus: true,
      ),
    );
  }

  Widget searchButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              right: BorderSide(
                  width: 1, color: ColorsGolabal.separateLineColor))),
      width: 80,
      child: FlatButton(
        child: Text('搜索'),
        onPressed: () {
          String symbols = textEditingController.text;
          if (symbols != null && symbols.length > 0) {
            widget.dataController.searchButtonClick(textEditingController.text);
          }
        },
      ),
    );
  }

  Widget periodButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              right: BorderSide(
                  width: 1, color: ColorsGolabal.separateLineColor))),
      width: 80,
      child: FlatButton(
        child: Text(
            // '4hour'
            dataController.periodModel.period ?? 'null'),
        onPressed: () {
          //暂时先写为空
          periodButtonClick();
          // widget.dataController.changePeriodClick(null);
        },
      ),
    );
  }

  Widget figurePointButton() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              right: BorderSide(
                  width: 1, color: ColorsGolabal.separateLineColor))),
      width: 80,
      child: FlatButton(
        child: Text('点数图'),
        onPressed: () {
          widget.dataController.changeFigurePointClick();
        },
      ),
    );
  }

  Widget weisiWaveButton() {
    return Container(
      width: 80,
      child: FlatButton(
        child: Text('维斯波'),
        onPressed: () {
          print('功能还没有实现');
        },
      ),
    );
  }

  Widget zhibaioButton() {
    return IconButton(
        icon: Icon(Icons.view_module, color: Color(0xff3D536c)),
        onPressed: () {
          indicatorsShowOrHideClick();
          // indicatorsShowOrHideCallBack();
        });
  }
}
