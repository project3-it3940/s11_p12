import 'package:flutter_app/user.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseService {
  static final DataBaseService _dateBaseService = DataBaseService._internal();

  factory DataBaseService() => _dateBaseService;

  DataBaseService._internal();

  static Database? _database;

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Users(id TEXT PRIMARY KEY, name TEXT, email TEXT, age INTERGER)");
    print("CREATED");
  }

  Future<Database> initDataBase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = "${getDirectory.path}/users.db";
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<Database> get database async {
    print("get database");
    if (_database != null) return _database!;
    _database = await initDataBase();
    return _database!;
  }

  Future<List<UserModel>> getUsers() async {
    try {
      final db = await _dateBaseService.database;
      var data = await db.rawQuery("SELECT * FROM Users");
      List<UserModel> users = List.generate(
          data.length, (index) => UserModel.fromJson(data[index]));
      print(users.length);
      return users;
    } catch (e) {
      return [];
    }
  }

  Future<void> insertUser(UserModel user) async {
    final db = await _dateBaseService.database;
    var data = await db.rawInsert(
        'INSERT INTO Users(id, name, email, age) VALUES(?, ?, ?, ?)',
        [user.id, user.name, user.email, user.age]);
    print("insert ${data.toString()}");
  }

  Future<void> editUser(UserModel user) async {
    print("preUser ${user.name}");
    final db = await _dateBaseService.database;
    var data = await db.rawUpdate(
        'UPDATE Users SET name=?,email=?,age=? WHERE id=?',
        [user.name, user.email, user.age, user.id]);
    print("update ${data.toString()}");
  }

  Future<void> deleteUser(String id) async {
    final db = await _dateBaseService.database;
    var data = await db
        .rawDelete('DELETE from Users WHERE id=?', [id]);
    print("delete ${data.toString()}");
  }
}
