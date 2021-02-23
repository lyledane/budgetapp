import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/services/category_service.dart';
import 'package:flutter_budget_ui/services/expense_services.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatefulWidget {
  static const route = 'addexpense';
  final Function populateExpenses;
  final Function populateCategory;

  const AddScreen({Key key, this.populateExpenses, this.populateCategory})
      : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  var _addItemController = TextEditingController();
  var _addDescriptionController = TextEditingController();
  var _addDateController = TextEditingController();
  var _addAmountController = TextEditingController();
  var _categories = TextEditingController();
  var _expenseService = ExpenseService();
  var _categoryService = CategoryService();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateTime _dateTime = DateTime.now();
  Expense _expense = Expense();
  Category catDetails;

  var _loadedInitData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loadedInitData) return;

    catDetails = ModalRoute.of(context).settings.arguments as Category;
    _categories.text = catDetails.name;
    _loadedInitData = true;
  }

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _addDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          TextField(
            controller: _addItemController,
            decoration: InputDecoration(
                labelText: 'Title', hintText: 'Write Todo Title'),
          ),
          TextField(
            controller: _addDescriptionController,
            decoration: InputDecoration(
                labelText: 'Description', hintText: 'Write Todo Description'),
          ),
          TextField(
            readOnly: true,
            controller: _addDateController,
            decoration: InputDecoration(
              labelText: 'Date',
              hintText: 'Pick a Date',
              prefixIcon: InkWell(
                onTap: () {
                  _selectedTodoDate(context);
                },
                child: Icon(Icons.calendar_today),
              ),
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _addAmountController,
            decoration:
                InputDecoration(labelText: 'Amount', hintText: 'Enter Amount'),
          ),
          TextField(
            readOnly: true,
            keyboardType: TextInputType.number,
            controller: _categories,
            decoration: InputDecoration(labelText: 'Category'),
          ),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () {
              setState(() {
                if (double.parse(_addAmountController.text) <
                    catDetails.maxAmount - catDetails.spentAmount) {
                  print(catDetails.spentAmount);
                  _expense.catId = catDetails.catId;
                  _expense.datePurchased = dateFormat.format(_dateTime);
                  _expense.desc = _addDescriptionController.text;
                  _expense.expenseCost =
                      double.parse(_addAmountController.text);
                  _expense.expenseName = _addItemController.text;
                  var result = _expenseService.saveExpense(_expense);
                  print(result);
                  catDetails.spentAmount = catDetails.spentAmount +
                      double.parse(_addAmountController.text);
                  _categoryService.updateCategory(catDetails);
                  widget.populateExpenses();
                  widget.populateCategory();
                }
                Navigator.of(context).pushReplacementNamed('/');
              });
            },
          )
        ]),
      ),
    );
  }
}
