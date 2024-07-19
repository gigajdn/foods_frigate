import 'package:flutter/material.dart';

class Transaction with ChangeNotifier{
  String id;
  String productName;
  String date;
  bool isAdditive;
  int amount;

  Transaction({
    required this.id,
    required this.productName,
    required this.amount,
    required this.isAdditive,
    required this.date,
  });

  Object? get productId => null;
}

