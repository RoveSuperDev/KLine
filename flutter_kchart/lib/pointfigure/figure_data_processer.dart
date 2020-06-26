
import 'package:flutter_kchart/pointfigure/figure_point_const.dart';
import 'package:flutter_kchart/pointfigure/pure_kline_entity.dart';
import 'figure_point.dart';

class FigureDataProcesser {
 
  List<PureKlineEntity>  pointList  = [];//点
  List<List<FigurePoint>> figurePointList = [];//点数图点
  int maxDepth;//最大深度

  double gezhi = 50;//格值
  int reverse = 1;//反转点数
  double minAll;
  double maxAll;

  double lineHeight = 0;
  double mainChartHeight = 0;

void setPointList(List<PureKlineEntity> list){
  pointList.clear();
  pointList = list;
  build();

  // lineHeight = FigurePointChartConst.mainChartHeight/figurePointList.length;

  lineHeight = 15;
  mainChartHeight = figurePointList.length * lineHeight;
  // if(lineHeight < 10){
  //   lineHeight = 10;
  // }else if(lineHeight > 20){
  //   lineHeight = 20;
  // }
}

void build (){
  buildFigurePointArray();//初始化点
  fillFigure();//填充点
  reverseUpToDownPoint();//上下反转点
  // printFigurePointList();//打印
}

void buildFigurePointArray(){
  PureKlineEntity firstKLineEntity = pointList.first;
  double max = firstKLineEntity.high;
  double min = firstKLineEntity.low;
  
  //计算在整个数据里最大值与最小值
  for(int i = 0;i < pointList.length;i++){
    PureKlineEntity point = pointList[i];
    if(point.low < min){
      min = point.low;
    }
    if(point.high  > max){
      max = point.high;
    }
  }

  int maxzheng = max~/ gezhi ;
  int minzheng = min~/gezhi;

  //通过最大值与最小值计算纵坐标的个数
  for(int i = 0; i<= maxzheng - minzheng;i++){
    List<FigurePoint>  oneLineList = [];
    for(int j = 0;j<pointList.length;j++){
      FigurePoint figurePoint = FigurePoint();
      figurePoint.type = -1;
      figurePoint.depth = 0;
      oneLineList.add(figurePoint);
    }
    figurePointList.add(oneLineList);
  }
  minAll = min;
  maxAll = max;
  print("最小值:$minAll");
  print("最大值:$maxAll");
}

void fillFigure() {
  int type = 1;
  int depth = 0;
  double lastColumnMax = 0;
  double lastColumnMin = 0;
  
  for(int i = 0;i< pointList.length;i++){
    PureKlineEntity currentEntity = pointList[i];
    if(i == 0){
        checkPointMergeFirst(currentEntity, depth, type);
        lastColumnMax = currentEntity.high;
        lastColumnMin = currentEntity.low;
    }else {
      if(type == 1){
        //当前列是上升列
        if(checkPointNewHigh(currentEntity, lastColumnMax, depth)){
           //是否创新高
          checkPointMergeNewHigh(currentEntity, lastColumnMin, depth, type);
          lastColumnMax = currentEntity.high;
        }else if(checkUpToDown(currentEntity, lastColumnMax)){
            //是否反转
          if(!checkColumnHadOnlyOne(depth)){
              depth = depth + 1;
          }
          type = 0;
          fillUpToDown(currentEntity, lastColumnMax, depth, type);
          lastColumnMax = currentEntity.high;
          lastColumnMin = currentEntity.low;
        }else {
            //什么也不做
        }
      }else {
        //当前列是下降列
        if(checkPointNewLow(currentEntity, lastColumnMin, depth)){
            checkPointMergeNewLow(currentEntity, lastColumnMax, depth, type);
            lastColumnMin = currentEntity.low;
        }else if(checkDownToUp(currentEntity, lastColumnMin)){
            if(!checkColumnHadOnlyOne(depth)){
              depth = depth + 1;
            }
            type = 1;
            fillDownToUp(currentEntity, lastColumnMin, depth, type);
            lastColumnMin = currentEntity.low;
            lastColumnMax = currentEntity.high;
        }else{
            //什么也不做
        }
      }
    }
  }
  maxDepth = depth;
}

//第一次处理
void checkPointMergeFirst(PureKlineEntity klineEntity,int depth,int type) {
  double minAllzheng = (minAll~/gezhi) * gezhi;
  int minIndex = (klineEntity.low - minAllzheng) ~/ gezhi + 1;//向上取整；
  int maxIndex = (klineEntity.high - minAllzheng) ~/gezhi;
  realFillPoint(minIndex, maxIndex, depth, type);
}

void realFillPoint(int minIndex,int maxIndex,int depth,int type){
  for (int i = minIndex;i<= maxIndex;i++){
    List<FigurePoint> lineList = figurePointList[i];
    FigurePoint figurePoint = lineList[depth];
    figurePoint.type = type;
    figurePoint.depth = depth;
  }
}

//上升的处理
bool checkPointNewHigh(PureKlineEntity klineEntity,double lastColumnMax ,int depth) {
  int maxchu = klineEntity.high~/gezhi;
  double maxzheng = gezhi * maxchu;

  int lastColumMaxChu = lastColumnMax~/gezhi;
  double lastColumMaxzheng = gezhi * lastColumMaxChu;
  if(maxzheng > lastColumMaxzheng){
    return true;
  }else{
   return false;
  }
}

void checkPointMergeNewHigh(PureKlineEntity klineEntity,double lastColumnMin,int depth,int type) {
  double minAllzheng = (minAll ~/gezhi) *gezhi;
  int minIndex = (lastColumnMin - minAllzheng)~/gezhi + 1;
  int maxIndex = (klineEntity.high - minAllzheng)~/gezhi;
  realFillPoint(minIndex, maxIndex, depth, type);
}

bool checkUpToDown(PureKlineEntity klineEntity,double lastColumnMax) {
  //是否反转；1点反转
  //最小值。能在次高位置画一个o
  int lastColumnCigaoChu = lastColumnMax~/gezhi - reverse ;
  double lastColumnCigaozheng = lastColumnCigaoChu * gezhi;

  if(klineEntity.low < lastColumnCigaozheng){
    return true;
  }else {
    return false;
  }
}

void fillUpToDown(PureKlineEntity klineEntity,double lastColumnMax,int depth,int type) {
    double minAllzheng = (minAll~/gezhi) *gezhi;
    
    int lastColumnchu = lastColumnMax~/gezhi;
    double lastColumnzheng = lastColumnchu *gezhi;
    //上次最高的次高
    int maxIndex = (lastColumnzheng - minAllzheng)~/gezhi  -1 ;

    //最小的坐标
    int lowchu = klineEntity.low~/gezhi;
    double lowzheng  = lowchu *gezhi ;
    int minIndex = (lowzheng - minAllzheng)~/gezhi + 1;

    realFillPoint(minIndex, maxIndex, depth, type);
}

// 下降的处理新低
bool checkPointNewLow(PureKlineEntity klineEntity,double lastColumnMin ,int depth){
  int lowchu = klineEntity.low~/gezhi;
  double lowzheng = gezhi * lowchu;

  int lastColumMinChu = lastColumnMin~/gezhi;
  double lastColumMinzheng = gezhi * lastColumMinChu;

  if(lowzheng < lastColumMinzheng){
    return true;
  }else{
    return false;
  }
}

void checkPointMergeNewLow(PureKlineEntity klineEntity,double lastColumnMax, int depth, int type){
  double minAllzheng = (minAll~/gezhi) *gezhi;
  int minIndex = (klineEntity.low - minAllzheng) ~/gezhi + 1;
  
  int maxChu = lastColumnMax~/gezhi ;
  double maxzheng = maxChu *gezhi;
  int maxIndex = (maxzheng - minAllzheng)~/gezhi -1 ;
  realFillPoint(minIndex, maxIndex, depth, type);
}

bool checkDownToUp(PureKlineEntity klineEntity,double lastColumnMin) {

  //最低chu
  int lastColumnMinchu = lastColumnMin~/gezhi + 1;

  int lastColumnMinCigaochu = lastColumnMinchu + reverse;//次高
  double lastColumnCidizheng  = lastColumnMinCigaochu * gezhi;

  if(klineEntity.high >= lastColumnCidizheng){
    return true;
  }else{
    return false;
  }
}

void fillDownToUp(PureKlineEntity klineEntity,double lastColumnMin,int depth,int type){
  double minAllzheng = (minAll~/gezhi) *gezhi;

  //最低chu
  int lastColumnchu = lastColumnMin~/gezhi + 1;
  double lastColumnzheng = lastColumnchu *gezhi;//最低整数

  //最低index
  int minIndex = (lastColumnzheng - minAllzheng)~/gezhi + 1;

  //最高index
  int maxIndex = (klineEntity.high - minAllzheng)~/gezhi;

  realFillPoint(minIndex, maxIndex, depth, type);
}

//同一列必须有两个点
bool checkColumnHadOnlyOne(int depth){
  int noEmptyCount = 0;
  for(int i = 0;i< figurePointList.length;i++){
    List<FigurePoint> lineList = figurePointList[i];
    FigurePoint figurePoint = lineList[depth];
    if(figurePoint.type == 1 || figurePoint.type == 0){
      noEmptyCount++;
    }
  }
  if(noEmptyCount<=1){
    return true;
  }else{
    return false;
  }
}

//上下transform
void reverseUpToDownPoint() {
  for(int i = 0;i< figurePointList.length~/2;i++){
    List firstList = figurePointList[i];
    List secondList = figurePointList[figurePointList.length - i - 1];
    List tmp = firstList;
    figurePointList[i] = secondList;
    figurePointList[figurePointList.length - i - 1] = tmp;
  }
}

void printFigurePointList (){
  //不打印
  for(int i = 0;i< figurePointList.length;i++){
    double zuobiao = (maxAll~/gezhi - i) *gezhi;
    print("$zuobiao");
    List<FigurePoint> lineArray = figurePointList[i];
    for(int j = 0;j< lineArray.length;j++){
      FigurePoint figurePoint = lineArray[j];
      if(figurePoint.type == -1){
        print(" ");
      }else{
        String tex = figurePoint.type == 0 ? "o":"x";
        print(tex);
      }
    }
    print("\n");
  }
}

}