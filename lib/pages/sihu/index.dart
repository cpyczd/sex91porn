/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 15:09:52
 * @LastEditTime: 2022-03-19 23:03:42
 */
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/pages/sihu/common_widget.dart';
import 'package:sex_91porn/pages/sihu/data_service.dart';
import 'package:sex_91porn/util/application.dart';
import 'config.dart';

class SihuIndexPage extends StatefulWidget {
  SihuIndexPage({Key? key}) : super(key: key);

  @override
  State<SihuIndexPage> createState() => _SihuIndexPageState();
}

class _SihuIndexPageState extends State<SihuIndexPage> {
  @override
  void initState() {
    SihuDataService.getIndexVideoList().then((value) {
      print("valueSize ${value.length}=====>>> ${value[0]}");
    });
    super.initState();
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
            Application.navigateToIos(context, "/sihuSearch", params: text);
          } else {
            ToastUtil.show(msg: "请输入要查询的内容");
          }
        },
      ),
      body: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                child: BrnDashedLine(
                  contentWidget: Padding(
                    child: Text("视屏分类"),
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
                var category = CATEGORY_CONFIG[index];
                return BrnIconButton(
                  direction: Direction.bottom,
                  name: category.title,
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                  iconWidget: category.icon,
                  onTap: () {
                    //点击事件
                    Application.navigateToIos(context, "/sihuDetail",
                        params: category);
                  },
                );
              }, childCount: CATEGORY_CONFIG.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 1.5),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                child: BrnDashedLine(
                  contentWidget: Padding(
                    child: Text("最新视屏"),
                    padding: EdgeInsets.only(left: 10),
                  ),
                  axis: Axis.vertical,
                  color: Colors.blueAccent,
                  dashedSpacing: 0,
                  dashedThickness: 2,
                ),
              ),
            ),
            FutureBuilder<List<VideoModel>>(
                future: SihuDataService.getIndexVideoList(),
                builder: (context, as) {
                  if (as.hasData) {
                    var list = as.requireData;
                    return SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: EdgeInsets.all(5),
                            child: PreviewCardPanel(videoModel: list[index]),
                          );
                        }, childCount: list.length),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1));
                  } else {
                    return SliverToBoxAdapter(
                        child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.blueAccent)),
                          SizedBox.fromSize(
                            size: Size.fromHeight(10),
                          ),
                          Text("加载中...")
                        ],
                      ),
                    ));
                  }
                })
          ],
        ),
      ),
    );
  }
}
