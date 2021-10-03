/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-30 21:48:03
 * @LastEditTime: 2021-10-03 12:51:43
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/sql/video_dao.dart';
import 'package:sex_91porn/util/application.dart';
import 'package:sex_91porn/util/widget_util.dart';

class VideoDbPage extends StatefulWidget {
  VideoDbPage({Key? key}) : super(key: key);

  @override
  _VideoDbPageState createState() => _VideoDbPageState();
}

class _VideoDbPageState extends State<VideoDbPage> {
  VideoDao _vidaoDao = VideoDao();

  List<VideoModel> list = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      list.addAll(await _vidaoDao.queryAll());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "本地缓存库",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.clear_all_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              DialogUtil.showConfirmDialog(context, "您确定清理全部观看历史吗?", ok: () {
                VideoDao().clearAll();
                setState(() {
                  list.clear();
                });
              });
            },
          )),
      body: Container(
          child: RefreshIndicator(
        onRefresh: () async {
          list.clear();
          var res = await _vidaoDao.queryAll();
          setState(() {
            list.addAll(res);
          });
          return;
        },
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1),
            itemCount: list.length,
            itemBuilder: (context, index) {
              var item = list[index];
              return GestureDetector(
                onTap: () {
                  //点击的事件
                  Application.router.navigateTo(context, "/play",
                      routeSettings: RouteSettings(arguments: item));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 3),
                  child: Card(
                    margin: EdgeInsets.only(bottom: 5, top: 5),
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                              child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: item.cover ?? "",
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                errorWidget: (c, u, e) {
                                  return Icon(Icons.broken_image);
                                },
                                placeholder: (context, url) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.blue)),
                                  );
                                },
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  color: Colors.redAccent,
                                  padding: EdgeInsets.all(3),
                                  child: Text(
                                    item.duration ?? "-",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              )
                            ],
                          )),
                          SizedBox.fromSize(
                            size: Size.fromHeight(10),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 5, right: 5, bottom: 5),
                            child: Text(item.title),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      )),
    );
  }
}
