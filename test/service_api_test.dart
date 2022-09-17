/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-29 11:38:59
 * @LastEditTime: 2022-03-27 22:16:05
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sex_91porn/pages/madou/madou_service.dart';
import 'package:sex_91porn/pages/sihu/data_service.dart';
import 'package:sex_91porn/util/http_util.dart';

main() async {
  HttpUtil.setProxy();
  // var list = await SihuDataService.search("门事件");
  // print(list);

  // var list = await MadouService.hotVideoList(1);
  // print(list);
  // var m3u8 = await MadouService.analysisVideoPath(list[0]);
  // print(m3u8);
  // var categoryList = await MadouService.getCategoryList();
  // print(categoryList);

  var original =
      '%3c%73%6f%75%72%63%65%20%73%72%63%3d%27%68%74%74%70%73%3a%2f%2f%63%64%6e%37%37%2e%39%31%70%34%39%2e%63%6f%6d%2f%6d%33%75%38%2f%37%30%30%32%30%37%2f%37%30%30%32%30%37%2e%6d%33%75%38%27%20%74%79%70%65%3d%27%61%70%70%6c%69%63%61%74%69%6f%6e%2f%78%2d%6d%70%65%67%55%52%4c%27%3e';
  original = Uri.decodeFull(original);
  // split on 'u' and remove the first empty element
  print(original);
}
