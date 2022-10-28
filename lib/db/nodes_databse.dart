import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NodesDatabase {
  static final NodesDatabase instance = NodesDatabase._init();

  static Database? _database;

  NodesDatabase._init();

  Future<Database> get _database async {
    if (_database != null) return _database!;

    _database = await _initDB('nodes.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {}

  Future close() async {
    final db = await instance._database;
    db.close();
  }
}
