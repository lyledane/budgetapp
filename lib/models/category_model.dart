import 'package:flutter/material.dart';

class Category {
  int catId;
  String name;
  double maxAmount;
  double spentAmount;

  categoryMap() {
    var mapping = Map<String, dynamic>();
    mapping['catId'] = catId;
    mapping['catName'] = name;
    mapping['maxAmount'] = maxAmount;
    mapping['spentAmount'] = spentAmount;

    return mapping;
  }
}
