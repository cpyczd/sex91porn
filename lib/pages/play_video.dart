/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-31 23:17:08
 * @LastEditTime: 2021-10-03 12:30:55
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: AppBar(
        title: Text(
          widget.videoModel.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
              height: 1,
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
              child: Padding(
            padding: EdgeInsets.only(top: 50, bottom: 100),
            child: onLoad
                ? Container(
                    child: Center(
                      child: // 模糊进度条(会执行一个旋转动画)
                          Column(
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ),
                          SizedBox.fromSize(
                            size: Size.fromHeight(20),
                          ),
                          Text("解码视屏资源中请稍后...")
                        ],
                      ),
                    ),
                  )
                : chewieController != null
                    ? Chewie(controller: chewieController!)
                    : Center(
                        child: Text(
                          "视屏解码完成,正在初始化播放...",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
          ))
        ],
      ),
    );
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
        aspectRatio: 3 / 2, //宽高比
        autoPlay: true, //自动播放
        looping: false, //循环播放
        isLive: false,
        showOptions: false,
        placeholder: Center(
          child: CachedNetworkImage(
            imageUrl: model.cover ?? "",
          ),
        ),
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      );
    });
    ToastUtil.show(msg: "已开始自动播放");
  }
}
