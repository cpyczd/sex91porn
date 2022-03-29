import 'dart:convert';

import 'package:flutter/foundation.dart';

/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-06-16 10:10:02
 * @LastEditTime: 2022-03-27 22:09:25
 */

import 'package:shared_preferences/shared_preferences.dart';

import 'object_util.dart';

///时间单位
enum TimeExpireLevel { SECONDS, MINUTES, HOURS, DAY }

extension TimeExpireLevelExtension on TimeExpireLevel {
  String get name => describeEnum(this);
}

class SpUtil {
  ///获取实例对象
  static Future<SharedPreferences> getInstance() {
    return SharedPreferences.getInstance();
  }

  ///保存
  static Future<bool> save(String key, Map<String, dynamic> map,
      {int? exprie, TimeExpireLevel level = TimeExpireLevel.SECONDS}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _SpData _spData = _SpData(data: map);
    if (exprie != null) {
      DateTime expireDate;
      switch (level) {
        case TimeExpireLevel.SECONDS:
          expireDate = DateTime.now().add(Duration(seconds: exprie));
          break;
        case TimeExpireLevel.MINUTES:
          expireDate = DateTime.now().add(Duration(minutes: exprie));
          break;
        case TimeExpireLevel.HOURS:
          expireDate = DateTime.now().add(Duration(hours: exprie));
          break;
        case TimeExpireLevel.DAY:
          expireDate = DateTime.now().add(Duration(days: exprie));
          break;
        default:
          throw Exception("no time level!");
      }
      if (expireDate == null) {
        throw Exception("expireDate dont complate");
      }
      _spData.time = expireDate.millisecondsSinceEpoch;
      _spData.level = level;
    }
    return await prefs.setString(key, _spData.toJson());
  }

  ///get value
  ///[key] is key
  ///[returnExpire]  Do you need to return key->data if it expires
  ///[delExprie] Do you need to delete key if it expire
  static Future<Map?> getVal(String key,
      {bool returnExpire = false, bool delExprie = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val = prefs.getString(key);
    if (val == null) {
      return null;
    }
    var spData = _SpData.fromJson(val);
    if (spData.time == null) {
      return spData.data;
    }
    int time = spData.time!;
    int currTime = DateTime.now().millisecondsSinceEpoch;
    if (time < currTime) {
      if (delExprie) {
        //是否需要删除
        await prefs.remove(key);
      }
      if (!returnExpire) {
        //是否需要返回
        return null;
      }
    }
    return spData.data;
  }
}

///封装数据
class _SpData {
  TimeExpireLevel? level;
  int? time;
  final Map data;
  _SpData({
    this.level,
    this.time,
    required this.data,
  });

  _SpData copyWith({
    TimeExpireLevel? level,
    int? time,
    Map? data,
  }) {
    return _SpData(
      level: level ?? this.level,
      time: time ?? this.time,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'level': level?.name,
      'time': time,
      'data': data,
    };
  }

  factory _SpData.fromMap(Map<String, dynamic> map) {
    return _SpData(
      level: map['level'] != null
          ? EnumUtil.enumFromString(TimeExpireLevel.values, map['level'])
          : null,
      time: map['time'],
      data: Map.from(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory _SpData.fromJson(String source) =>
      _SpData.fromMap(json.decode(source));

  @override
  String toString() => '_SpData(level: $level, time: $time, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _SpData &&
        other.level == level &&
        other.time == time &&
        mapEquals(other.data, data);
  }

  @override
  int get hashCode => level.hashCode ^ time.hashCode ^ data.hashCode;
}
