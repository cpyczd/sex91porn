/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-10-03 00:13:05
 * @LastEditTime: 2021-10-03 00:16:49
 */
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class Cook {
  //改为使用 PersistCookieJar，在文档中有介绍，PersistCookieJar将 cookie保留在文件中，因此，如果应用程序退出，则cookie始终存在，除             非显式调用delete
  static PersistCookieJar? _cookieJar;

  static Future<PersistCookieJar> get cookieJar async {
    if (_cookieJar == null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      print('获取的文件系统目录： ' + appDocPath);
      _cookieJar = new PersistCookieJar(storage: FileStorage(appDocPath));
    }
    return _cookieJar!;
  }
}
