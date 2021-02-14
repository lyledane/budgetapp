import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/data/dummy_data_expenses.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:intl/intl.dart';

class BarChart extends StatefulWidget {
  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  DateTime date = DateTime.now();
  @override
  void initState() {
    while (date.weekday != DateTime.saturday) {
      date = date.add(Duration(days: 1));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mostExpensive = 0;
    List<double> expenses = [];
    List<Expense> week = dummyDataExpense;
    DateTime dateTrav = date;

    for (var i = 0; i < 7; i++) {
      double sum = 0;
      for (var a = 0; a < week.length; a++) {
        if (DateFormat.MMMd('en_US').format(dateTrav) ==
            DateFormat.MMMd('en_US').format(week[a].datePurchased))
          sum += week[a].itemCost;
      }
      if (sum > mostExpensive) {
        mostExpensive = sum;
      }
      expenses.add(sum);
      dateTrav = dateTrav.subtract(Duration(days: 1));
    }

    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Text(
            'Weekly Spending',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 30.0,
                onPressed: () {
                  setState(() {
                    date = date.subtract(Duration(days: 7));
                  });
                },
              ),
              Text(
                DateFormat.MMMd('en_US')
                        .format(dateTrav.add(Duration(days: 1))) +
                    ' - ' +
                    DateFormat.MMMd('en_US').format(date),
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                iconSize: 30.0,
                onPressed: () {
                  setState(() {
                    date = date.add(Duration(days: 7));
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Bar(
                label: 'Su',
                amountSpent: expenses[6],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Mo',
                amountSpent: expenses[5],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Tu',
                amountSpent: expenses[4],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'We',
                amountSpent: expenses[3],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Th',
                amountSpent: expenses[2],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Fr',
                amountSpent: expenses[1],
                mostExpensive: mostExpensive,
              ),
              Bar(
                label: 'Sa',
                amountSpent: expenses[0],
                mostExpensive: mostExpensive,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Bar extends StatelessWidget {
  final String label;
  final double amountSpent;
  final double mostExpensive;

  final double _maxBarHeight = 150.0;

  Bar({this.label, this.amountSpent, this.mostExpensive});

  @override
  Widget build(BuildContext context) {
    double barHeight;
    if (mostExpensive != 0)
      barHeight = amountSpent / mostExpensive * _maxBarHeight;
    else
      barHeight = 0;
    return Column(
      children: <Widget>[
        Text(
          '\$${amountSpent.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.0),
        _getbarHeight(barHeight, context),
        SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _getbarHeight(barHeight, context) {
    if (barHeight != 0) {
      return Container(
        height: barHeight,
        width: 18.0,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6.0),
        ),
      );
    } else
      return Container(height: 150.0);
  }
}
