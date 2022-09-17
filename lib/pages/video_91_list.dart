/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-31 21:38:18
 * @LastEditTime: 2022-09-17 22:43:38
 */
import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sex_91porn/model/category_model.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/service/list_parse.dart';
import 'package:sex_91porn/util/application.dart';
import 'package:sex_91porn/util/http_util.dart';
import 'package:sex_91porn/util/widget_util.dart';

///91在线爬取页码PageWidget
class Video91ListPage extends StatefulWidget {
  final CategoryModel model;

  Video91ListPage({Key? key, required this.model}) : super(key: key);

  @override
  _Video91ListPageState createState() => _Video91ListPageState();
}

class _Video91ListPageState extends State<Video91ListPage>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController _controller = EasyRefreshController();

  List<VideoModel> _list = [];

  int _currentPage = 0;

  String tip = "首次请点击下面按钮进行加载";

  @override
  void initState() {
    super.initState();
    print("初始化页面: ${widget.model.name}");
    //爬取数据
    // _getNextData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: EasyRefresh(
      controller: _controller,
      onRefresh: () async {
        _list.clear();
        _currentPage = 0;
        await _getNextData();
        return;
      },
      onLoad: () async {
        await _getNextData();
        return;
      },
      child: _list.isEmpty
          ? Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blueAccent)),
                    SizedBox.fromSize(
                      size: Size.fromHeight(10),
                    ),
                    Text(tip),
                    SizedBox.fromSize(
                      size: Size.fromHeight(20),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.refresh_outlined,
                          color: Colors.green,
                          size: 35,
                        ),
                        onPressed: () {
                          //重新请求
                          _currentPage = 0;
                          _list.clear();
                          _getNextData();
                        })
                  ],
                ),
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: .65),
              itemCount: _list.length,
              itemBuilder: (context, index) {
                var item = _list[index];
                return GestureDetector(
                  onTap: () {
                    if (item.href == null || item.href!.isEmpty) {
                      ToastUtil.show(msg: "该视频获取播放地址失败,无法播放");
                      return;
                    }
                    //开始解析M3u8资源
                    BrnDialogManager.showSingleButtonDialog(context,
                        label: "取消",
                        title: "提示",
                        messageWidget: Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.blue)),
                              SizedBox.fromSize(
                                size: Size.fromHeight(20),
                              ),
                              Text("正在获取播放资源...")
                            ],
                          ),
                        ), onTap: () {
                      HttpUtil.cancel();
                    }, barrierDismissible: false);
                    HttpUtil.getHtml(item.href!).then((value) {
                      var el = Uri.decodeFull(VideoPageParse.getSrcCode(value));
                      el = el
                          .substring(el.indexOf("'") + 1, el.indexOf("type"))
                          .replaceAll("'", "")
                          .trim();
                      item.src = el;
                      Navigator.of(context).pop();
                      Application.navigateToIos(context, "/play", params: item);
                    }).catchError((e) {
                      ToastUtil.show(msg: "获取资源失败");
                      Navigator.of(context).pop();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 3),
                    child: Card(
                      margin: EdgeInsets.only(bottom: 5, top: 5),
                      child: Column(
                        children: [
                          Expanded(
                              child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: item.cover ?? "",
                                fit: BoxFit.fill,
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
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5, right: 5, bottom: 5, top: 10),
                            child: Text(
                              item.title,
                              style: TextStyle(fontSize: 11),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
    ));
  }

  _getNextData() async {
    if (widget.model.endPage != null) {
      if (widget.model.endPage! <= _currentPage + 1) {
        ToastUtil.show(msg: "没有更多的内容了");
        return;
      }
    }
    setState(() {
      tip = "加载中...";
    });
    this._currentPage++;
    String url = "${widget.model.url}$_currentPage";
    print("爬取第$_currentPage页 链接:$url");
    try {
      String html = await HttpUtil.getHtml(url);
      if (widget.model.endPage == null) {
        widget.model.endPage = VideoPageParse.getPageNum(html);
      }
      var res = VideoPageParse.getVideoList(html);
      setState(() {
        _list.addAll(res);
      });
      print("爬取成功得到${res.length}条数据");
      //添加数据库里
      //todo
      return true;
    } catch (e) {
      print("请求失败：$e");
      ToastUtil.show(msg: "请求失败");
      DialogUtil.showConfirmDialog(context, "请求失败是否重新请求?", okText: "重新尝试",
          ok: () {
        this._currentPage--;
        _getNextData();
      });
      setState(() {
        tip = "请求失败";
      });
      return Future.error("请求失败");
    }
  }

  @override
  bool get wantKeepAlive => true;
}
