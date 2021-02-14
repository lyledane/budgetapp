import 'package:flutter_budget_ui/data/dummy_data_expenses.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';

List<Expense> itemList = dummyDataExpense;
List<Category> dummyCategories = [
  Category(
    catId: 0,
    name: 'Food',
    maxAmount: 100,
    spentAmount: totalCalculator(0),
  ),
  Category(
      catId: 1,
      name: 'Furniture',
      maxAmount: 200,
      spentAmount: totalCalculator(1)),
  Category(
      catId: 2,
      name: 'School',
      maxAmount: 300,
      spentAmount: totalCalculator(2)),
];

double totalCalculator(int thiscatID) {
  double sum = 0;
  for (var i = 0; i < itemList.length; i++) {
    if (itemList[i].catId == thiscatID) sum += itemList[i].itemCost;
  }
  print(sum);
  return sum;
}
