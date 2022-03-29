/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-28 20:33:50
 * @LastEditTime: 2022-03-28 21:27:30
 */

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/pages/madou/common_widget.dart';
import 'package:sex_91porn/pages/madou/madou_config.dart';
import 'package:sex_91porn/util/object_util.dart';

import 'madou_service.dart';

///分类列表详情页
class MadouVideoList extends StatefulWidget {
  final MadouCategory? category;
  final String pageTitle;
  final String? searchText;

  MadouVideoList(
      {Key? key, this.category, required this.pageTitle, this.searchText})
      : super(key: key);

  @override
  State<MadouVideoList> createState() => _MadouVideoListState();
}

class _MadouVideoListState extends State<MadouVideoList> {
  int _current = 0;
  bool _isEnd = false;
  List<VideoModel> _videos = List.empty(growable: true);

  Future<void> _onLoad() async {
    if (!_isEnd) {
      _current++;
      List<VideoModel> list = List.empty();
      try {
        if (widget.category != null) {
          list = await MadouService.categoryVideo(widget.category!, _current);
        } else if (StringUtils.isNotBlank(widget.searchText)) {
          list = await MadouService.search(_current, widget.searchText!);
        } else {
          throw new Exception("category | searchText 不可全部为空");
        }
      } catch (e) {
        print("请求失败: $e");
      }

      if (list.isEmpty) {
        _isEnd = true;
        return;
      }
      list.removeWhere((le) =>
          _videos.indexWhere((element) => le.href == element.href) != -1);
      if (list.isEmpty) {
        _isEnd = true;
        print("全部爬完成: pageIndex: $_current, videoSize: ${_videos.length}");
        return;
      }
      setState(() {
        _videos.addAll(list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrnAppBar(
          brightness: Brightness.dark,
          title: widget.pageTitle,
          automaticallyImplyLeading: true),
      body: Container(
        padding: EdgeInsets.only(left: 2, right: 2),
        child: EasyRefresh(
          onLoad: _onLoad,
          enableControlFinishLoad: _isEnd,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(6),
                child: MadouVideoListTial(videoModel: _videos[index]),
              );
            },
            itemCount: _videos.length,
          ),
        ),
      ),
    );
  }
}
