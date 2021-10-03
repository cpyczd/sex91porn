/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-29 11:42:48
 * @LastEditTime: 2021-10-02 22:02:55
 */

import 'package:flutter/material.dart';
import 'package:sex_91porn/pages/video_91.dart';
import 'package:sex_91porn/pages/video_db.dart';
import 'package:sex_91porn/util/application.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with AutomaticKeepAliveClientMixin<IndexPage> {
  DateTime? _lastPopTime;
  int _currentPageIndex = 0;

  ///返回NavPage页
  List<Widget> _getPageWidget() {
    return List.of([Video91Page(), VideoDbPage()]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _currentPageIndex = value;
            });
          },
          currentIndex: _currentPageIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w200),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.video_library), label: "实时"),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_activity), label: "本地历史")
          ],
        ),
        body: IndexedStack(
          children: _getPageWidget(),
          index: _currentPageIndex,
        ),
      ),
      onWillPop: () async {
        if (_lastPopTime == null ||
            DateTime.now().difference(_lastPopTime!) > Duration(seconds: 2)) {
          _lastPopTime = DateTime.now();
          ToastUtil.show(msg: "再按一次退出程序");
          return false;
        }
        return true;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
