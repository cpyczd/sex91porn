/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-05-21 22:59:39
 * @LastEditTime: 2022-03-27 22:09:55
 */
import 'package:collection/collection.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class EnumUtil {
  ///枚举类型转string
  static String enumToString(o) => o.toString().split('.').last;

  ///string转枚举类型
  static T? enumFromString<T>(List<T> values, String value) {
    return values
        .firstWhereOrNull((type) => type.toString().split('.').last == value);
  }
}

///format number to local number.
///example 10001 -> 1万
///        100 -> 100
///        11000-> 1.1万
String getFormattedNumber(int number) {
  if (number < 10000) {
    return number.toString();
  }
  number = number ~/ 10000;
  return "$number万";
}

///字符串工具类
class StringUtils {
  ///判断字符串是否不为空
  static bool isNotBlank(String? str) {
    return str != null && str.isNotEmpty;
  }

  ///判断字符串是否为空
  static bool isBlank(String? str) {
    return str == null || str.isEmpty;
  }
}
