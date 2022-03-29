/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-28 14:12:16
 * @LastEditTime: 2022-03-28 20:58:07
 */

import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/pages/madou/madou_service.dart';
import 'package:sex_91porn/sql/video_dao.dart';
import 'package:sex_91porn/util/application.dart';
import 'package:sex_91porn/util/http_util.dart';

class MadouVideoListTial extends StatelessWidget {
  final VideoModel videoModel;

  const MadouVideoListTial({Key? key, required this.videoModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          bool isCancel = false;
          BrnDialogManager.showSingleButtonDialog(context,
              label: "取消",
              title: "提示",
              messageWidget: Container(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blue)),
                    SizedBox.fromSize(
                      size: Size.fromHeight(20),
                    ),
                    Text("正在获取播放资源...")
                  ],
                ),
              ), onTap: () {
            HttpUtil.cancel();
            isCancel = true;
            Navigator.of(context).pop();
          }, barrierDismissible: false);

          MadouService.analysisVideoPath(videoModel).then((v) {
            if (!isCancel) {
              Navigator.of(context).pop();
              VideoDao().addVideo(v);
              Application.navigateToIos(context, "/play", params: videoModel);
            }
          }).catchError((e, s) {
            print("analysisVideoPath error: $e , stack: s");
            if (!isCancel) {
              Navigator.of(context).pop();
              ToastUtil.show(msg: "解析失败");
            }
          });
        },
        child: BrnShadowCard(
          child: Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  CachedNetworkImage(
                      imageUrl: videoModel.cover ?? "",
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      errorWidget: (c, u, e) {
                        return Icon(Icons.broken_image);
                      },
                      placeholder: (context, url) {
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.blue)),
                        );
                      }),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: BrnTagCustom(
                      tagText: videoModel.duration ?? "-",
                      textPadding: EdgeInsets.all(3.3),
                      tagBorderRadius: BorderRadius.circular(3),
                      backgroundColor: Colors.redAccent.withOpacity(.8),
                      textColor: Colors.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: BrnTagCustom(
                      tagText: videoModel.subTtile ?? "-",
                      textPadding: EdgeInsets.all(3.3),
                      tagBorderRadius: BorderRadius.circular(3),
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                    ),
                  )
                ],
              )),
              SizedBox.fromSize(
                size: Size.fromHeight(10),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: Text(
                  videoModel.title,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
        ));
  }
}

// typedef MadouGetDataList = Future<List<VideoModel>> Function(int page);

// class MadouSliveList extends StatefulWidget {
//   final MadouGetDataList getDataList;

//   MadouSliveList({Key? key, required this.getDataList}) : super(key: key);

//   @override
//   State<MadouSliveList> createState() => _MadouSliveListState();
// }

// class _MadouSliveListState extends State<MadouSliveList> {
//   bool _isLoad = true;
//   int _current = 1;
//   List<VideoModel> _dataList = List.empty(growable: true);

//   @override
//   Widget build(BuildContext context) {
//     return SliverList(
//         delegate: SliverChildBuilderDelegate((context, index) {
//       var video = _dataList[index];
//       return Container(
//         padding: EdgeInsets.all(8),
//         child: MadouVideoListTial(
//           videoModel: video,
//         ),
//       );
//     }, childCount: _dataList.length));
//   }
// }
