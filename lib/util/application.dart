/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2020-08-05 15:13:46
 * @LastEditTime: 2021-10-02 22:15:54
 */
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Application {
  //Router全局路由管理对象
  static late FluroRouter router;

  static late BuildContext context;

  ///IOS 可侧滑返回的跳转界面
  static Future navigateToIos(BuildContext context, String path,
      {bool replace = false, bool clearStack = false, Object? params}) {
    RouteSettings? settings;
    if (params != null) {
      settings = RouteSettings(name: "params", arguments: params);
    }
    return router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transition: TransitionType.cupertino,
        routeSettings: settings);
  }
}

///系统配置
class AppConfig {}

class ToastUtil {
  static show({@required dynamic msg, Toast length = Toast.LENGTH_SHORT}) {
    if (!(msg is String)) {
      msg = msg.toString();
    }
    Fluttertoast.showToast(
        msg: msg,
        textColor: Colors.white,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        toastLength: length);
  }
}
