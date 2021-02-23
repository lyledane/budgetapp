import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/screens/addEdit.dart';
import 'package:flutter_budget_ui/screens/add_screen.dart';
import 'package:flutter_budget_ui/screens/category_screen.dart';
import 'package:flutter_budget_ui/screens/home_screen.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/services/category_service.dart';
import 'package:flutter_budget_ui/services/expense_services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Category> _categoryList;
  List<Expense> _expenseList;
  var _categoryService = CategoryService();
  var _expenseService = ExpenseService();

  populateCategories() async {
    setState(() {
      _categoryList = List<Category>();
    });

    var categories = await _categoryService.getCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.catId = category['catId'];
        categoryModel.name = category['catName'];
        categoryModel.maxAmount = category['maxAmount'];
        categoryModel.spentAmount = category['spentAmount'];
        _categoryList.add(categoryModel);
      });
    });
  }

  populateExpenses() async {
    setState(() {
      _expenseList = List<Expense>();
    });
    var categories = await _expenseService.getExpenses();
    categories.forEach((expense) {
      setState(() {
        var expenseModel = Expense();
        expenseModel.desc = expense['desc'];
        expenseModel.expenseId = expense['expenseId'];
        expenseModel.catId = expense['catId'];
        expenseModel.expenseCost = expense['expenseCost'];
        expenseModel.datePurchased = expense['datePurchased'];
        expenseModel.expenseName = expense['expenseName'];
        _expenseList.add(expenseModel);
      });
    });
  }

  deleteCatItems(catId) async {
    var expenses = await _expenseService.getExpenses();
    expenses.forEach((expense) async {
      if (expense['catId'] == catId)
        await _expenseService.deleteExpense(expense['expenseId']);
    });
  }

  deleteCategory(catId) async {
    deleteCatItems(catId);
    await _categoryService.deleteCategory(catId);
    populateCategories();
    populateExpenses();
  }

  deleteExpense(expenseId, category) async {
    await _expenseService.deleteExpense(expenseId);
    await _categoryService.updateCategory(category);
    populateCategories();
    populateExpenses();
  }

  @override
  void initState() {
    super.initState();
    populateCategories();
    populateExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Budget UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: HomeScreen(
        deleteCategory: deleteCategory,
        categoryList: _categoryList,
        expenseList: _expenseList,
      ),
      routes: {
        AddEditTemp.route: (ctx) => AddEditTemp(
              populateCategories: populateCategories,
            ),
        CategoryScreen.route: (ctx) => CategoryScreen(
              populateExpenses: populateExpenses,
              expenseList: _expenseList,
              deleteExpense: deleteExpense,
            ),
        AddScreen.route: (ctx) => AddScreen(
              populateExpenses: populateExpenses,
              populateCategory: populateCategories,
            ),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        );
      },
    );
  }
}
