import 'package:flutter/material.dart';
import 'package:foods_frigate/components/date_picker.dart';
import 'package:foods_frigate/components/error_dialog.dart';
import 'package:foods_frigate/components/text_input.dart';
import 'package:foods_frigate/models/product.dart';
import 'package:foods_frigate/models/transaction.dart';
import 'package:foods_frigate/models/transactions.dart';
import 'package:foods_frigate/screens/history/filter_button.dart';
import 'package:provider/provider.dart';

import '../enums.dart';
import '../themes.dart';
import '../validations.dart';

class TransactionForm extends StatefulWidget {
  final SubmitType submitType;
  final Transaction receivedTransaction;
  final Product productParent;
  final String dialogTitle;

  TransactionForm({
    required this.submitType,
    required this.dialogTitle,
    required this.receivedTransaction,
    required this.productParent,
  });

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  late TextEditingController _productNameCtrl;
  late TextEditingController _amountCtrl;

  DateTime _date = DateTime.now();
  late bool _isAdditive;

  final _addTransactionForm = GlobalKey<FormState>();
  final Map<String, dynamic> __transactionFormData = {};

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return Theme.of(context).colorScheme.error.withOpacity(.1);
    }

    return Colors.transparent;
  }

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final productParent = widget.productParent;
    final transaction = widget.receivedTransaction;

    _isAdditive = widget.receivedTransaction.isAdditive;

    // to add transaction modal (receive a product)
    if (__transactionFormData.isEmpty || widget.submitType == SubmitType.save) {
      _productNameCtrl = TextEditingController(text: productParent.name);
      _amountCtrl =
          TextEditingController(text: productParent.amount.toString());

      __transactionFormData['productName'] = productParent.name;
      __transactionFormData['amount'] = productParent.amount;
      __transactionFormData['date'] = _date.toIso8601String();
      __transactionFormData['isAdditive'] = _isAdditive;
    }

    // to update transaction modal (receive a transaction)
    if (__transactionFormData.isEmpty ||
        widget.submitType == SubmitType.update) {
      __transactionFormData['id'] = transaction.id;
      __transactionFormData['productName'] = transaction.productName;
      __transactionFormData['amount'] = transaction.amount;
      __transactionFormData['isAdditive'] = transaction.isAdditive;
      __transactionFormData['date'] = transaction.date;

      _productNameCtrl = TextEditingController(text: transaction.productName);
      _amountCtrl = TextEditingController(text: transaction.amount.toString());
    }
  }

  void _setTransactionType(bool value) {
    setState(() {
      _isAdditive = value;
      __transactionFormData['isAdditive'] = _isAdditive;
    });
  }

  Future<void> _submitForm() async {
    final transactions = Provider.of<Transactions>(context, listen: false);

    if (!_addTransactionForm.currentState!.validate()) {
      return;
    }
    _addTransactionForm.currentState?.save();

    final newTransaction = Transaction(
      id: __transactionFormData['id'] as String,
      productName: __transactionFormData['productName'] as String,
      amount: __transactionFormData['amount'] as int,
      date: __transactionFormData['date'] as String,
      isAdditive: __transactionFormData['isAdditive'] as bool,
    );

    setState(() => _isLoading = true);

    try {
      if (widget.submitType == SubmitType.save && newTransaction.id == null) {
        await transactions.saveTransaction(newTransaction);
      } else {
        await transactions.updateTransaction(
          newTransaction.id,
          newTransaction,
        );
      }

      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => ErrorDialog(
          context: context,
          message: error.toString(),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: AlertDialog(
              title: Text(widget.dialogTitle),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.resolveWith(getColor),
                  ),
                  child: Text(
                    'Cancel',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
                TextButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
              content: SingleChildScrollView(
                child: Form(
                  key: _addTransactionForm,
                  child: Column(
                    children: <Widget>[
                      TextInput(
                        label: "Name A Item",
                        ctrl: _productNameCtrl,
                        onSaved: (value) =>
                            __transactionFormData['productName'] = value!,
                        onValidation: Validation.nameValidation,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      TextInput(
                        label: "Quantity",
                        ctrl: _amountCtrl,
                        onSaved: (value) =>
                            __transactionFormData['amount'] = int.parse(value!),
                        onValidation: Validation.amountValidation,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isAdditive ? 'Addition' : '',
                            style: TextStyle(color: AppColors.GRAY_n135),
                          ),
                          SizedBox(width: 18),
                          Row(
                            children: <Widget>[
                              FilterButton(
                                icon: 'assets/icons/additive.svg',
                                onPressed: () => _setTransactionType(true),
                                iconColor: _isAdditive
                                    ? Theme.of(context).primaryColor
                                    : AppColors.GRAY_n135,
                                bgColor: _isAdditive
                                    ? Theme.of(context).colorScheme.secondary
                                    : AppColors.GRAY_n236,
                              ),
                              SizedBox(width: 18),
                              FilterButton(
                                icon: 'assets/icons/consume.svg',
                                onPressed: () => _setTransactionType(false),
                                iconColor: _isAdditive
                                    ? AppColors.GRAY_n135
                                    : Theme.of(context).colorScheme.error,
                                bgColor: _isAdditive
                                    ? AppColors.GRAY_n236
                                    : AppColors.RED_n254,
                              ),
                            ],
                          ),
                          SizedBox(width: 18),
                          Text(
                            _isAdditive ? '' : 'Consumption',
                            style: TextStyle(color: AppColors.GRAY_n135),
                          ),
                        ],
                      ),
                      DatePicker(
                        selectedDate: DateTime.parse(
                            __transactionFormData['date'] as String),
                        onDateChange: (value) => __transactionFormData['date'] =
                            value.toIso8601String(),
                      ),
                      SizedBox(height: 16),
                      if (widget.submitType != SubmitType.save)
                        Material(
                          color: AppColors.RED_n230.withOpacity(.1),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Delete product'),
                                  content: Text(
                                      'Are you sure you want to delete this transaction?'),
                                  actions: [
                                    TextButton(
                                      child: Text('No'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: Text('Yes'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    )
                                  ],
                                ),
                              ).then((value) {
                                if (value == true) {
                                  try {
                                    Provider.of<Transactions>(context,
                                            listen: false)
                                        .deleteTransaction(
                                            widget.receivedTransaction.id);
                                    Navigator.of(context).pop();
                                  } catch (error) {
                                    print(error.toString());
                                  }
                                }
                              });
                            },
                            highlightColor: AppColors.RED_n230.withOpacity(.1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.delete, color: AppColors.RED_n230),
                                  SizedBox(width: 12),
                                  Text(
                                    'Delete transaction',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.RED_n230),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
