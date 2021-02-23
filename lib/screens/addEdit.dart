import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/data/data.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/services/category_service.dart';

class AddEditTemp extends StatefulWidget {
  final Function populateCategories;
  static const route = 'addEdit';

  const AddEditTemp({Key key, this.populateCategories}) : super(key: key);
  @override
  AddEditTempState createState() => AddEditTempState();
}

class AddEditTempState extends State<AddEditTemp> {
  Category _category = Category();
  var amount = TextEditingController();
  var name = TextEditingController();
  var _categoryService = CategoryService();
  String mode;
  Map<String, Object> detail;
  Category catdet;

  var _loadedInitData = false;
  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.catDetails != null) {
  //     setState(() {
  //       name.text = widget.catDetails.name;
  //     });
  //   }
  // }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loadedInitData) return;

    detail = ModalRoute.of(context).settings.arguments as Map<String, Object>;
    catdet = detail['category'];
    if (detail['category'] != null) {
      name.text = detail['title'];
    }

    _loadedInitData = true;
  }

  _getHint() {
    if (detail['category'] != null) {
      return catdet.maxAmount.toString();
    } else
      return 'Amount';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(detail['title'])),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Name'),
                controller: name,
              ),
              TextField(
                decoration: InputDecoration(hintText: _getHint()),
                controller: amount,
                keyboardType: TextInputType.number,
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    if (detail['title'] == "Add Category") {
                      _category.name = name.text;
                      _category.maxAmount = double.parse(amount.text);
                      _category.spentAmount = 0;
                      var result = _categoryService.saveCategory(_category);
                      print(result);
                    } else {
                      _category.name = name.text;
                      _category.maxAmount = double.parse(amount.text);
                      _category.spentAmount = catdet.spentAmount;
                      var result = _categoryService.updateCategory(_category);
                      print(result);
                    }
                    widget.populateCategories();
                  });
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Text("add"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
