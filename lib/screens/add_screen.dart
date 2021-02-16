import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/services/expense_services.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatefulWidget {
  final catId;

  const AddScreen({Key key, this.catId}) : super(key: key);
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  var _addItemController = TextEditingController();
  var _addDescriptionController = TextEditingController();
  var _addDateController = TextEditingController();
  var _selectedValue;
  var _addAmountController = TextEditingController();
  var _categories = List<DropdownMenuItem>();
  var _expenseService = ExpenseService();
  DateTime _dateTime = DateTime.now();
  Expense _expense = Expense();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

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
          DropdownButtonFormField(
            value: _selectedValue,
            items: _categories,
            hint: Text('Category'),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () async {
              _expense.catId = widget.catId;
              _expense.datePurchased = _dateTime;
              _expense.desc = _addDescriptionController.text;
              _expense.expenseCost = double.parse(_addAmountController.text);
              _expense.expenseName = _addItemController.text;
              var result = _expenseService.saveExpense(_expense);
              print(result);
              Navigator.of(context).pushReplacementNamed('/');
            },
          )
        ]),
      ),
    );
  }
}
