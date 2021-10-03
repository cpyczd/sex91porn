/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-30 21:47:54
 * @LastEditTime: 2021-10-02 22:09:00
 */
import 'package:flutter/material.dart';
import 'package:sex_91porn/model/config.dart';
import 'package:sex_91porn/pages/video_91_list.dart';
import 'package:sex_91porn/util/application.dart';
import 'package:sex_91porn/util/widget_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Video91Page extends StatefulWidget {
  Video91Page({Key? key}) : super(key: key);

  @override
  _Video91PageState createState() => _Video91PageState();
}

class _Video91PageState extends State<Video91Page>
    with SingleTickerProviderStateMixin {
  late TabController _mController;

  static const KEY = "siteUrl";

  @override
  void initState() {
    super.initState();
    _mController =
        new TabController(length: Config.categoryList.length, vsync: this);
    Future.delayed(Duration.zero, () async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      if (sp.containsKey(KEY)) {
        String? url = sp.getString(KEY);
        if (url != null || url!.isNotEmpty) {
          Config.MAIN_URL = url;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "实时资源库",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            DialogUtil.showInputDialog(context,
                title: "配置爬取URL",
                placeholder: "请输入Url地址 无/结尾",
                initVal: Config.MAIN_URL, call: (String val) async {
              if (val.isEmpty) {
                ToastUtil.show(msg: "请配置完整");
              } else {
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setString(KEY, val);
                setState(() {
                  Config.MAIN_URL = val;
                  ToastUtil.show(msg: "请上拉刷新重新加载");
                });
              }
              Navigator.pop(context);
            });
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: TabBar(
              tabs: Config.categoryList
                  .map((e) => Tab(
                        text: e.name,
                      ))
                  .toList(),
              isScrollable: true,
              controller: _mController,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Expanded(
            child: TabBarView(
              controller: _mController,
              children: Config.categoryList
                  .map((e) => Video91ListPage(
                        model: e,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
