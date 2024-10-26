import 'package:sqflite/sqflite.dart';
import '../../Model/item.dart';
import 'database_helper.dart';

class TodoDao {
  static const String tableSql = 'CREATE TABLE $_tableName ('
      '$_id INTEGER PRIMARY KEY, '
      '$_title TEXT, '
      '$_description TEXT, '
      '$_isDone INTEGER, '
      ')';

  static const String _tableName = 'todo';
  static const String _id = 'id';
  static const String _title = 'title';
  static const String _description = 'description';
  static const String _isDone = 'isDone';

  Future<Database> getDatabase() async {
    return await DatabaseHelper.instance.database;
  }

  Future<int> save(Item item) async {
    final Database db = await getDatabase();
    Map<String, dynamic> itemMap = _toMap(item);
    return db.insert(_tableName, itemMap);
  }

  Future<int> update(Item item) async {
    final Database db = await getDatabase();
    final Map<String, dynamic> itemMap = _toMap(item);
    return db.update(
      _tableName,
      itemMap,
      where: '$_id = ?',
      whereArgs: [item.id],
    );
  }

  Future<List<Item>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Item> itens = _toList(result);
    return itens;
  }

  void remove(int id) async {
    final Database db = await getDatabase();
    db.delete(
      _tableName,
      where: '$_id = ?',
      whereArgs: [id],
    );
  }

  void removeAll() async {
    final Database db = await getDatabase();
    db.delete(_tableName);
  }

  Map<String, dynamic> _toMap(Item item) {
    final Map<String, dynamic> itemMap = {};
    itemMap[_title] = item.title;
    itemMap[_description] = item.description;
    itemMap[_isDone] = item.isDone ? 0 : 1;
    return itemMap;
  }

  List<Item> _toList(List<Map<String, dynamic>> result) {
    final List<Item> itens = [];
    for (Map<String, dynamic> row in result) {
      final Item item = Item(
        id: row[_id],
        title: row[_title],
        description: row[_description],
        isDone: row[_isDone] == 1 ? false : true,
      );
      itens.add(item);
    }
    return itens;
  }
}
