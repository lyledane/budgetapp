import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/services/category_service.dart';

class AddEditTemp extends StatefulWidget {
  final String mode;
  final Category catDetails;

  const AddEditTemp({Key key, this.mode, this.catDetails}) : super(key: key);
  @override
  AddEditTempState createState() => AddEditTempState();
}

class AddEditTempState extends State<AddEditTemp> {
  Category _category = Category();
  var amount = TextEditingController();
  var name = TextEditingController();
  var _categoryService = CategoryService();
  @override
  void initState() {
    super.initState();
    if (widget.catDetails != null) {
      setState(() {
        name.text = widget.catDetails.name;
      });
    }
  }

  _getHint() {
    if (widget.catDetails != null) {
      return 'Amount';
    } else
      return widget.catDetails.maxAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.mode)),
      body: Material(
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'name'),
              controller: name,
            ),
            TextField(
              decoration: _getHint(),
              controller: amount,
              keyboardType: TextInputType.number,
            ),
            RaisedButton(
              onPressed: () async {
                if (widget.mode == "Add Category") {
                  _category.name = name.text;
                  _category.maxAmount = double.parse(amount.text);
                  _category.spentAmount = 0;
                  var result = _categoryService.saveCategory(_category);
                  print(result);
                  Navigator.of(context).pushReplacementNamed('/');
                } else {
                  _category.name = name.text;
                  _category.maxAmount = double.parse(amount.text);
                  _category.spentAmount = 0;
                  var result = _categoryService.updateCategory(_category);
                  print(result);
                  Navigator.of(context).pushReplacementNamed('/');
                }
              },
              child: Text("add"),
            )
          ],
        ),
      ),
    );
  }
}
