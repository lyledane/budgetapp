class Expense {
  int expenseId;
  int catId;
  String expenseName;
  String desc;
  double expenseCost;
  DateTime datePurchased;

  expenseMap() {
    var mapping = Map<String, dynamic>();
    mapping['desc'] = desc;
    mapping['expenseId'] = expenseId;
    mapping['catId'] = catId;
    mapping['expenseCost'] = expenseCost;
    mapping['datePurchased'] = datePurchased;
    mapping['expenseName'] = expenseName;

    return mapping;
  }
}
