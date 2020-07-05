import 'package:dio/dio.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/services.dart';

class HttpTool {
  final Dio dio = Dio();
  static final HttpTool tool = new HttpTool();

  HttpTool(){
    dio.interceptors.add(new LogInterceptor(responseBody: true));
  }

  get(url,parmas,{Map<String,dynamic> header}) async{
    Options option = new Options(method: "get");
    option.responseType = ResponseType.json;
    
    Response response;
    try {
      response = await dio.request<String>(url,data: parmas,options: option);
    } on DioError catch(e){
      print(e.message);
      // var result = await rootBundle.loadString('assets/kline.json');

      // return json.decode(result);
      return {"error":e.message};
    }
    
    print(response.data);
    return json.decode(response.data);
  }

  post(String url,Map<String,dynamic> params) async {
    Options option = new Options(method:"post");
    option.responseType = ResponseType.json;
    Response response;
    try {
      response = await dio.request<String>(url,data: params,options: option);
    }on DioError catch(e) {
      print(e.message);
      return {"error":e.message};
    }
    if(response.data is DioError){
      return null;
    }
    return json.decode(response.data);
  }


}