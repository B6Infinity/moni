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
      ${NodeFields.max_amt} $intType,
      ${NodeFields.present_amt} $intType


    )''');

    // https://www.youtube.com/watch?v=UpKrhZ0Hppk&t=293s&ab_channel=JohannesMilke
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // '''     CRUD       '''

  Future<Node> create(Node node) async {
    final db = await instance.database;

    final id = await db.insert(tableNodes, node.toJson());
    return node.copy(id: id);
  }

  Future<Node?> readNode(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNodes,
      columns: NodeFields.values,
      where: '${NodeFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Node.fromJson(maps.first);
    } else {
      // throw Exception('Node $id not found');
      return null;
    }
  }

  Future<List<Node>> readAllNodes() async {
    final db = await instance.database;

    final result = await db.query(tableNodes);

    return result.map((json) => Node.fromJson(json)).toList();
    // ORDER BY　とか ?? https://youtu.be/UpKrhZ0Hppk?t=1189
  }

  Future<int> updateNode(Node node) async {
    final db = await instance.database;

    return db.update(
      tableNodes,
      node.toJson(),
      where: '${NodeFields.id} = ?',
      whereArgs: [node.id],
    );
  }

  Future<int> deleteNode(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNodes,
      where: '${NodeFields.id} = ?',
      whereArgs: [id],
    );
  }
}
