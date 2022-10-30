import 'package:moni/model/node.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NodesDatabase {
  static final NodesDatabase instance = NodesDatabase._init();

  static Database? _database;

  NodesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('nodes.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const stringType = 'TEXT NOT NULL';
    const listType = 'LIST NOT NULL';

    await db.execute('''CREATE TABLE $tableNodes (

      ${NodeFields.id} $idType,
      ${NodeFields.name} $stringType,
      ${NodeFields.bg_color} $stringType,
      ${NodeFields.txt_color} $stringType,
      ${NodeFields.size} $stringType,
      ${NodeFields.coords} $listType,
      ${NodeFields.max_amt} $intType,
      ${NodeFields.present_amt} $intType


    )''');

    // https://www.youtube.com/watch?v=UpKrhZ0Hppk&t=293s&ab_channel=JohannesMilke
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
