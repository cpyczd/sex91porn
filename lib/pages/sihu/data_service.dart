/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 17:00:06
 * @LastEditTime: 2022-03-19 22:48:32
 */

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sex_91porn/model/img_model.dart';
import 'package:sex_91porn/model/pair.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/pages/sihu/config.dart';
import 'package:sex_91porn/pages/sihu/model_entity.dart';
import 'package:sex_91porn/util/http_util.dart';

class SihuDataService {
  ///转换为视屏模块
  static VideoModel conversion(Element element) {
    Element? h3 = element.querySelector("h3");
    Element? a = element.querySelector("a");
    Element? img = element.querySelector("img");
    Element? i = element.querySelector("i");
    var imgSrc = img?.attributes["data-original"] ?? "-";
    var m3u8 = M3U8_BASE_URL +
        "/newhd/" +
        imgSrc
            .substring(imgSrc.indexOf("images/") + 7)
            .replaceAll("/poster2.jpg", "/hls/index.m3u8");

    return VideoModel(
        id: 0,
        cover: imgSrc,
        src: m3u8,
        title: h3?.text ?? "-",
        href: MAIN_URL + "${a?.attributes["href"]}",
        duration: i?.text,
        dynamicCover: imgSrc.replaceAll("poster2.jpg", "preview.mp4"));
  }

  ///返回首页推荐视屏信息
  static Future<List<VideoModel>> getIndexVideoList() async {
    List<VideoModel> list = List.empty(growable: true);
    var html = await HttpUtil.getHtml(MAIN_URL);
    Document root = parse(html);
    var wrapList = root.getElementsByClassName("row col5 clearfix");
    for (var i = 0; i < 3; i++) {
      list.addAll(wrapList[i]
          .querySelectorAll("dl")
          .map((e) => conversion(e))
          .toList());
    }
    return list;
  }

  ///解析分类页面获取视屏详情列表
  static Future<Pair<int, List<VideoModel>>> getCategoryInfo(
      SihuCategoryModel model, int pageIndex) async {
    String url =
        pageIndex == 1 ? model.href : model.href + "index_$pageIndex.html";
    var html = await HttpUtil.getHtml(url);
    Document root = parse(html);
    List<VideoModel> list = root
        .getElementsByClassName("row col5 clearfix")
        .map((e) => e.querySelectorAll("dl"))
        .expand((element) => element
            .where((element) => element.id != "listwoBox")
            .map((e) => conversion(e))
            .toList())
        .toList();
    String maxIndex = root
            .getElementsByClassName("moble_pagination")[0]
            .querySelectorAll("a")
            .last
            .attributes["href"]
            ?.replaceAll(new RegExp("\\D"), "") ??
        "${pageIndex + 1}";
    return Pair(key: int.parse(maxIndex), value: list);
  }

  ///搜索方法处理代码部分

  ///搜索结果
  static Future<List<VideoModel>> search(String keyword) async {
    var html = await HttpUtil.getHtml(
        "https://www.b1b33.com/searchs/index.php?keyboard=$keyword&classid=");
    Document root = parse(html);
    return root
        .getElementsByClassName("row-book clearfix")[0]
        .querySelectorAll("a")
        .map((e) {
      return VideoModel(id: 0, title: e.text, href: e.attributes["href"]);
    }).toList();
  }

  ///搜索的视屏结果进行数据填充处理
  static Future<VideoModel> searchVideoProcessConversion(
      VideoModel videoModel) async {
    Document doc = parse(await HttpUtil.getHtml(videoModel.href!));
    var panel = doc.getElementsByClassName("pannel clearfix")[1];

    var script = doc
        .querySelectorAll("script")
        .where((element) => element.text.contains("posterImg"))
        .first
        .text;

    var imgSrc = script
        .substring(script.indexOf("posterImg=") + 11)
        .replaceAll("\";", "");

    var m3u8 = M3U8_BASE_URL +
        "/newhd/" +
        imgSrc
            .substring(imgSrc.indexOf("images/") + 7)
            .replaceAll("/poster2.jpg", "/hls/index.m3u8");
    return VideoModel(
        id: 0,
        title: panel.querySelector("h3")?.text ?? "-",
        cover: imgSrc,
        href: videoModel.href,
        duration: panel.getElementsByTagName("p")[1].text.replaceAll("时间：", ""),
        src: m3u8);
  }

  ///搜索的图文结果进行数据填充处理
  static Future<ImageModel> searchImageProcessConversion(
      VideoModel videoModel) async {
    Document doc = parse(await HttpUtil.getHtml(videoModel.href!));
    var images = doc
        .getElementsByClassName("pic")[0]
        .querySelectorAll("img")
        .map((e) => e.attributes["src"] ?? "")
        .toList();
    return ImageModel(
        href: videoModel.href!, title: videoModel.title, imageUrls: images);
  }
}
