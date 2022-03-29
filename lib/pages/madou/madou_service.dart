/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-27 21:00:35
 * @LastEditTime: 2022-03-28 21:23:47
 */
import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/util/http_util.dart';
import 'package:sex_91porn/util/sp_util.dart';
import './madou_config.dart';

class MadouService {
  ///获取首页热门推荐列表数据
  static Future<List<VideoModel>> hotVideoList(int page) async {
    return _parseVideoList(MAIN_URL + "page/$page");
  }

  ///解析视屏列表
  static Future<List<VideoModel>> _parseVideoList(String url) async {
    print("URL=====>>> $url");
    var html = await HttpUtil.getHtml(url);
    var root = parse(html);
    List<Element> videos = root.getElementsByClassName("excerpt excerpt-c5");
    return videos.map((e) {
      var h2 = e.querySelector("h2")!;
      var href = h2.querySelector("a")!.attributes["href"];
      String title = h2.text;
      String viewCount = e.getElementsByClassName("post-view")[0].text;
      String? cover = e.querySelector("img")!.attributes["data-src"];

      String? subTitle = e.querySelector(".hot")?.text;
      return VideoModel(
          id: 0,
          title: title,
          href: href,
          duration: viewCount,
          cover: cover,
          subTtile: subTitle);
    }).toList();
  }

  ///获取分类下的视屏列表分页
  static Future<List<VideoModel>> categoryVideo(
      MadouCategory category, int page) {
    return _parseVideoList(category.getPagePath(page));
  }

  ///解析m3u8播放链接
  static Future<VideoModel> analysisVideoPath(VideoModel videoModel) async {
    var html = await HttpUtil.getHtml(videoModel.href!);
    var root = parse(html);
    String path = root
        .getElementsByClassName("article-content")[0]
        .querySelector("iframe")!
        .attributes["src"]!;
    html = await HttpUtil.getHtml(path);
    String tmp = html.substring(html.indexOf("var token = ") + 12);
    String token = tmp.substring(0, tmp.indexOf(";")).replaceAll("\"", "");

    tmp = html.substring(html.indexOf("var m3u8 = ") + 11);
    String m3u8 = tmp.substring(0, tmp.indexOf(";")).replaceAll("'", "");

    var httpOrigin = Uri.parse(path).origin;
    videoModel.src = httpOrigin + m3u8 + "?token=" + token;
    return videoModel;
  }

  ///返回类别分类
  static Future<List<MadouCategory>> getCategoryList() async {
    String key = "madou-getCategoryList";
    var map = await SpUtil.getVal(key);
    List<MadouCategory> category;
    if (map == null) {
      var html = await HttpUtil.getHtml(MAIN_URL);
      var root = parse(html);
      var lis = root.querySelector(".sitenav")!.querySelectorAll("li");
      category = lis
          .map((e) {
            return MadouCategory(
                href: e.querySelector("a")!.attributes["href"]!, title: e.text);
          })
          .where((element) => element.href.startsWith("http"))
          .toList();
      //保存到缓存，设置7天过期删除
      await SpUtil.save(key, {key: category},
          exprie: 7, level: TimeExpireLevel.DAY);
    } else {
      category = List.from(map[key])
          .map((e) => MadouCategory.fromMap(jsonDecode(e)))
          .toList();
    }
    return category;
  }

  ///搜索视屏
  static Future<List<VideoModel>> search(int page, String searchText) {
    String url = MAIN_URL + "page/$page?s=$searchText";
    return _parseVideoList(url);
  }
}
