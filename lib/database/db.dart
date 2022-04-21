import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  // construtor com acesso privado
  DB._();
  // instancia do DB
  static final DB instance = DB._();
  // instanca do SQLite
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'cripto.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_account);
    await db.execute(_wallet);
    await db.execute(_history);
    await db.insert('account', {'balance': 0});
  }

  String get _account => '''
    CREATE TABLE account (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      balance REAL
    );
  ''';

  String get _wallet => '''
    CREATE TABLE wallet (
      initials TEXT PRIMARY KEY,
      coin TEXT,
      amount TEXT
    );
  ''';

  String get _history => '''
    CREATE TABLE history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date_operation INT,
      type_operation TEXT,
      coin TEXT,
      initials TEXT,
      value REAL,
      amount TEXT
    );
  ''';
}
