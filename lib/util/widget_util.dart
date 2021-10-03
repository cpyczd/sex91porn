/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2020-08-09 10:55:01
 * @LastEditTime: 2021-10-02 22:20:33
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtil {
  static bool _isLoading = false;

  ///显示一个Alert 提示框
  static void showAlertMessageDialog(BuildContext context, String message,
      {Function? call, String title = "提示"}) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Center(
              child: Text(message),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("确定"),
                onPressed: () {
                  Navigator.pop(context);
                  if (call != null) {
                    call();
                  }
                },
              )
            ],
          );
        });
  }

  ///弹出一个询问框
  static void showConfirmDialog(BuildContext context, String message,
      {Function? ok,
      Function? cancel,
      String okText = "确定",
      String cancenText = "取消",
      String title = "提示"}) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Center(
              child: Text(message),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(okText),
                onPressed: () {
                  Navigator.pop(context);
                  if (ok != null) {
                    ok();
                  }
                },
              ),
              CupertinoDialogAction(
                child: Text(cancenText),
                onPressed: () {
                  Navigator.pop(context);
                  if (cancel != null) {
                    cancel();
                  }
                },
              )
            ],
          );
        });
  }

  ///打开加载对话框
  static void showLoading(BuildContext context, String msg,
      {bool barrierDismissible = true}) {
    if (_isLoading) {
      Navigator.pop(context);
    }
    _isLoading = true;
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return UnconstrainedBox(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2 + 50,
              child: CupertinoAlertDialog(
                content: Column(
                  children: [
                    CupertinoActivityIndicator(
                      animating: true,
                      radius: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(msg),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showSmallLoading(BuildContext context) {
    if (_isLoading) {
      Navigator.pop(context);
    }
    _isLoading = true;
    double size = MediaQuery.of(context).size.width / 2;
    showDialog(
        context: context,
        builder: (context) {
          return UnconstrainedBox(
            child: SizedBox(
              width: size,
              child: AlertDialog(
                content: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          );
        });
  }

  ///关闭加载对话框
  static void closeLoading(BuildContext context) {
    if (_isLoading) {
      if (context != null) {
        Navigator.pop(context);
      }
      _isLoading = false;
    }
  }

  ///只是设置为flag为关闭
  static void closeLoadingFlag() {
    _isLoading = false;
  }

  //显示一个输入框
  static void showInputDialog(BuildContext context,
      {Function? call,
      String title = "提示",
      String? placeholder,
      String? initVal}) {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController editingController = TextEditingController();
          if (initVal != null && initVal.isNotEmpty) {
            editingController.text = initVal;
          }
          return CupertinoAlertDialog(
            title: Text(title),
            content: Container(
              child: CupertinoTextField(
                placeholder: placeholder,
                controller: editingController,
                autofocus: true,
                keyboardType: TextInputType.text,
                maxLines: 1,
                maxLength: 30,
                textInputAction: TextInputAction.done,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("提交"),
                onPressed: () {
                  String text = editingController.text;
                  if (call != null) {
                    call(text);
                  }
                },
              ),
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
