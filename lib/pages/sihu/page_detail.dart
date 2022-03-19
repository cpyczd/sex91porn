/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 19:13:40
 * @LastEditTime: 2022-03-19 20:04:01
 */
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sex_91porn/model/pair.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/pages/sihu/common_widget.dart';
import 'package:sex_91porn/pages/sihu/data_service.dart';
import 'package:sex_91porn/util/application.dart';

import 'model_entity.dart';

///分类详情
class SihuPageDetail extends StatefulWidget {
  final SihuCategoryModel categoryModel;

  SihuPageDetail({Key? key, required this.categoryModel}) : super(key: key);

  @override
  State<SihuPageDetail> createState() => _SihuPageDetailState();
}

class _SihuPageDetailState extends State<SihuPageDetail> {
  final EasyRefreshController _controller = EasyRefreshController();

  final List<VideoModel> _modelList = List.empty(growable: true);

  int _currentPageIndex = 0;

  int _maxPageSize = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrnAppBar(
          brightness: Brightness.dark,
          title: widget.categoryModel.title,
          automaticallyImplyLeading: true),
      body: Container(
        child: EasyRefresh(
          enableControlFinishLoad: _maxPageSize <= _currentPageIndex,
          firstRefresh: true,
          controller: _controller,
          onRefresh: () async {
            _currentPageIndex = 0;
            _modelList.clear();
            return;
          },
          onLoad: _onLoadData,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(6),
                child: PreviewCardPanel(videoModel: _modelList[index]),
              );
            },
            itemCount: _modelList.length,
          ),
        ),
      ),
    );
  }

  ///加载数据
  Future<void> _onLoadData() async {
    _currentPageIndex++;
    if (_currentPageIndex >= _maxPageSize) {
      ToastUtil.show(msg: "没有更多了");
      return;
    }
    Pair<int, List<VideoModel>> pair = await SihuDataService.getCategoryInfo(
        widget.categoryModel, _currentPageIndex);
    _maxPageSize = pair.key;
    setState(() {
      _modelList.addAll(pair.value);
    });
    print(
        "抓取新数据===>>爬取页码:$_currentPageIndex, 页码数量：${pair.key} , 列表长度: ${pair.value.length}");
    return;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
