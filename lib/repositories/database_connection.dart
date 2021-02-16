import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_budgetAppSam_sqflite');
    Database database = await openDatabase(path, version: 1);
    List<bool> tableExistence = await Future.wait([checkTableExistence(database, "category"), checkTableExistence(database, "expense")]);
    print("Category table exists ${tableExistence[0]}\nExpense table exists ${tableExistence[1]}");
    if (tableExistence[0] == false) {
      print("Category table does not exist, creating");
      await _createCategoryTable(database);
    }
    if (tableExistence[1] == false) {
      print("Expense table does not exist, creating");
      await _createExpenseTable(database);
    }
    return database;
  }

  Future<bool> checkTableExistence(Database db, String tableName) async {
    try {
      int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
      if (count != null) {
        return true;
      } else
        return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _createCategoryTable(Database database) async {
    await database.execute("create table category(" +
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

  Future<void> _createExpenseTable(Database database) async {
    await database.execute("create table expense(" +
        "expenseId INTEGER PRIMARY KEY," +
        "catId INTEGER," +
        "expenseName TEXT," +
        "desc TEXT," +
        "expenseCost REAL," +
        "datePurchased TEXT," +
        "FOREIGN KEY (catId) REFERENCES category(catId)" +
        ");");
  }
}
