/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-25 19:10:23
 * @LastEditTime: 2022-03-29 19:08:10
 */
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sex_91porn/router/routers.dart';
import 'package:sex_91porn/util/application.dart';
import 'package:sex_91porn/util/http_util.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //配置路由的相关配置
    FluroRouter router = new FluroRouter();
    Routers.configRouters(router);
    Application.router = router;
    HttpUtil.setup();

    //DEV
    // HttpUtil.setProxy();

    return MaterialApp(
      title: 'Free91Porn',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Application.router.generator,
      initialRoute: "/",
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
