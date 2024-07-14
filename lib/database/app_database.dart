import 'dao/todo_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'todolist.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(TodoDao.tableSql);
    },
    version: 1,
  );
}
