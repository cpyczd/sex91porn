/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-29 11:38:59
 * @LastEditTime: 2022-03-27 22:16:05
 */

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
  var categoryList = await MadouService.getCategoryList();
  print(categoryList);
}
