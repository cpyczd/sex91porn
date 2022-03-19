/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-29 11:38:59
 * @LastEditTime: 2022-03-19 20:47:06
 */

import 'package:sex_91porn/pages/sihu/data_service.dart';

main() async {
  var list = await SihuDataService.search("门事件");
  print(list);
}
