import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:slime_farm/Model/slime_model.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('slimes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final integerType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';

    await db.execute('''CREATE TABLE $tableSlimes ( 
      ${SlimeFields.id} $idType,
      ${SlimeFields.name} $textType,
      ${SlimeFields.isFavourite} $boolType,
      ${SlimeFields.timestamp} $textType
      ${SlimeFields.colorGeneA} $integerType,
      ${SlimeFields.colorGeneB} $integerType,
    )''');
  }

  Future<Slime> create(Slime slime) async {
    final db = await instance.database;
    final id = await db.insert(tableSlimes, slime.toJson());

    return slime.copy(id: id);
  }

  Future<Slime> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableSlimes,
      columns: SlimeFields.values,
      where: '${SlimeFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Slime.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Slime>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${SlimeFields.timestamp} ASC';

    final result = await db.query(tableSlimes, orderBy: orderBy);
    //final result = await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    return result.map((json) => Slime.fromJson(json)).toList();
  }

  Future<int> update(Slime slime) async {
    final db = await instance.database;

    return db.update(
      tableSlimes,
      slime.toJson(),
      where: '${SlimeFields.id} = ?',
      whereArgs: [slime.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableSlimes,
      where: '${SlimeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
