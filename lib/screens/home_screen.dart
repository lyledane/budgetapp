import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/data/dummy_data_expenses.dart';
import 'package:flutter_budget_ui/helpers/color_helper.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/screens/addEdit.dart';
import 'package:flutter_budget_ui/screens/category_screen.dart';
import 'package:flutter_budget_ui/services/category_service.dart';
import 'package:flutter_budget_ui/widgets/bar_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _categoryService = CategoryService();
  List<Category> _categoryList = List<Category>();
  @override
  void initState() {
    getAllCategories();
    super.initState();
  }

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.getCategory();
    categories.forEach((category) {
      print(category);
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

  List<Expense> _catItems(catId) {
    List<Expense> items = [];
    dummyDataExpense.forEach((Expense expense) {
      if (expense.catId == catId) {
        items.add(expense);
      }
    });
    return items;
  }

  _buildCategory(Category category) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryScreen(
            catItems: _catItems(category.catId),
            catDetails: category,
          ),
        ),
      ),
      onLongPress: () {
        return showDialog(
            context: context,
            barrierDismissible: true,
            builder: (param) {
              return AlertDialog(
                title: Text('Delete ${category.name}?'),
                actions: [
                  RaisedButton(child: Text('No'), onPressed: () => Navigator.pop(context)),
                  RaisedButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      var resulti = await _categoryService.deleteCategory(category.catId);
                      if (resulti > 0) {
                        Navigator.pop(context);
                        getAllCategories();
                        showDialog(
                            context: context,
                            builder: (param) {
                              return AlertDialog(title: Text('Updated!'));
                            });
                      }
                    },
                  )
                ],
              );
            });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: EdgeInsets.all(20.0),
        height: 100.0,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 20,
                  child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // _editCategory(context, _categoryList[index].id);
                      }),
                ),
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${(category.maxAmount - category.spentAmount).toStringAsFixed(2)} / \$${category.maxAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double maxBarWidth = constraints.maxWidth;
                final double percent = (category.maxAmount - category.spentAmount) / category.maxAmount;
                double barWidth = percent * maxBarWidth;

                if (barWidth < 0) {
                  barWidth = 0;
                }
                return Stack(
                  children: <Widget>[
                    Container(
                      height: 10.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    Container(
                      height: 10.0,
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: getColor(context, percent),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            forceElevated: true,
            floating: true,
            // pinned: true,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Budget App'),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 30.0,
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditTemp(mode: "Add Category")));
                    getAllCategories();
                  }),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: BarChart(),
                  );
                } else if (index == 1) {
                  return Text(
                    'Long Press to Delete a Category',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[400], fontSize: 10),
                  );
                } else if (_categoryList.length != 0) {
                  final Category category = _categoryList[index - 2];
                  return _buildCategory(category);
                } else {
                  return Container();
                }
              },
              childCount: 2 + _categoryList.length,
            ),
          ),
        ],
      ),
    );
  }
}
