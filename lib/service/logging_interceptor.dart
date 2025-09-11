import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:truck_market_place/service/api_calls.dart';

class LoggingInterceptor extends Interceptor{

  final int _maxCharactersPerLine = 200;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // print("--> ${options.method} ${options.baseUrl}${options.path}");
    // print("RequestDataHeader: ${options.headers}");
    // print("RequestData: ${options.data}");
    // print("Content type: ${options.contentType}");
    // print("<-- END HTTP");
    super.onRequest(options, handler);
  }


  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async{
    // print("<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");
    if(response.statusCode == 401) {
     await ApiRepository.logOut();
    }
    String responseAsString = response.data.toString();
    if (responseAsString.length > _maxCharactersPerLine) {
      int iterations =
      (responseAsString.length / _maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * _maxCharactersPerLine + _maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        // print(responseAsString.substring(
        //     i * _maxCharactersPerLine, endingIndex)
            // );
      }
    } else {
      // log("onResponse---->${response.data}");
    }
    // log("onResponse---->${jsonEncode(response.data)}");
    // print("<-- END HTTP");

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // print("<-- DioError -->");
    // print(err.error);
    // print(err.message);
    super.onError(err, handler);
  }

}