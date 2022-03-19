/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-26 15:33:29
 * @LastEditTime: 2022-03-19 18:44:46
 */

import 'package:sex_91porn/model/video_model.dart';
import 'package:sex_91porn/sql/sql_helper.dart';
import 'package:sqflite/sqlite_api.dart';

class VideoDao extends SqlBaseProvider {
  @override
  String getTableCreateSql() {
    return '''
      create table if not exists ${getTableName()} (
      N_ID INTEGER PRIMARY KEY autoincrement,-- 编号ID主键
      id INTEGER  ,-- 视屏ID
      title varchar(50) NOT NULL , -- 标题
      cover varchar(100) NOT NULL,  -- 封面
      duration varchar(50),  -- 时长
      createTime varchar(50)  , -- 上传时间
      topCount int(11) default 1,  -- 查看次数
      href varchar(100) not NULL , -- 原始视屏链接
      src varchar(100) not NULL  -- 视屏播放地址 m3u8
    );
    ''';
  }

  @override
  String getTableName() {
    return "video";
  }

  ///查询
  Future<List<VideoModel>> queryList(
      {int current = 1,
      int size = 10,
      String? search,
      bool hotSort = false}) async {
    Database database = await getDataBase();
    String where = "";
    if (search != null && search.isNotEmpty) {
      where += 'title like %$search%';
    }
    return (await database.query(getTableName(),
            where: where,
            orderBy: hotSort ? 'topCount' : 'createTime' + " desc",
            limit: size,
            offset: size * current))
        .map((e) => VideoModel.fromMap(e))
        .toList();
  }

  Future<List<VideoModel>> queryAll() async {
    Database database = await getDataBase();
    return (await database.query(getTableName()))
        .map((e) => VideoModel.fromMap(e))
        .toList();
  }

  Future<int> addVideo(VideoModel model) async {
    Database database = await getDataBase();
    //判断库中是否存在记录
    var resList = await database.rawQuery(
        "select count(N_ID) as count from ${getTableName()} where id != 0 and id = ? or href = ? limit 1",
        [model.id, model.href]);
    if (resList[0]["count"] != 0) {
      return -1;
    }
    Map<String, dynamic> values = model.toMap();
    return await database.insert(getTableName(), values,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  ///清空所有的数据
  Future<int> clearAll() async {
    Database database = await getDataBase();
    return await database.delete(getTableName());
  }
}
