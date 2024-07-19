import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShoppingList extends StatefulWidget {
  final bool isOpen;
  final bool isDark;
  final VoidCallback closeList;
  final List<Map<String, dynamic>> shoppingList;
  final Function(List<Map<String, dynamic>>) updateShoppingList;

  ShoppingList({
    required this.isOpen,
    required this.isDark,
    required this.closeList,
    required this.shoppingList,
    required this.updateShoppingList,
  });

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final TextEditingController _controller = TextEditingController();

  void addItem() {
    if (_controller.text.isEmpty) return;
    final currentList = widget.shoppingList;
    final newItem = {
      'id': 'todo-${DateTime.now().millisecondsSinceEpoch}',
      'content': _controller.text,
      'completed': false,
    };
    widget.updateShoppingList([...currentList, newItem]);
    _controller.clear();
  }

  void checkForKey(RawKeyEvent e) {
    if (e.isKeyPressed(LogicalKeyboardKey.enter)) {
      if (_controller.text.isEmpty) return;
      addItem();
    }
  }

  void deleteItem(String id) {
    final updatedList = widget.shoppingList.where((item) => item['id'] != id).toList();
    widget.updateShoppingList(updatedList);
  }

  void toggleCheck(String id) {
    final updatedList = widget.shoppingList.map((item) {
      return {
        'id': item['id'],
        'content': item['content'],
        'completed': item['id'] == id ? !item['completed'] : item['completed'],
      };
    }).toList();
    widget.updateShoppingList(updatedList);
  }

  void clearCompleted() {
    final filteredList = widget.shoppingList.where((item) => !item['completed']).toList();
    widget.updateShoppingList(filteredList);
  }

  List<Widget> renderList(List<Map<String, dynamic>> list) {
    return list.map((item) {
      return ListTile(
        leading: Checkbox(
          value: item['completed'],
          onChanged: (_) => toggleCheck(item['id']),
        ),
        title: Text(
          item['content'],
          style: TextStyle(
            decoration: item['completed'] ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => deleteItem(item['id']),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isOpen
        ? Container(
            color: widget.isDark ? Colors.black54 : Colors.white54,
            child: Center(
              child: Container(
                width: 350,
                padding: EdgeInsets.all(20),
                color: widget.isDark ? Colors.black : Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shopping List',
                          style: TextStyle(
                            fontSize: 20,
                            color: widget.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          color: widget.isDark ? Colors.white : Colors.black,
                          onPressed: widget.closeList,
                        ),
                      ],
                    ),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'What do you need to buy?',
                      ),
                      onSubmitted: (_) => addItem(),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: addItem,
                      child: Icon(Icons.add),
                    ),
                    Expanded(
                      child: ListView(
                        children: renderList(widget.shoppingList),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.shoppingList.where((item) => !item['completed']).length} item(s) left',
                          style: TextStyle(
                            color: widget.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: clearCompleted,
                          child: Text(
                            'Clear checked items',
                            style: TextStyle(
                              color: widget.isDark ? Colors.redAccent : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
