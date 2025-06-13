// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart' as path;

// import '../../src.dart';

// class RecommendDatabase {
//   static final RecommendDatabase instance = RecommendDatabase._init();
//   static const String _databaseName = AppConstants.RECOM_DB_PATH;
//   static const int _databaseVersion = 1;

//   Database? _database;

//   RecommendDatabase._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   _initDatabase() async {
//     final databasePath = await getDatabasesPath();
//     final fullPath = path.join(databasePath, _databaseName);

//     return await openDatabase(fullPath,
//         version: _databaseVersion, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//     CREATE TABLE calendar_notes (
//       id ${DBConstants.idType},
//       date ${DBConstants.textType},
//       description ${DBConstants.textType},
//       etype ${DBConstants.textType},
//       event ${DBConstants.textType},
//       isHoliday ${DBConstants.boolType}
//     )
//     ''');
//   }

//   Future<CalendarNote> create(CalendarNote note) async {
//     final db = await instance.database;

//     final id = await db.insert(
//       'calendar_notes',
//       note.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     return note.copy(id: id);
//   }

//   Future<CalendarNote> readNoteById(int id) async {
//     final db = await instance.database;

//     final maps = await db.query(
//       'calendar_notes',
//       columns: ['id', 'date', 'description', 'etype', 'event', 'isHoliday'],
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (maps.isNotEmpty) {
//       return CalendarNote.fromMap(maps.first);
//     } else {
//       throw Exception('ID $id not found');
//     }
//   }

//   Future<List<CalendarNote>> getAllNotes() async {
//     final db = await instance.database;

//     final List<Map<String, dynamic>> maps = await db.query('calendar_notes');

//     return List.generate(maps.length, (i) => CalendarNote.fromMap(maps[i]));
//   }

//   Future<int> update(CalendarNote note) async {
//     final db = await instance.database;

//     return db.update(
//       'calendar_notes',
//       note.toMap(),
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );
//   }

//   Future<int> delete(int id) async {
//     final db = await instance.database;

//     return await db.delete(
//       'calendar_notes',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   Future close() async {
//     final db = await instance.database;

//     db.close();
//   }

//   Future<void> upgradeDB(int oldVersion, int newVersion) async {
//     if (oldVersion < newVersion) {
//       await _initDatabase();
//     }
//   }
// }
