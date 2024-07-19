import 'package:flutter/material.dart';
import 'package:foods_frigate/models/product.dart';
import 'package:foods_frigate/models/transaction.dart';
import 'package:foods_frigate/screens/fridge/action_button.dart';
import 'package:foods_frigate/components/custom_list.dart';
import 'package:foods_frigate/models/products.dart';
import 'package:provider/provider.dart';

import '../../enums.dart';
import 'product_card.dart';
import 'product_form.dart';
import '../../components/transaction_form.dart';

class FridgeContent extends StatefulWidget {
  @override
  _FridgeContentState createState() => _FridgeContentState();
}

class _FridgeContentState extends State<FridgeContent> {
  void _showProductDialog(
      BuildContext context, SubmitType type, String dialogTitle,
      [Product? receivedProduct]) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return ProductForm(
            submitType: type,
            receivedProduct: receivedProduct ??
                Product(id: '', name: '', amount: 0, imgSrc: ''),
            dialogTitle: dialogTitle,
          );
        });
  }

  void _showTransactionDialog(BuildContext context, SubmitType type,
      String dialogTitle, Product productParent) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return TransactionForm(
            submitType: type,
            receivedTransaction: Transaction(
                id: '',
                productName: productParent.name,
                amount: 0,
                date: '',
                isAdditive: false),
            productParent: productParent,
            dialogTitle: dialogTitle,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomList(
            child: ListView.builder(
              itemCount: products.items.length,
              itemBuilder: (context, index) => ProductCard(
                product: products.items[index],
                onPressed: () => _showProductDialog(
                  context,
                  SubmitType.update,
                  'edit item',
                  products.items[index],
                ),
                onButtonPressed: () => _showTransactionDialog(
                  context,
                  SubmitType.save,
                  'Add transaction',
                  products.items[index],
                ),
              ),
            ),
          ),
          ActionButton(
            text: 'Add item',
            onPressed: () =>
                _showProductDialog(context, SubmitType.save, 'Add Item'),
          ),
        ],
      ),
    );
  }
}
