import 'package:flutter/material.dart';
import 'package:foods_frigate/components/custom_transaction_list.dart';
import 'package:foods_frigate/models/product.dart';
import 'package:foods_frigate/models/products.dart';
import 'package:foods_frigate/models/transaction.dart';
import 'package:foods_frigate/models/transactions.dart';
import 'package:foods_frigate/components/transaction_form.dart';
import 'package:provider/provider.dart';

import '../../enums.dart';
import 'action_bar.dart';
import 'filter_tag.dart';
import 'transaction_card.dart';

class HistoryContent extends StatefulWidget {
  @override
  _HistoryContentState createState() => _HistoryContentState();
}

enum FilterState { withoutFilter, consumeFilter, additiveFilter }

class _HistoryContentState extends State<HistoryContent> {
  FilterState _currentFilter = FilterState.withoutFilter;
  int _currentTitle = 0;

  final List<String> _titles = ['', 'Apenas consumo', 'Apenas adições'];

  void _setFilter(int index) {
    setState(() {
      _currentTitle = index;
    });
  }

  void _filterByUsedTransactions() {
    setState(() {
      _currentFilter = FilterState.consumeFilter;
      _setFilter(1);
    });
  }

  void _filterByAdditiveTransactions() {
    setState(() {
      _currentFilter = FilterState.additiveFilter;
      _setFilter(2);
    });
  }

  void _clearFilters() {
    setState(() {
      _currentFilter = FilterState.withoutFilter;
      _setFilter(0);
    });
  }

  void _showTransactionDialog(BuildContext context, SubmitType type,
      String dialogTitle, Transaction transaction,
      [Product? productParent]) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return TransactionForm(
          submitType: type,
          receivedTransaction: transaction,
          productParent: productParent!,
          dialogTitle: dialogTitle,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<Transactions>(context);
    final products = Provider.of<Products>(context);

    int getDisplayedLength() {
      switch (_currentFilter) {
        case FilterState.withoutFilter:
          return transactions.orderByDate.length;
        case FilterState.consumeFilter:
          return transactions.onlyConsume.length;
        case FilterState.additiveFilter:
          return transactions.onlyAdditive.length;
        default:
          return 0;
      }
    }

    List<Transaction> getDisplayedList() {
      switch (_currentFilter) {
        case FilterState.withoutFilter:
          return transactions.orderByDate;
        case FilterState.consumeFilter:
          return transactions.onlyConsume;
        case FilterState.additiveFilter:
          return transactions.onlyAdditive;
        default:
          return [];
      }
    }

    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomTransactionList(
            isTagsDisplayed: _currentFilter == FilterState.withoutFilter,
            child: ListView.builder(
              itemCount: getDisplayedLength(),
              itemBuilder: (context, index) {
                final transaction = getDisplayedList()[index];
                final product = products.items.firstWhere(
                    (product) => product.id == transaction.productId,
                    orElse: () =>
                        Product(id: '', imgSrc: '', name: '', amount: 0));
                return TransactionCard(
                  transaction: transaction,
                  onPressed: () => _showTransactionDialog(
                    context,
                    SubmitType.update,
                    'Editar transação',
                    transaction,
                    product,
                  ),
                );
              },
            ),
          ),
          ActionBar(
            text: 'Nova transação',
            onPressed: () {}, // Add functionality here
            onPressedMinus: _filterByUsedTransactions,
            onPressedPlus: _filterByAdditiveTransactions,
          ),
          if (_currentTitle == 1 || _currentTitle == 2)
            FilterTag(
              currentTitle: _currentTitle,
              titles: _titles,
              onPressed: _clearFilters,
            )
          else
            SizedBox(width: 2),
        ],
      ),
    );
  }
}
