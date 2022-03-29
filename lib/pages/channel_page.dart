/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 12:56:54
 * @LastEditTime: 2022-03-29 19:10:39
 */
import 'package:flutter/material.dart';
import 'package:sex_91porn/util/application.dart';

class ChannelPage extends StatefulWidget {
  ChannelPage({Key? key}) : super(key: key);

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "其他渠道资源",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            ListTile(
              leading: Icon(
                Icons.insert_emoticon_outlined,
                color: Theme.of(context).primaryColor,
              ),
              title: Text("综合-1"),
              subtitle: Text("综合资源"),
              onTap: () => Application.navigateToIos(context, "/sihu"),
            ),
            ListTile(
              leading: Icon(Icons.storage_rounded,
                  color: Theme.of(context).primaryColor),
              title: Text("国产-1"),
              subtitle: Text("综合企划国产剧情资源"),
              onTap: () => Application.navigateToIos(context, "/madou"),
            )
          ],
        ),
      ),
    );
  }
}
