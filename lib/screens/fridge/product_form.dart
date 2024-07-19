import 'package:flutter/material.dart';
import 'package:foods_frigate/components/error_dialog.dart';
import 'package:foods_frigate/components/image_preview.dart';
import 'package:foods_frigate/components/text_input.dart';
import 'package:foods_frigate/models/product.dart';
import 'package:foods_frigate/models/products.dart';
import 'package:foods_frigate/themes.dart';
import 'package:provider/provider.dart';

import '../../enums.dart';
import '../../validations.dart';

class ProductForm extends StatefulWidget {
  final SubmitType submitType;
  final Product receivedProduct;
  final String dialogTitle;

  const ProductForm({
    required this.submitType,
    required this.receivedProduct,
    required this.dialogTitle,
    Key? key,
  }) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  late TextEditingController _nameCtrl;
  late TextEditingController _amountCtrl;
  late TextEditingController _imgSrcController;

  final _imgSrcFocusNode = FocusNode();

  final _productForm = GlobalKey<FormState>();
  final Map<String, dynamic> _productFormData = {};

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
    _imgSrcFocusNode.addListener(upgradeImageUrl);

    final product = widget.receivedProduct;
    _nameCtrl = TextEditingController(text: product.name);
    _amountCtrl = TextEditingController(text: product.amount.toString());
    _imgSrcController = TextEditingController(text: product.imgSrc);

    _productFormData['id'] = product.id;
    _productFormData['name'] = product.name;
    _productFormData['amount'] = product.amount;
    _productFormData['imgSrc'] = product.imgSrc;
  }

  @override
  void dispose() {
    _imgSrcFocusNode.removeListener(upgradeImageUrl);
    _imgSrcFocusNode.dispose();
    super.dispose();
  }

  void upgradeImageUrl() {
    if (Validation.isValidImageUrl(_imgSrcController.text)) {
      setState(() {});
    }
  }

  Future<void> _submitForm() async {
    final products = Provider.of<Products>(context, listen: false);

    if (!_productForm.currentState!.validate()) {
      return;
    }
    _productForm.currentState!.save();

    final newProduct = Product(
      id: _productFormData['id'] as String,
      name: _productFormData['name'] as String,
      amount: _productFormData['amount'] as int,
      imgSrc: _productFormData['imgSrc'] as String,
    );

    setState(() => _isLoading = true);

    try {
      if (widget.submitType == SubmitType.save) {
        await products.saveProduct(newProduct);
      } else {
        await products.updateProduct(
            _productFormData['id'] as String, newProduct);
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
                    'Cancelar',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
                TextButton(
                  onPressed: _submitForm,
                  child: Text('Confirmar'),
                ),
              ],
              content: SingleChildScrollView(
                child: Form(
                  key: _productForm,
                  child: Column(
                    children: <Widget>[
                      ImagePreview(imgSrcController: _imgSrcController),
                      SizedBox(height: 16),
                      TextInput(
                        label: "Nome do Item",
                        ctrl: _nameCtrl,
                        onSaved: (value) => _productFormData['name'] = value!,
                        onValidation: Validation.nameValidation,
                        focusNode: _imgSrcFocusNode,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      TextInput(
                        label: "Quantidade (Und)",
                        ctrl: _amountCtrl,
                        onSaved: (value) =>
                            _productFormData['amount'] = int.parse(value!),
                        onValidation: Validation.amountValidation,
                        keyboardType: TextInputType.number,
                        focusNode: _imgSrcFocusNode,
                      ),
                      SizedBox(height: 16),
                      TextInput(
                        label: "Url da imagem",
                        ctrl: _imgSrcController,
                        focusNode: _imgSrcFocusNode,
                        onSaved: (value) => _productFormData['imgSrc'] = value!,
                        onValidation: Validation.imgSrcValidation,
                        keyboardType: TextInputType.number,
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
                                  title: Text('Excluir produto'),
                                  content: Text(
                                      'Tem certeza que quer excluir este produto?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Não'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: Text('Sim'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    )
                                  ],
                                ),
                              ).then((value) {
                                if (value == true) {
                                  try {
                                    Provider.of<Products>(context,
                                            listen: false)
                                        .deleteProduct(
                                            widget.receivedProduct.id);
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
                                    'Excluir produto',
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
