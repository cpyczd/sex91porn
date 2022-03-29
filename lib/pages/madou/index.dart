/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-28 14:05:44
 * @LastEditTime: 2022-03-28 20:53:59
 */
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/pages/madou/madou_config.dart';
import 'package:sex_91porn/pages/madou/madou_service.dart';
import 'package:sex_91porn/util/application.dart';

import 'common_widget.dart';

class MadouIndexPage extends StatefulWidget {
  MadouIndexPage({Key? key}) : super(key: key);

  @override
  State<MadouIndexPage> createState() => _MadouIndexPageState();
}

class _MadouIndexPageState extends State<MadouIndexPage> {
  ///分类列表
  List<MadouCategory> _categoryList = List.empty(growable: true);
  List<MadouCategory> _categoryListAll = List.empty(growable: true);

  ///视屏列表
  List<VideoModel> _videos = List.empty(growable: true);

  int _current = 0;
  bool _isEnd = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      _initCategory();
    });
    super.initState();
  }

  ///加载分类
  void _initCategory() {
    BrnLoadingDialog.show(context);
    MadouService.getCategoryList().then((value) {
      _categoryListAll = value;
      _categoryList.addAll(value.sublist(0, 7));
      _categoryList.add(MadouCategory(
          title: "更多企划",
          href: "",
          icon: Icon(
            Icons.more_horiz,
            color: Theme.of(context).primaryColor,
          )));
      setState(() {});
      BrnLoadingDialog.dismiss(context);
    }).catchError((error, stackTrace) {
      BrnLoadingDialog.dismiss(context);
      print("error:$error, stackTrace:$stackTrace");
      ToastUtil.show(msg: "加载失败");
    });
  }

  Future<void> _onLoad() async {
    if (!_isEnd) {
      _current++;
      var list = await MadouService.hotVideoList(_current);
      if (list.isEmpty) {
        _isEnd = true;
        return;
      }
      list.removeWhere((le) =>
          _videos.where((element) => element.href == le.href).isNotEmpty);
      if (list.isEmpty) {
        _isEnd = true;
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
        appBar: BrnSearchAppbar(
          leading: IconButton(
            alignment: Alignment.centerLeft,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => {Application.router.pop(context)},
          ),
          hint: "点击输入关键字搜索!",
          autoFocus: false,
          searchBarInputSubmitCallback: (text) {
            print("搜索回调内容:$text");
            if (text.isNotEmpty) {
              Application.navigateToIos(context, "/madouVideoList",
                  params: text);
            } else {
              ToastUtil.show(msg: "请输入要查询的内容");
            }
          },
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: EasyRefresh(
            enableControlFinishLoad: _isEnd,
            onLoad: _onLoad,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                    child: BrnDashedLine(
                      contentWidget: Padding(
                        child: Text("精选企划方分类"),
                        padding: EdgeInsets.only(left: 10),
                      ),
                      axis: Axis.vertical,
                      color: Colors.blueAccent,
                      dashedSpacing: 0,
                      dashedThickness: 2,
                    ),
                  ),
                ),
                SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      var category = _categoryList[index];
                      return BrnIconButton(
                        direction: Direction.bottom,
                        name: category.title,
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                        iconWidget: category.icon ??
                            Icon(
                              Icons.category_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                        onTap: () {
                          //点击事件
                          if (category.href.isEmpty) {
                            BrnMultiSelectTagsPicker(
                              pickerTitleConfig: BrnPickerTitleConfig(
                                  titleContent: '企划方筛选',
                                  confirm: SizedBox(),
                                  cancel: SizedBox()),
                              tagPickerConfig: BrnTagsPickerConfig(
                                  tagItemSource: _categoryListAll
                                      .map((e) => BrnTagItemBean(
                                          name: e.title,
                                          code: e.href,
                                          ext: e.toMap()))
                                      .toList()),
                              context: context,
                              onTagValueGetter: (choice) {
                                return choice.name;
                              },
                              onConfirm: (value) {},
                              onItemClick:
                                  (BrnTagItemBean onTapTag, bool isSelect) {
                                Navigator.of(context).pop();
                                Application.navigateToIos(
                                    context, "/madouVideoList",
                                    params:
                                        MadouCategory.fromMap(onTapTag.ext!));
                              },
                              crossAxisCount: 4,
                              layoutStyle: BrnMultiSelectTagsLayoutStyle.auto,
                              maxSelectItemCount: 1,
                            ).show();
                          } else {
                            Application.navigateToIos(
                                context, "/madouVideoList",
                                params: category);
                          }
                        },
                      );
                    }, childCount: _categoryList.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, childAspectRatio: 1)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                    child: BrnDashedLine(
                      contentWidget: Padding(
                        child: Text("热门推荐"),
                        padding: EdgeInsets.only(left: 10),
                      ),
                      axis: Axis.vertical,
                      color: Colors.blueAccent,
                      dashedSpacing: 0,
                      dashedThickness: 2,
                    ),
                  ),
                ),
                SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: EdgeInsets.all(5),
                        child: MadouVideoListTial(videoModel: _videos[index]),
                      );
                    }, childCount: _videos.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1))
              ],
            ),
          ),
        ));
  }
}
