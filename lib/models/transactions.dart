import 'package:flutter/material.dart';
import 'package:foods_frigate/models/product.dart';
import 'package:foods_frigate/models/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'transaction.dart';

class Transactions with ChangeNotifier {
  final String _baseApiUrl =
      'https://flutter-fridge-default-rtdb.firebaseio.com';
  final String _collection = '/transactions';

  final List<Transaction> _items = [];
  Products products = Products();
  late int newProductAmount;
  late int newTransactionAmount;

  List<Transaction> get items => [..._items];

  List<Transaction> get onlyConsume {
    List<Transaction> filteredList = [..._items];
    filteredList.retainWhere((prod) => !prod.isAdditive);
    filteredList.sort((a, b) => b.date.compareTo(a.date));

    notifyListeners();
    return filteredList;
  }

  List<Transaction> get onlyAdditive {
    List<Transaction> filteredList = [..._items];
    filteredList.retainWhere((prod) => prod.isAdditive);
    filteredList.sort((a, b) => b.date.compareTo(a.date));

    notifyListeners();
    return filteredList;
  }

  List<Transaction> get orderByDate {
    List<Transaction> filteredList = [..._items];
    filteredList.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
    return filteredList;
  }

  Future<List<Transaction>> loadTransactions() async {
    final res = await http.get(Uri.parse('$_baseApiUrl$_collection.json'));
    final Map<String, dynamic> data = json.decode(res.body);

    _items.clear();
    data.forEach((productId, productData) {
      _items.add(Transaction(
        id: productId,
        productName: productData['productName'],
        amount: productData['amount'],
        date: productData['date'],
        isAdditive: productData['isAdditive'],
      ));
    });

    notifyListeners();

    return Future.value(_items);
  }

  Future<List<Transaction>> saveTransaction(Transaction newTransaction) async {
    await products.loadProducts();

    await updateProductAmount(newTransaction);

    var body = json.encode({
      'productName': newTransaction.productName,
      'amount': newTransactionAmount,
      'date': newTransaction.date,
      'isAdditive': newTransaction.isAdditive,
    });

    final res =
        await http.post(Uri.parse('$_baseApiUrl$_collection.json'), body: body);

    _items.add(Transaction(
      id: json.decode(res.body)['name'],
      productName: newTransaction.productName,
      amount: newTransaction.amount,
      date: newTransaction.date,
      isAdditive: newTransaction.isAdditive,
    ));

    await products.loadProducts();
    notifyListeners();

    return Future.value(_items);
  }

  Future<void> updateTransaction(String id, Transaction newTransaction) async {
    await products.loadProducts();

    await updateProductAmount(newTransaction);

    var alreadyExists =
        _items.indexWhere((transaction) => transaction.id == id);

    var body = json.encode({
      'productName': newTransaction.productName,
      'amount': newTransactionAmount,
      'date': newTransaction.date,
      'isAdditive': newTransaction.isAdditive,
    });

    if (alreadyExists >= 0) {
      await http.patch(Uri.parse('$_baseApiUrl/$_collection/$id.json'),
          body: body);
      await products.loadProducts();
      _items[alreadyExists] = newTransaction;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    final alreadyExists =
        _items.indexWhere((transaction) => transaction.id == id);

    if (alreadyExists >= 0) {
      final transaction = _items[alreadyExists];
      _items.remove(transaction);
      notifyListeners();

      final res = await http
          .delete(Uri.parse('$_baseApiUrl$_collection/${transaction.id}.json'));

      await loadTransactions();
      await recoverProductAmount(transaction);
      notifyListeners();

      if (res.statusCode >= 400) {
        _items.insert(alreadyExists, transaction);
        notifyListeners();
      }
    }
  }

  Future<int> recoverProductAmount(Transaction newTransaction) async {
    await products.loadProducts();

    newTransactionAmount = newTransaction.amount;
    Product? parentProduct;
    int oldProductAmount = 0;

    int getProductIndex = products.items
        .indexWhere((prod) => prod.name == newTransaction.productName);

    if (getProductIndex >= 0) {
      parentProduct = products.items[getProductIndex];
      oldProductAmount = parentProduct.amount;
      newProductAmount = parentProduct.amount;
    }

    if (newTransaction.isAdditive) {
      newProductAmount -= newTransaction.amount;
    } else if (newTransaction.amount <= oldProductAmount) {
      newProductAmount += newTransaction.amount;
      parentProduct?.totalUsed -= newTransactionAmount;
    } else {
      newTransaction.amount = oldProductAmount;
      newTransactionAmount = oldProductAmount;
      newProductAmount = oldProductAmount + newTransaction.amount;
      parentProduct?.totalUsed -= newTransactionAmount;
    }

    var body = json.encode({
      'name': parentProduct?.name,
      'amount': newProductAmount,
      'imgSrc': parentProduct?.imgSrc,
      'totalUsed': parentProduct?.totalUsed,
    });

    if (getProductIndex >= 0 && parentProduct != null) {
      await http.patch(
          Uri.parse('$_baseApiUrl/products/${parentProduct.id}.json'),
          body: body);
      await products.loadProducts();
      products.items[getProductIndex] = parentProduct;
      notifyListeners();
    }

    return Future.value(newProductAmount);
  }

  Future<int> updateProductAmount(Transaction newTransaction) async {
    await products.loadProducts();

    newTransactionAmount = newTransaction.amount;
    Product? parentProduct;
    int oldProductAmount = 0;

    int getProductIndex = products.items
        .indexWhere((prod) => prod.name == newTransaction.productName);

    if (getProductIndex >= 0) {
      parentProduct = products.items[getProductIndex];
      oldProductAmount = parentProduct.amount;
      newProductAmount = parentProduct.amount;
    }

    if (newTransaction.isAdditive) {
      newProductAmount += newTransaction.amount;
    } else if (newTransaction.amount <= oldProductAmount) {
      newProductAmount -= newTransaction.amount;
      parentProduct?.totalUsed += newTransactionAmount;
    } else {
      newTransaction.amount = oldProductAmount;
      newTransactionAmount = oldProductAmount;
      newProductAmount = oldProductAmount - newTransaction.amount;
      parentProduct?.totalUsed += newTransactionAmount;
    }

    var body = json.encode({
      'name': parentProduct?.name,
      'amount': newProductAmount,
      'imgSrc': parentProduct?.imgSrc,
      'totalUsed': parentProduct?.totalUsed,
    });

    if (getProductIndex >= 0 && parentProduct != null) {
      await http.patch(
          Uri.parse('$_baseApiUrl/products/${parentProduct.id}.json'),
          body: body);
      await products.loadProducts();
      products.items[getProductIndex] = parentProduct;
      notifyListeners();
    }

    return Future.value(newProductAmount);
  }
}
