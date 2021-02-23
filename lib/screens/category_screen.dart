import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/helpers/color_helper.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/screens/add_screen.dart';
import 'package:flutter_budget_ui/widgets/radial_painter.dart';

class CategoryScreen extends StatefulWidget {
  static const route = 'category';
  final List<Expense> expenseList;
  final Function deleteExpense;
  final Function populateExpenses;

  const CategoryScreen(
      {Key key, this.expenseList, this.deleteExpense, this.populateExpenses})
      : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Expense> _expenseList;
  Category catDetail;
  var _loadedInitData = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loadedInitData) return;
    catDetail = ModalRoute.of(context).settings.arguments as Category;
    _categoryExpenses();
    _loadedInitData = true;
  }

  _categoryExpenses() {
    _expenseList = List<Expense>();
    widget.expenseList.forEach((cat) {
      if (cat.catId == catDetail.catId) _expenseList.add(cat);
    });
  }

  _buildExpenses() {
    List<Widget> expenseList = [];
    _expenseList.forEach((Expense expense) {
      expenseList.add(InkWell(
        onLongPress: () {
          return showDialog(
              context: context,
              barrierDismissible: true,
              builder: (param) {
                return AlertDialog(
                  title: Text('Delete ${expense.expenseName}?'),
                  actions: [
                    RaisedButton(
                        child: Text('No'),
                        onPressed: () => Navigator.pop(context)),
                    RaisedButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          catDetail.spentAmount -= expense.expenseCost;
                          widget.deleteExpense(expense.expenseId, catDetail);
                          _categoryExpenses();
                        });
                      },
                    )
                  ],
                );
              });
        },
        child: Container(
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
    final double amountLeft = catDetail.maxAmount - catDetail.spentAmount;
    final double percent = amountLeft / catDetail.maxAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text(catDetail.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30.0,
            onPressed: () => Navigator.of(context)
                .pushNamed(AddScreen.route, arguments: catDetail),
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
                    '\$${amountLeft.toStringAsFixed(2)} / \$${catDetail.maxAmount}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Long Press to Delete an Expense',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[400],
                  fontSize: 10),
            ),
            _buildExpenses(),
          ],
        ),
      ),
    );
  }
}
