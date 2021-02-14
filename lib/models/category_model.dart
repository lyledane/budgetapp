import 'package:flutter_budget_ui/models/expense_model.dart';

class Category {
  final String id;
  final String name;
  final double maxAmount;
  final List<Expense> expenses;

  Category({this.id, this.name, this.maxAmount, this.expenses});
}
