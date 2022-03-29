/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-30 11:00:05
 * @LastEditTime: 2022-03-28 21:00:05
 */

import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'cookie_util.dart';

class HttpUtil {
  static CancelToken? _cancelToken = CancelToken();

  static final Dio _HTTP = Dio(BaseOptions(
      connectTimeout: 10000,
      sendTimeout: 10000,
      receiveTimeout: 10000,
      headers: {
        "accept-language": "zh-CN,zh;q=0.9,ja;q=0.8,en;q=0.7,zh-TW;q=0.6"
      }));

  static void setup() async {
    var cookie = await Cook.cookieJar;
    _HTTP.interceptors.add(CookieManager(cookie));
    // _HTTP.interceptors.add(LogInterceptor(responseBody: false)); //开启请求日志
  }

  ///测试 设置代理
  static setProxy() {
    (_HTTP.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (url) {
        ///设置代理 电脑ip地址
        return "PROXY 10.0.2.2:7890";

        ///不设置代理
        // return 'DIRECT';
      };

      ///忽略证书
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }

  ///get请求
  static Future<Response<T>> getRequest<T>(String url,
      {Map<String, dynamic>? queryParams}) {
    _cancelToken = CancelToken();
    return _HTTP.get(url,
        queryParameters: queryParams,
        cancelToken: _cancelToken,
        options: Options(followRedirects: false));
  }

  ///返回Html
  static Future<String> getHtml(String url) async {
    try {
      var response = await getRequest(url);
      if (response.statusCode == 200) {
        return response.data;
      }
      return Future.error("请求失败: ${response.statusMessage}");
    } catch (e) {
      print("请求失败: $e");
      return Future.error("请求失败:超时");
    }
  }

  static void cancel() {
    _cancelToken?.cancel();
  }
}
