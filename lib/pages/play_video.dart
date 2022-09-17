/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-31 23:17:08
 * @LastEditTime: 2022-09-17 22:50:25
 */
import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/util/application.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class PlayVideoPage extends StatefulWidget {
  final VideoModel videoModel;

  PlayVideoPage({Key? key, required this.videoModel}) : super(key: key);

  @override
  _PlayVideoPageState createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  bool onLoad = true;

  bool isLoadSrcCode = false;

  @override
  void initState() {
    super.initState();
    //保持屏幕常亮
    Wakelock.enable();
    print("拿到视屏数据: ${widget.videoModel}");
    Future.delayed(Duration.zero, () {
      if (widget.videoModel.src != null) {
        setState(() {
          initVideoWiget(widget.videoModel);
          onLoad = false;
        });
      } else {
        BrnDialogManager.showSingleButtonDialog(context,
            label: "确定",
            title: '错误',
            warning: '无法播放',
            message: "错误没有找到对应的播放路径!", onTap: () {
          Application.router.pop(context);
        });
      }
    });
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    Wakelock.disable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BrnAppBar(
            brightness: Brightness.dark,
            title: "视屏播放",
            automaticallyImplyLeading: true),
        body: SafeArea(
          child: Container(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                widget.videoModel.cover ?? ""),
                            fit: BoxFit.cover)),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: onLoad
                                ? Container(
                                    child: Center(
                                      child: // 模糊进度条(会执行一个旋转动画)
                                          Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            backgroundColor: Colors.grey[200],
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.blue),
                                          ),
                                          SizedBox.fromSize(
                                            size: Size.fromHeight(15),
                                          ),
                                          BrnTagCustom(
                                            tagText: "解码视屏资源中请稍后...",
                                            textColor: Colors.white,
                                            fontSize: 18,
                                            tagBorderRadius:
                                                BorderRadius.circular(7),
                                            textPadding: EdgeInsets.all(5),
                                            backgroundColor: Colors.black54,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : chewieController != null
                                    ? Chewie(controller: chewieController!)
                                    : Center(
                                        child: BrnTagCustom(
                                          tagText: "视屏解码完成,正在初始化播放...",
                                          textColor: Colors.white,
                                          fontSize: 18,
                                          tagBorderRadius:
                                              BorderRadius.circular(7),
                                          textPadding: EdgeInsets.all(5),
                                          backgroundColor: Colors.black54,
                                        ),
                                      ))
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: BrnDashedLine(
                    contentWidget: Padding(
                      child: Text(widget.videoModel.title,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      padding: EdgeInsets.only(left: 10),
                    ),
                    axis: Axis.vertical,
                    color: Colors.blueAccent,
                    dashedSpacing: 0,
                    dashedThickness: 2,
                  ),
                )),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    "时长/标签: ${widget.videoModel.duration}",
                    style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                )),
              ],
            ),
          ),
        ));
  }

  //初始化视屏播放器
  initVideoWiget(VideoModel model) async {
    if (model.src == null || model.src!.isEmpty) {
      ToastUtil.show(msg: "获取播放地址失败无法播放");
      return;
    }
    videoPlayerController = VideoPlayerController.network(model.src!);
    await videoPlayerController!.initialize();
    setState(() {
      chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          // aspectRatio: 4 / 3, //宽高比
          autoPlay: true, //自动播放
          looping: false, //循环播放
          isLive: false,
          showOptions: false,
          placeholder: Container(
            color: Colors.black,
          ));
    });
    ToastUtil.show(msg: "已开始自动播放");
  }
}
