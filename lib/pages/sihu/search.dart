/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 22:24:29
 * @LastEditTime: 2022-03-19 23:28:03
 */
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/sql/video_dao.dart';
import 'package:sex_91porn/util/application.dart';

import 'data_service.dart';

class SihuSearchResultPage extends StatefulWidget {
  final String keyword;

  SihuSearchResultPage({Key? key, required this.keyword}) : super(key: key);

  @override
  State<SihuSearchResultPage> createState() => _SihuSearchResultPageState();
}

class _SihuSearchResultPageState extends State<SihuSearchResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrnAppBar(
          brightness: Brightness.dark,
          title: widget.keyword,
          automaticallyImplyLeading: true),
      body: Container(
        child: FutureBuilder<List<VideoModel>>(
            future: SihuDataService.search(widget.keyword),
            builder: (BuildContext context,
                AsyncSnapshot<List<VideoModel>> snapshot) {
              if (snapshot.hasData) {
                var list = snapshot.requireData;
                return _initListView(list);
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ));
              }
            }),
      ),
    );
  }

  Widget _initListView(List<VideoModel> list) {
    return ListView.builder(
      itemBuilder: ((context, index) {
        var item = list[index];
        //是否是视屏还是图
        var isVideo = item.href!.indexOf("/view/") == -1;
        return ListTile(
          onTap: () {
            BrnLoadingDialog.show(context);
            if (isVideo) {
              SihuDataService.searchVideoProcessConversion(item).then((value) {
                BrnLoadingDialog.dismiss(context);
                VideoDao().addVideo(value);
                Application.navigateToIos(context, "/play", params: value);
              }).onError((error, stackTrace) {
                BrnLoadingDialog.dismiss(context);
                print("error:$error, stackTrace:$stackTrace");
                ToastUtil.show(msg: "请求失败");
              });
            } else {
              //图文
              SihuDataService.searchImageProcessConversion(item).then((value) {
                BrnLoadingDialog.dismiss(context);
                Application.navigateToIos(context, "/imgPreview",
                    params: value);
              }).onError((error, stackTrace) {
                BrnLoadingDialog.dismiss(context);
                print("error:$error, stackTrace:$stackTrace");
                ToastUtil.show(msg: "请求失败");
              });
            }
          },
          leading: Icon(
            isVideo ? Icons.movie : Icons.image,
            color: Colors.blueAccent,
          ),
          title: Text(item.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 134, 207), fontSize: 13)),
          subtitle: Text(
            isVideo ? "视屏" : "图文",
            style: TextStyle(fontSize: 12),
          ),
        );
      }),
      itemCount: list.length,
    );
  }
}
