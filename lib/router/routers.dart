/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-25 19:43:40
 * @LastEditTime: 2021-01-29 11:46:19
 */
import 'package:fluro/fluro.dart';
import 'router_handler.dart';

class Routers {
  static void configRouters(FluroRouter router) {
    _defineRouter(router, "/", indexHandler);
    _defineRouter(router, "/play", videoPlayHandler);
  }

  static void _defineRouter(FluroRouter router, String path, Handler handler) {
    router.define(path,
        handler: handler, transitionType: TransitionType.inFromRight);
  }
}
