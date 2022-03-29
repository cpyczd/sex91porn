/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-31 23:17:08
 * @LastEditTime: 2022-03-29 20:08:51
 */
import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/service/list_parse.dart';
import 'package:sex_91porn/sql/video_dao.dart';
import 'package:sex_91porn/util/application.dart';
import 'package:sex_91porn/util/http_util.dart';
import 'package:sex_91porn/util/widget_util.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:wakelock/wakelock.dart';

class PlayVideoPage extends StatefulWidget {
  final VideoModel videoModel;

  PlayVideoPage({Key? key, required this.videoModel}) : super(key: key);

  @override
  _PlayVideoPageState createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  WebViewPlusController? _controller;

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  bool onLoad = true;

  bool isLoadSrcCode = false;

  @override
  void initState() {
    super.initState();
    //保持屏幕常亮
    Wakelock.enable();
    Future.delayed(Duration.zero, () {
      if (widget.videoModel.src != null) {
        setState(() {
          initVideoWiget(widget.videoModel);
          onLoad = false;
        });
      } else {
        setState(() {
          isLoadSrcCode = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController?.dispose();
    chewieController?.dispose();
    Wakelock.disable();
  }

  void _requestVideoInfo() {
    HttpUtil.getHtml(widget.videoModel.href!)
        .then((value) => {
              _controller!.webViewController.evaluateJavascript(
                  "resolving('${VideoPageParse.getSrcCode(value)}')")
            })
        .catchError((e) {
      DialogUtil.showConfirmDialog(context, "请求数据超时,是否需要重试?",
          okText: "重试", ok: () => _requestVideoInfo());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Container(
                      width: double.infinity,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: BackButton(color: Colors.white),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.videoModel.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      color: Colors.black,
                    ),
                    Container(
                        height: 0,
                        child: isLoadSrcCode
                            ? WebViewPlus(
                                javascriptMode: JavascriptMode.unrestricted,
                                onWebViewCreated: (controller) {
                                  _controller = controller;
                                  controller.loadUrl("assets/html/index.html");
                                },
                                onPageFinished: (url) {
                                  _requestVideoInfo();
                                },
                                javascriptChannels: _createJavaScriptChannel(),
                              )
                            : null),
                    Expanded(
                        flex: 1,
                        child: onLoad
                            ? Container(
                                child: Center(
                                  child: // 模糊进度条(会执行一个旋转动画)
                                      Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        backgroundColor: Colors.grey[200],
                                        valueColor:
                                            AlwaysStoppedAnimation(Colors.blue),
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
                                      tagBorderRadius: BorderRadius.circular(7),
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
                      maxLines: 3,
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

  ///初始化JavaScriptChannel
  Set<JavascriptChannel> _createJavaScriptChannel() {
    Set<JavascriptChannel> list = new Set();
    list.add(new JavascriptChannel(
        name: "resultPlaySrc",
        onMessageReceived: (JavascriptMessage message) {
          String msg = message.message;
          print("接受到了Js回调的数据:$msg");
          setState(() {
            widget.videoModel.src = msg;
            //保存到数据库里
            VideoDao().addVideo(widget.videoModel);
            initVideoWiget(widget.videoModel);
            onLoad = false;
          });
        }));
    return list;
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
