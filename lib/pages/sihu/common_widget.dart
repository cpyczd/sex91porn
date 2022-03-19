/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 16:33:49
 * @LastEditTime: 2022-03-19 18:38:32
 */

import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/sql/video_dao.dart';
import 'package:sex_91porn/util/application.dart';

///预览Cardview
class PreviewCardPanel extends StatefulWidget {
  ///视屏信息
  final VideoModel videoModel;

  PreviewCardPanel({Key? key, required this.videoModel}) : super(key: key);

  @override
  State<PreviewCardPanel> createState() => _PreviewCardPenalState();
}

class _PreviewCardPenalState extends State<PreviewCardPanel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        VideoDao().addVideo(widget.videoModel);
        Application.navigateToIos(context, "/play", params: widget.videoModel);
      },
      onLongPress: () {},
      child: Container(
        child: BrnShadowCard(
          child: Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  CachedNetworkImage(
                      imageUrl: widget.videoModel.cover ?? "",
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
                      tagText: widget.videoModel.duration ?? "-",
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
                  widget.videoModel.title,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
