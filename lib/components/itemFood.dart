import 'package:flutter/material.dart';

class FoodItem extends StatefulWidget {
  final String id;
  final String img;
  final String name;
  final String quantity;
  final String added;
  final String expires;
  final Function editThis;
  final Function deleteThis;

  FoodItem({
    required this.id,
    required this.img,
    required this.name,
    required this.quantity,
    required this.added,
    required this.expires,
    required this.editThis,
    required this.deleteThis,
  });

  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  bool deleteModal = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildCardFront(),
          _buildCardBack(),
        ],
      ),
    );
  }

  Widget _buildCardFront() {
    return ListTile(
      leading: widget.img.isNotEmpty
          ? Image.network(widget.img, width: 50, height: 50, fit: BoxFit.cover)
          : Icon(Icons.fastfood),
      title: Text(widget.name),
      subtitle: Text('Quantity: ${widget.quantity}'),
    );
  }

  Widget _buildCardBack() {
    return Column(
      children: [
        Text('Added: ${widget.added}'),
        Text('Expires: ${widget.expires}'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => widget.editThis(widget),
              child: Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                deleteModal = !deleteModal;
              }),
              child: Text('Delete'),
            ),
          ],
        ),
        if (deleteModal) _buildDeleteConfirmModal(),
      ],
    );
  }

  Widget _buildDeleteConfirmModal() {
    return AlertDialog(
      title: Text('Delete this item?'),
      content: Text(widget.name),
      actions: [
        TextButton(
          onPressed: () => widget.deleteThis(widget.id),
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () => setState(() {
            deleteModal = !deleteModal;
          }),
          child: Text('No'),
        ),
      ],
    );
  }
}
