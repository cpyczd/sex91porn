/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 22:50:20
 * @LastEditTime: 2022-03-19 23:49:22
 */
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:sex_91porn/model/img_model.dart';

import '../util/brn_custom_photo_config.dart';

///图文详情页面
class ImageDetailPage extends StatefulWidget {
  final ImageModel model;

  ImageDetailPage({Key? key, required this.model}) : super(key: key);

  @override
  State<ImageDetailPage> createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrnAppBar(
          brightness: Brightness.dark,
          title: widget.model.title,
          automaticallyImplyLeading: true),
      body: Container(
          child: BrnGallerySummaryPage(
        rowCount: 3,
        allConfig: [
          BrnCustomPhotoGroupConfig.url(
              urls: widget.model.imageUrls, title: "全部")
        ],
      )),
    );
  }
}
