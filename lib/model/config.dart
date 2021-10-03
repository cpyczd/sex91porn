/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-26 11:06:12
 * @LastEditTime: 2021-10-02 23:57:15
 */
import 'package:sex_91porn/model/category_model.dart';

class Config {
  static String MAIN_URL = "https://g0727.91p47.com";

  static List<CategoryModel> categoryList = List.of([
    CategoryModel(
        name: "当前最热", url: "$MAIN_URL/v.php?category=hot&viewtype=basic&page="),
    CategoryModel(
        name: "本月最热", url: "$MAIN_URL/v.php?category=top&viewtype=basic&page="),
    CategoryModel(
        name: "91原创", url: "$MAIN_URL/v.php?category=ori&viewtype=basic&page="),
    CategoryModel(
        name: "十分钟以上",
        url: "$MAIN_URL/v.php?category=long&viewtype=basic&page="),
    CategoryModel(
        name: "本月收藏", url: "$MAIN_URL/v.php?category=tf&viewtype=basic&page="),
    CategoryModel(
        name: "收藏最多", url: "$MAIN_URL/v.php?category=mf&viewtype=basic&page="),
    CategoryModel(
        name: "最近加精", url: "$MAIN_URL/v.php?category=rf&viewtype=basic&page="),
    CategoryModel(
        name: "上月最热",
        url: "$MAIN_URL/v.php?category=top&m=-1&viewtype=basic&page="),
    CategoryModel(
        name: "本月讨论", url: "$MAIN_URL/v.php?category=md&viewtype=basic&page="),
    CategoryModel(name: "全部视屏", url: "$MAIN_URL/v.php?next=watch&page="),
  ]);
}
