/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-29 11:44:21
 * @LastEditTime: 2022-03-19 19:21:50
 */

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:sex_91porn/model/img_model.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/pages/image_detail_page.dart';
import 'package:sex_91porn/pages/index.dart';
import 'package:sex_91porn/pages/play_video.dart';
import 'package:sex_91porn/pages/sihu/index.dart';
import 'package:sex_91porn/pages/sihu/model_entity.dart';
import 'package:sex_91porn/pages/sihu/page_detail.dart';
import 'package:sex_91porn/pages/sihu/search.dart';

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

//图文详情
Handler imageDetailPage = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return ImageDetailPage(
    model: context!.settings!.arguments as ImageModel,
  );
});

//四虎Index
Handler sihuHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return SihuIndexPage();
});

//四虎分类详情
Handler sihuDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return SihuPageDetail(
    categoryModel: context!.settings!.arguments as SihuCategoryModel,
  );
});

//四虎搜索
Handler sihuSearchHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return SihuSearchResultPage(
    keyword: context!.settings!.arguments as String,
  );
});
