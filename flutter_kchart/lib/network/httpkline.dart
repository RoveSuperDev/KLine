import 'package:dio/dio.dart';
import 'package:flutter_kchart/kchart/entity/k_line_entity.dart';
import 'httptool.dart';

class HttpKLine {

  static Future<List<KLineEntity>> getKLine(String period, String symbols) async {
    String url = 'https://api.huobi.pro/market/history/kline?period=${period}&size=300&symbol=${symbols}';
    Map<String,dynamic> results = await HttpTool.tool.get(url, null);
    List list = results["data"];
    List<KLineEntity> datas = list.map((item) => KLineEntity.fromJson(item)).toList().reversed.toList().cast<KLineEntity>();
    return datas;
  } 

}