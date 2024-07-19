import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

class Products with ChangeNotifier {
  final String _baseApiUrl = 'https://flutter-tekmob-default-rtdb.firebaseio.com';
  final String _collection = '/products';

  List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get usedRanking {
    List<Product> ranking = [..._items];
    ranking.sort((a, b) => b.totalUsed.compareTo(a.totalUsed));
    return ranking;
  }

  Future<List<Product>> loadProducts() async {
    final Uri url = Uri.parse('$_baseApiUrl$_collection.json');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(res.body) as Map<String, dynamic>;

      _items.clear();
      data.forEach((productId, productData) {
        _items.add(Product(
          id: productId,
          name: productData['name'],
          amount: productData['amount'],
          imgSrc: productData['imgSrc'],
          totalUsed: productData['totalUsed'],
        ));
      });
      notifyListeners();
    } else {
      throw Exception('Failed to load products');
    }

    return _items;
  }

  Future<void> saveProduct(Product newProduct) async {
    final alreadyExists = _items.indexWhere((prod) => prod.name == newProduct.name);

    if (alreadyExists >= 0) {
      throw Exception('Hold on... there`s already a product registered with that name');
    } else {
      final Uri url = Uri.parse('$_baseApiUrl$_collection.json');
      final body = json.encode({
        'name': newProduct.name,
        'amount': newProduct.amount,
        'imgSrc': newProduct.imgSrc,
        'totalUsed': newProduct.totalUsed,
      });

      final res = await http.post(url, body: body);

      if (res.statusCode == 200) {
        _items.add(Product(
          id: json.decode(res.body)['name'],
          name: newProduct.name,
          amount: newProduct.amount,
          imgSrc: newProduct.imgSrc,
          totalUsed: newProduct.totalUsed,
        ));
        notifyListeners();
      } else {
        throw Exception('Failed to save product');
      }
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final alreadyExists = _items.indexWhere((prod) => prod.id == id);

    if (alreadyExists >= 0) {
      final Uri url = Uri.parse('$_baseApiUrl$_collection/$id.json');
      final body = json.encode({
        'name': newProduct.name,
        'amount': newProduct.amount,
        'imgSrc': newProduct.imgSrc,
        'totalUsed': newProduct.totalUsed,
      });

      final res = await http.patch(url, body: body);

      if (res.statusCode == 200) {
        _items[alreadyExists] = newProduct;
        notifyListeners();
      } else {
        throw Exception('Failed to update product');
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final alreadyExists = _items.indexWhere((prod) => prod.id == id);

    if (alreadyExists >= 0) {
      final product = _items[alreadyExists];
      _items.remove(product);
      notifyListeners();

      final Uri url = Uri.parse('$_baseApiUrl$_collection/${product.id}.json');
      final res = await http.delete(url);

      if (res.statusCode >= 400) {
        _items.insert(alreadyExists, product);
        notifyListeners();
        throw Exception('Failed to delete product');
      }
    }
  }
}
