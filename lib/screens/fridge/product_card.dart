import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foods_frigate/models/product.dart';
import '../../themes.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.onPressed,
    required this.onButtonPressed,
    required this.product,
  }) : super(key: key);

  final GestureTapCallback onPressed;
  final GestureTapCallback onButtonPressed;
  final Product product;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        margin: EdgeInsets.only(bottom: 12, left: 20, right: 20),
        decoration: cardDecoration(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildProductImage(context, product.imgSrc),
            SizedBox(width: size.width * .05),
            buildProductInfo(product.name, product.amount),
            Spacer(),
            buildTransactionButton(context, onButtonPressed),
          ],
        ),
      ),
    );
  }

  BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(
        width: 2,
        color: Theme.of(context).primaryColor.withOpacity(.1),
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 10),
          blurRadius: 20,
          color: AppColors.GRAY_n141.withOpacity(.2),
        ),
      ],
    );
  }

  Container buildProductImage(BuildContext context, String image) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .15,
      height: size.width * .15,
      child: Image.network(image),
    );
  }

  Column buildProductInfo(String name, int amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text('$amount units'),
      ],
    );
  }

  InkWell buildTransactionButton(
      BuildContext context, GestureTapCallback onButtonPressed) {
    return InkWell(
      onTap: onButtonPressed,
      borderRadius: BorderRadius.circular(16),
      highlightColor: Theme.of(context).primaryColor.withOpacity(.2),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor == AppColors.YELLOW_n119
              ? Theme.of(context).colorScheme.secondary.withOpacity(.7)
              : Theme.of(context).colorScheme.primary.withOpacity(.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset(
          'assets/icons/exchange.svg',
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
