import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/repositories/repository.dart';

class ExpenseService {
  Repository _repository;
  ExpenseService() {
    _repository = Repository();
  }
  saveExpense(Expense expense) async {
    return await _repository.insertData('expense', expense.expenseMap());
  }

  deleteExpense(itemId) async {
    return _repository.deleteData('expense', itemId);
  }

  getExpenses() async {
    return _repository.readData('expense');
  }
}
