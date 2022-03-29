/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-25 19:43:40
 * @LastEditTime: 2022-03-28 20:52:30
 */
import 'package:fluro/fluro.dart';
import 'router_handler.dart';

class Routers {
  static void configRouters(FluroRouter router) {
    _defineRouter(router, "/", indexHandler);
    _defineRouter(router, "/imgPreview", imageDetailPage);
    _defineRouter(router, "/play", videoPlayHandler);

    _defineRouter(router, "/sihu", sihuHandler);
    _defineRouter(router, "/sihuDetail", sihuDetailHandler);
    _defineRouter(router, "/sihuSearch", sihuSearchHandler);

    _defineRouter(router, "/madou", madouHandler);
    _defineRouter(router, "/madouVideoList", madouVideoListHandler);
  }

  static void _defineRouter(FluroRouter router, String path, Handler handler) {
    router.define(path,
        handler: handler, transitionType: TransitionType.inFromRight);
  }
}
