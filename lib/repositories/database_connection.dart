import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_budgetAppSam_sqflite');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    database.execute("create table category(" +
        "catId INTEGER PRIMARY KEY," +
        "catName TEXT," +
        "maxAmount REAL," +
        "spentAmount REAL" +
        ");"
            "create table expense(" +
        "expenseId INTEGER PRIMARY KEY," +
        "catId INTEGER," +
        "expenseName TEXT," +
        "spentAmount REAL," +
        "spentDate TEXT," +
        "FOREIGN KEY (catId) REFERENCES category(catId)" +
        ");");
  }
}
