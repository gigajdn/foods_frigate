import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/addFood.dart';
import 'components/editFood.dart';
import 'components/header.dart';
import 'components/itemFood.dart';
import 'components/modalButton.dart';
import 'components/navbar.dart';
import 'components/refrigerator.dart';
import 'components/settingModal.dart';
import 'components/shoppingList.dart';
import 'components/user.dart';

void main() => runApp(RememberFridgeApp());

class RememberFridgeApp extends StatefulWidget {
  @override
  _RememberFridgeAppState createState() => _RememberFridgeAppState();
}

class _RememberFridgeAppState extends State<RememberFridgeApp> {
  final blankItemState = {
    "img": "",
    "quantity": "",
    "name": "",
    "added": "",
    "expires": "",
    "category": "fridge"
  };

  Map<String, dynamic> state = {
    "activeArea": "fridge",
    "editorLaunchIn": "fridge",
    "darkMode": false,
    "editorIsOpen": false,
    "settingsIsOpen": false,
    "listIsOpen": false,
    "currentItem": {},
    "foodItems": [],
    "shoppingList": [],
    "editorMode": "add"
  };

  @override
  void initState() {
    super.initState();
    state["currentItem"] = blankItemState;
    _loadLocalStorage();
  }

  _loadLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      state["foodItems"] = jsonDecode(prefs.getString("myFridgeItems") ?? '[]');
      state["darkMode"] = jsonDecode(prefs.getString("myFridgeDarkMode") ?? 'false');
      state["shoppingList"] = jsonDecode(prefs.getString("myFridgeShoppingList") ?? '[]');
    });
  }

  _setLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("myFridgeItems", jsonEncode(state["foodItems"]));
    prefs.setString("myFridgeDarkMode", jsonEncode(state["darkMode"]));
    prefs.setString("myFridgeShoppingList", jsonEncode(state["shoppingList"]));
  }

  void _handleNavigation(String targetArea) {
    setState(() {
      state["activeArea"] = targetArea;
      state["editorLaunchIn"] = targetArea;
    });
  }

  void _openEditor(Map<String, dynamic> item) {
    setState(() {
      state["editorIsOpen"] = true;
      state["editorLaunchIn"] = state["activeArea"];
      state["currentItem"] = item.isNotEmpty ? item : blankItemState;
      state["editorMode"] = item.isNotEmpty ? "edit" : "add";
    });
  }

  void _closeEditor(String closingAs) {
    setState(() {
      state["editorIsOpen"] = false;
      state["currentItem"] = blankItemState;
      state["activeArea"] = closingAs;
    });
  }

  void _addItem() {
    setState(() {
      state["foodItems"].add({
        ...state["currentItem"],
        "category": state["activeArea"],
        "id": DateTime.now().toString()
      });
      state["editorIsOpen"] = false;
      state["currentItem"] = blankItemState;
      _setLocalStorage();
    });
  }

  void _deleteItem(String itemId) {
    setState(() {
      state["foodItems"].removeWhere((item) => item["id"] == itemId);
      _setLocalStorage();
    });
  }

  void _updateShoppingList(List<Map<String, dynamic>> newList) {
    setState(() {
      state["shoppingList"] = newList;
      _setLocalStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: state["darkMode"] ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Remember Fridge"),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                setState(() {
                  state["settingsIsOpen"] = !state["settingsIsOpen"];
                });
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            _buildBody(),
            if (state["settingsIsOpen"]) _buildSettingsModal(),
            if (state["editorIsOpen"]) _buildEditor(),
            if (state["listIsOpen"]) _buildShoppingList(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBody() {
    return Refrigerator(
      category: state["activeArea"],
      openEditor: _openEditor,
      foodItems: state["foodItems"],
      deleteItem: _deleteItem,
      currentSection: state["activeArea"],
      sectionChange: _handleNavigation,
      toggleSettings: () {
        setState(() {
          state["settingsIsOpen"] = !state["settingsIsOpen"];
        });
      },
      toggleList: () {
        setState(() {
          state["listIsOpen"] = !state["listIsOpen"];
        });
      },
    );
  }

  Widget _buildBottomNavBar() {
    return navbar(
      currentSection: state["activeArea"],
      sectionChange: _handleNavigation,
      toggleSettings: () {
        setState(() {
          state["settingsIsOpen"] = !state["settingsIsOpen"];
        });
      },
      toggleList: () {
        setState(() {
          state["listIsOpen"] = !state["listIsOpen"];
        });
      },
    );
  }

  Widget _buildSettingsModal() {
    return SettingsModal(
      isOpen: state["settingsIsOpen"],
      closeModal: () {
        setState(() {
          state["settingsIsOpen"] = false;
        });
      },
      darkMode: state["darkMode"],
      changeColor: (bool? value) {
        setState(() {
          state["darkMode"] = value!;
          _setLocalStorage();
        });
      },
      loadSamples: () {
        // Add your load sample data logic here
      },
      deleteAll: () {
        setState(() {
          state["foodItems"] = [];
          state["shoppingList"] = [];
          _setLocalStorage();
        });
      },
    );
  }

  Widget _buildEditor() {
    return EditFood(
      isOpen: state["editorIsOpen"],
      closeEditor: _closeEditor,
      currentItem: state["currentItem"],
      addItem: _addItem,
      updateItem: (Map<String, dynamic> updatedItem) {
        setState(() {
          int index = state["foodItems"].indexWhere((item) => item["id"] == updatedItem["id"]);
          if (index != -1) {
            state["foodItems"][index] = updatedItem;
            _setLocalStorage();
          }
        });
      },
      editorMode: state["editorMode"],
    );
  }

  Widget _buildShoppingList() {
    return ShoppingList(
      isOpen: state["listIsOpen"],
      isDark: state["darkMode"],
      closeList: () {
        setState(() {
          state["listIsOpen"] = false;
        });
      },
      shoppingList: state["shoppingList"],
      updateShoppingList: _updateShoppingList,
    );
  }
}
