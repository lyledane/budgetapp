// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class AddEdit extends StatelessWidget {
//   static const route = 'addEdit';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Expense"),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_rounded),
//           onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
//         ),
//       ),
//     );
//   }
// }

// class AddPage extends StatefulWidget {
// //  final Function addHandler;

// //  AddPage(this.addHandler);
//   @override
//   _AddPageState createState() => _AddPageState();
// }

// class _AddPageState extends State<AddPage> {
//   final categoryController = TextEditingController();
//   final amountController = TextEditingController();
//   final nameController = TextEditingController();
//   DateTime _selectedDate;

//   void _presentDatePicker() {
//     showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(2019),
//             lastDate: DateTime.now())
//         .then((pickedDate) {
//       if (pickedDate == null) {
//         return;
//       }
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     });
//   }

//   void submitData() {
//     if (amountController.text.isEmpty) {
//       return;
//     }
//     final enteredCategory = categoryController.text;
//     final enteredName = nameController.text;
//     final enteredAmount = double.parse(amountController.text);

//     if (enteredCategory.length == 0 ||
//         enteredName.length == 0 ||
//         enteredAmount < 0 ||
//         _selectedDate == null) {
//       return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           Row(
//             children: [
//               Text('Amount', style: TextStyle(color: Colors.grey[600]))
//             ],
//           ),
//           Container(
//             alignment: Alignment.topRight,
//             height: 100,
//             child: TextField(
//               controller: amountController,
//               keyboardType: TextInputType.number,
//               style: TextStyle(
//                 fontSize: 20,
//               ),
//               decoration: InputDecoration(
//                 labelText: 'Enter Amount',
//                 border: InputBorder.none,
//               ),
//             ),
//           ),

//           Row(
//             children: [
//               Text('Settings', style: TextStyle(color: Colors.grey[600]))
//             ],
//           ),
//           SizedBox(
//             height: 20,
//             child: DecoratedBox(
//               decoration: BoxDecoration(color: Colors.orange),
//             ),
//           ),
//           TextField(
//             decoration: InputDecoration(labelText: 'Category'),
//             controller: categoryController,
//           ),
//           TextField(
//             decoration: InputDecoration(labelText: 'Item'),
//             controller: nameController,
//           ),
//           //this area is for the chosen date
//           Container(
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Text(
//                     _selectedDate == null
//                         ? 'No Date Chosen'
//                         : DateFormat.yMd().format(_selectedDate),
//                   ),
//                 ),
//                 FlatButton(
//                   onPressed: _presentDatePicker,
//                   child: Text('Choose Date'),
//                   textColor: Colors.teal[800],
//                 ),
//               ],
//             ),
//           ),
//           //for add button function
//           FlatButton(
//               child: Text('Add Item'),
//               textColor: Colors.teal[800],
//               onPressed: () => submitData()),

//           //for delete button function
//           FlatButton(
//               child: Text('Delete'),
//               textColor: Colors.teal[800],
//               onPressed: () => submitData()),
//         ],
//       ),
//     );
//   }
// }
