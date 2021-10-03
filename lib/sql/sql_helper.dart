/*
 * @Description: 
 * @Author: chenzedeng
 * @Date: 2021-01-26 15:32:37
 * @LastEditTime: 2021-10-02 22:14:07
 */
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlHelper {
  static const _VERSION = 1;

  static const _NAME = "free_91porn.db";

  static Database? _database;

  static init() async {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, _NAME);

    _database = await openDatabase(path,
        version: _VERSION, onCreate: (Database db, int version) async {});
  }

  ///获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database!;
  }

  ///判断表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database!.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  ///关闭
  static close() {
    _database?.close();
  }
}

///Sql 提供者父类对象
abstract class SqlBaseProvider {
  String getTableName();

  String getTableCreateSql();

  ///获取数据库对象
  Future<Database> getDataBase() async {
    return await prepare();
  }

  prepare() async {
    var isTableExist = await SqlHelper.isTableExits(getTableName());
    if (!isTableExist) {
      Database database = await SqlHelper.getCurrentDatabase();
      await database.execute(getTableCreateSql());
    }
    return await SqlHelper.getCurrentDatabase();
  }
}
