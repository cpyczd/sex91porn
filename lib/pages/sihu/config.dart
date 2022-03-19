/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 15:54:04
 * @LastEditTime: 2022-03-19 16:58:26
 */
import 'package:flutter/material.dart';
import 'package:sex_91porn/pages/sihu/model_entity.dart';

const MAIN_URL = "https://www.b1b33.com";

const M3U8_BASE_URL = "https://m3u8.63cdn.com";

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
