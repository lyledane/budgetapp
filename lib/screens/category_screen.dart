import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/helpers/color_helper.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/screens/add_screen.dart';
import 'package:flutter_budget_ui/services/expense_services.dart';
import 'package:flutter_budget_ui/widgets/radial_painter.dart';

class CategoryScreen extends StatefulWidget {
  final Category catDetails;
  const CategoryScreen({Key key, this.catDetails}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var _expenseList;
  var _categoryService = ExpenseService();
  @override
  void initState() {
    super.initState();
    getAllExpenses();
  }

  getAllExpenses() async {
    setState(() {
      _expenseList = List<Expense>();
    });
    var categories = await _categoryService.getExpenses();
    categories.forEach((expense) {
      if (expense['catId'] == widget.catDetails.catId) {
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
      }
    });
  }

  _buildExpenses() {
    List<Widget> expenseList = [];
    _expenseList.forEach((Expense expense) {
      expenseList.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        height: 80.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blue,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                expense.expenseName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '-\$${expense.expenseCost.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ));
    });
    return Column(
      children: expenseList,
    );
  }

  @override
  Widget build(BuildContext context) {
    //double totalAmountSpent = widget.catDetails.spentAmount;
    final double amountLeft =
        widget.catDetails.maxAmount - widget.catDetails.spentAmount;
    final double percent = amountLeft / widget.catDetails.maxAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catDetails.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30.0,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddScreen(catDetails: widget.catDetails)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              height: 250.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: CustomPaint(
                foregroundPainter: RadialPainter(
                  bgColor: Colors.grey[200],
                  lineColor: getColor(context, percent),
                  percent: percent,
                  width: 15.0,
                ),
                child: Center(
                  child: Text(
                    '\$${amountLeft.toStringAsFixed(2)} / \$${widget.catDetails.maxAmount}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            _buildExpenses(),
          ],
        ),
      ),
    );
  }
}
