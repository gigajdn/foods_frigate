import 'package:flutter/material.dart';

class Refrigerator extends StatelessWidget {
  final String category;
  final Function(String) openEditor;
  final List<FoodItemData> foodItems;
  final Function(String) deleteItem;
  final String currentSection;
  final Function(String) sectionChange;
  final VoidCallback toggleSettings;
  final VoidCallback toggleList;

  Refrigerator({
    required this.category,
    required this.openEditor,
    required this.foodItems,
    required this.deleteItem,
    required this.currentSection,
    required this.sectionChange,
    required this.toggleSettings,
    required this.toggleList,
  });

  @override
  Widget build(BuildContext context) {
    final itemsInTheCategory = foodItems
        .where((food) => food.category == category)
        .map((item) => FoodItem(
              key: Key(item.id),
              id: item.id,
              img: item.img,
              quantity: item.quantity,
              name: item.name,
              category: item.category,
              added: item.added,
              expires: item.expires,
              deleteThis: deleteItem,
              editThis: openEditor,
            ))
        .toList()
        .reversed
        .toList();
    final totalItems = itemsInTheCategory.length;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: FridgeShell(
              child: Column(
                children: [
                  AddFood(category: category, click: openEditor),
                  Expanded(
                    child: Container(
                      child: totalItems != 0
                          ? ListView(
                              children: itemsInTheCategory,
                            )
                          : Nothingness(category: category),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SideNavBar(
            currentSection: currentSection,
            sectionChange: sectionChange,
            toggleSettings: toggleSettings,
            toggleList: toggleList,
          ),
        ],
      ),
    );
  }
}

class FoodItemData {
  final String id;
  final String img;
  final int quantity;
  final String name;
  final String category;
  final DateTime added;
  final DateTime expires;

  FoodItemData({
    required this.id,
    required this.img,
    required this.quantity,
    required this.name,
    required this.category,
    required this.added,
    required this.expires,
  });
}

class FoodItem extends StatelessWidget {
  final String id;
  final String img;
  final int quantity;
  final String name;
  final String category;
  final DateTime added;
  final DateTime expires;
  final Function(String) deleteThis;
  final Function(String) editThis;

  FoodItem({
    required Key key,
    required this.id,
    required this.img,
    required this.quantity,
    required this.name,
    required this.category,
    required this.added,
    required this.expires,
    required this.deleteThis,
    required this.editThis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(img),
      title: Text(name),
      subtitle: Text('Expires: ${expires.toString()}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => editThis(id),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => deleteThis(id),
          ),
        ],
      ),
    );
  }
}

class AddFood extends StatelessWidget {
  final String category;
  final Function(String) click;

  AddFood({
    required this.category,
    required this.click,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => click(category),
      child: Text('Add Food'),
    );
  }
}

class FridgeShell extends StatelessWidget {
  final Widget child;

  FridgeShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: child,
    );
  }
}

class Nothingness extends StatelessWidget {
  final String category;

  Nothingness({required this.category});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No items in $category'),
    );
  }
}

class SideNavBar extends StatelessWidget {
  final String currentSection;
  final Function(String) sectionChange;
  final VoidCallback toggleSettings;
  final VoidCallback toggleList;

  SideNavBar({
    required this.currentSection,
    required this.sectionChange,
    required this.toggleSettings,
    required this.toggleList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavButton(
          iconPath: 'assets/fridge_icon.png',
          label: 'Fridge',
          isActive: currentSection == 'fridge',
          onTap: () => sectionChange('fridge'),
        ),
        NavButton(
          iconPath: 'assets/freezer_icon.png',
          label: 'Freezer',
          isActive: currentSection == 'freezer',
          onTap: () => sectionChange('freezer'),
        ),
        NavButton(
          iconPath: 'assets/list_icon.png',
          label: 'Shopping List',
          onTap: toggleList,
        ),
        NavButton(
          iconPath: 'assets/settings_icon.png',
          label: 'Settings',
          onTap: toggleSettings,
        ),
      ],
    );
  }
}

class NavButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  NavButton({
    required this.iconPath,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isActive ? Colors.blue : Colors.transparent,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 34,
            ),
            SizedBox(width: 8.0),
            Text(label),
          ],
        ),
      ),
    );
  }
}
