import 'package:flutter/material.dart';
import 'package:foods_frigate/models/product.dart';
import 'package:foods_frigate/models/products.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class CustomList extends StatefulWidget {
  CustomList({
    Key? key,
    required this.child,
  }) : super(key: key);

  Widget child;

  @override
  _CustomListState createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  bool isLoading = true;

  Future<Future<List<Product>>> _refreshProducts(BuildContext context) async {
    return Provider.of<Products>(context, listen: false).loadProducts();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Products>(context, listen: false).loadProducts().then((_) {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      height: size.height * .65,
      width: size.width,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: size.width * .05),
      decoration: backgroundDecoration(),
      child: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          backgroundColor: Theme.of(context).primaryColor,
          child: Container(
            alignment: Alignment.bottomCenter,
            height: size.height * .58,
            margin: EdgeInsets.only(top: 60),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : widget.child,
          ),
        ),
      ),
    );
  }

  BoxDecoration backgroundDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(46),
        topRight: Radius.circular(46),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          offset: Offset(0, -10),
          blurRadius: 10,
          color: AppColors.BLACK.withOpacity(.05),
        )
      ],
    );
  }
}
