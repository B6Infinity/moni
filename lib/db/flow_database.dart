import 'package:moni/model/Flow.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FlowDatabase {
  static final FlowDatabase instance = FlowDatabase._init();

  static Database? _database;

  FlowDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('flow.db');
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

    await db.execute('''CREATE TABLE $tableFlows (

      ${FlowFields.id} $idType,
      ${FlowFields.name} $stringType,
      ${FlowFields.amt} $intType,
      ${FlowFields.date_of_flow} $stringType,
      ${FlowFields.is_income} $boolType


    )''');

    // https://www.youtube.com/watch?v=UpKrhZ0Hppk&t=293s&ab_channel=JohannesMilke
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // '''     CRUD       '''

  Future<MoneyFlow> create(MoneyFlow Flow) async {
    final db = await instance.database;

    final id = await db.insert(tableFlows, Flow.toJson());
    return Flow.copy(id: id);
  }

  Future<MoneyFlow?> readFlow(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableFlows,
      columns: FlowFields.values,
      where: '${FlowFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MoneyFlow.fromJson(maps.first);
    } else {
      // throw Exception('Flow $id not found');
      return null;
    }
  }

  Future<List<MoneyFlow>> readAllFlows() async {
    final db = await instance.database;

    final result = await db.query(tableFlows);

    return result.map((json) => MoneyFlow.fromJson(json)).toList();
    // ORDER BY　とか ?? https://youtu.be/UpKrhZ0Hppk?t=1189
  }

  Future<int> updateFlow(int id, MoneyFlow Flow) async {
    final db = await instance.database;

    return db.update(
      tableFlows,
      Flow.toJson(),
      where: '${FlowFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteFlow(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableFlows,
      where: '${FlowFields.id} = ?',
      whereArgs: [id],
    );
  }
}
