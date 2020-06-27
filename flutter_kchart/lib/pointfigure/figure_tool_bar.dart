import 'package:flutter/material.dart';
import 'package:flutter_kchart/tools/colors_golabal.dart';
class FigureToolBar extends StatefulWidget {
  double gezhi;
  int reversCount;
  Function (double gezhi,int reversCount)refreshCallBack;
  FigureToolBar({this.gezhi,this.reversCount,this.refreshCallBack});
  @override
  _FigureToolBarState createState() => _FigureToolBarState();
}

class _FigureToolBarState extends State<FigureToolBar> {
  //页面内的状态；是方便时使用；也可以用全局状态管理；
  int reversCount ;
  double gezhi ;
  Function (double gezhi,int reversCount) refreshCallBack;
  
  TextEditingController textEditingController;

   @override
  void initState() {
    super.initState();
    reversCount = widget.reversCount;
    gezhi = widget.gezhi;
    refreshCallBack = widget.refreshCallBack;
    textEditingController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
            border: 
            Border.all(color:ColorsGolabal.separateLineColor, width: 0.5)
      ),
      height: 50,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            gezhiInputWidget(),
            reversCountWidget(),
            refreshWidget()
            ],
        ),
      ),
    );
  }

  Widget gezhiInputWidget() {
    return Container(
      width: 200,
      // height: 50,//double.infinijjlty,
      padding: EdgeInsets.only(left:25),
      child: Row(
        children: [
        Text('格值:'),
        Container(
          margin: EdgeInsets.only(left:10),
          width: 100,
          child:  TextField(
            controller: textEditingController,
            decoration: InputDecoration(hintText: gezhi.toString()),
            autofocus: true,
          ),
        )
        ],
      )     
    );
  }

  Widget reversCountWidget() {
    return Container(
      child: Row(children: [
        Text("1点图："),
        Radio(
          value: 1,
          groupValue: this.reversCount,
          onChanged: (value) {
            setState(() {
              this.reversCount = value;
            });
          },
        ),
        SizedBox(width: 20),
        Text("3点图："),
        Radio(
            value: 3,
            groupValue: this.reversCount,
            onChanged: (value) {
              setState(() {
                this.reversCount = value;
              });
            }),
      ]),
    );
  }
  
 void hideKeyBord(){
     FocusScope.of(context).requestFocus(FocusNode());
  }
  Widget refreshWidget(){
    return Container(
      width: 80,
      child: FlatButton(
         color: ColorsGolabal.separateLineColor,
        child: Text(
          '刷新'
        ),
        onPressed: (){
          hideKeyBord();

          double tempGezhi = gezhi;
          String inputGezhi =  textEditingController.text ;
          if(inputGezhi!=null){
            tempGezhi = double.parse(inputGezhi);
          }
          refreshCallBack(tempGezhi,reversCount);
        },
      ),
    );
  }
}
