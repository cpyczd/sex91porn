/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 15:54:04
 * @LastEditTime: 2022-03-25 14:02:29
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sex_91porn/pages/sihu/model_entity.dart';

// const MAIN_URL = "https://www.4hu.tv"; //海外
const MAIN_URL = "https://www.b2x55.com/";

final _PLAY_SOURCES = [
  "40cdn",
  "41cdn",
  "44cdn",
  "46cdn",
  "47cdn",
  "48cdn",
  "49cdn",
  "63cdn",
  "34cdn",
  "38cdn"
];

String getM3u8Url() {
  var str = _PLAY_SOURCES[Random().nextInt(_PLAY_SOURCES.length)];
  return "https://m3u8.$str.com";
}

final CATEGORY_CONFIG = List.of([
  SihuCategoryModel(
      title: "自拍视屏",
      href: "$MAIN_URL/video/zipai/",
      icon: Icon(Icons.movie_outlined)),
  SihuCategoryModel(
      title: "开放青年",
      href: "$MAIN_URL/video/kaifang/",
      icon: Icon(Icons.movie_outlined)),
  SihuCategoryModel(
      title: "精品分享",
      href: "$MAIN_URL/video/jingpin/",
      icon: Icon(Icons.movie_outlined)),
  SihuCategoryModel(
      title: "台湾辣妹",
      href: "$MAIN_URL/video/twmn/",
      icon: Icon(Icons.movie_outlined)),
  SihuCategoryModel(
      title: "动漫卡通",
      href: "$MAIN_URL/video/dongman/",
      icon: Icon(Icons.movie_outlined)),
  SihuCategoryModel(
      title: "无码中字",
      href: "$MAIN_URL/movie/wuma/",
      icon: Icon(Icons.movie_outlined)),
  SihuCategoryModel(
      title: "SM系列",
      href: "$MAIN_URL/movie/sm/",
      icon: Icon(Icons.movie_outlined)),
  SihuCategoryModel(
      title: "高清无码",
      href: "$MAIN_URL/movie/gaoqing/",
      icon: Icon(Icons.movie_outlined)),
  SihuCategoryModel(
      title: "熟女人妻",
      href: "$MAIN_URL/movie/shunv/",
      icon: Icon(Icons.movie_outlined)),
  SihuCategoryModel(
      title: "中文有码",
      href: "$MAIN_URL/movie/youma/",
      icon: Icon(Icons.movie_outlined)),
]);
