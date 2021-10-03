/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-29 11:44:21
 * @LastEditTime: 2021-10-02 22:11:20
 */

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/pages/index.dart';
import 'package:sex_91porn/pages/play_video.dart';

///首页Index
Handler indexHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return IndexPage();
});

///播放页
Handler videoPlayHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  VideoModel model = context!.settings!.arguments as VideoModel;
  return new PlayVideoPage(
    videoModel: model,
  );
});
