/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2022-03-19 12:56:54
 * @LastEditTime: 2022-03-19 20:09:48
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
          children: [
            ListTile(
              leading: Icon(Icons.source),
              title: Text("渠道-SIHU"),
              onTap: () => Application.navigateToIos(context, "/sihu"),
            )
          ],
        ),
      ),
    );
  }
}
