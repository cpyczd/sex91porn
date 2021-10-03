/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-25 19:46:49
 * @LastEditTime: 2021-10-03 12:12:59
 */

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sex_91porn/model/video_model.dart';

class VideoPageParse {
  ///获取列表的视屏数据
  static List<VideoModel> getVideoList(String html) {
    List<VideoModel> list = [];
    Document document = parse(html);
    var rootList = document.querySelectorAll(".videos-text-align");
    if (rootList.isEmpty) {
      return list;
    }
    for (var l in rootList) {
      Element a = l.getElementsByTagName("a")[0];
      //获取视屏原始链接地址
      String href = a.attributes["href"] ?? "";
      //获取标题
      String title =
          a.getElementsByClassName("video-title title-truncate m-t-5")[0].text;
      //获取Id号码
      var id = a.getElementsByClassName("thumb-overlay")[0].id;
      id = id.replaceAll(new RegExp("\\D"), "");
      //获取图片
      String img =
          a.getElementsByClassName("img-responsive")[0].attributes["src"] ?? "";
      //获取时长
      String duration = a.getElementsByClassName("duration")[0].text;

      VideoModel videoModel = VideoModel(
          href: href,
          title: title,
          cover: img,
          duration: duration,
          id: int.parse(id));

      // print("videoModel===>>> $videoModel");
      list.add(videoModel);
    }
    return list;
  }

  ///返回最大的页码
  static int getPageNum(String html) {
    Document document = parse(html);
    var pageDiv = document.getElementsByClassName("pagingnav")[0];
    var aList = pageDiv.querySelectorAll("a");
    var a = aList.reversed.toList()[1];
    return int.parse(a.text);
  }

  ///返回播放连接加密的字符串
  static String getSrcCode(String html) {
    Document document = parse(html);
    Element? script =
        document.getElementById("player_one")?.querySelector("script");
    if (script == null) {
      return "";
    }
    String sciptContent = script.innerHtml;
    String code = sciptContent.substring(
        sciptContent.indexOf("\"") + 1, sciptContent.lastIndexOf("\""));
    return code;
  }
}
