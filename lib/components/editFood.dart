import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class FoodEditor extends StatefulWidget {
  final Function(String, dynamic) editField;
  final Function(String, dynamic) editDate;
  final Function(String) editCategory;
  final Function() takePhoto;
  final Function() rotatePhoto;
  final Function() saveChanges;
  final Function() addItem;
  final Function() deleteFromEditor;
  final Function(String) closeEditor;
  final Map<String, dynamic> currentItem;
  final String editorMode;
  final bool isOpen;
  final bool isDark;
  final String currentSection;

  FoodEditor({
    required this.editField,
    required this.editDate,
    required this.editCategory,
    required this.takePhoto,
    required this.rotatePhoto,
    required this.saveChanges,
    required this.addItem,
    required this.deleteFromEditor,
    required this.closeEditor,
    required this.currentItem,
    required this.editorMode,
    required this.isOpen,
    required this.isDark,
    required this.currentSection,
  });

  @override
  _FoodEditorState createState() => _FoodEditorState();
}

class _FoodEditorState extends State<FoodEditor> {
  bool isRemoving = false;
  bool nameMissing = false;
  bool addedDateMissing = false;
  bool error = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.currentItem['name'] ?? '';
    quantityController.text = widget.currentItem['quantity'] ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void validate() {
    final img = widget.currentItem['img'] ?? '';
    final name = nameController.text;
    final added = widget.currentItem['added'] ?? '';

    if (img.isEmpty && name.isEmpty) {
      setState(() {
        nameMissing = true;
        error = true;
      });
      return;
    }
    if (added.isEmpty) {
      setState(() {
        addedDateMissing = true;
        error = true;
      });
      return;
    }
    setState(() {
      nameMissing = false;
      addedDateMissing = false;
      error = false;
    });
    if (widget.editorMode == 'edit') {
      widget.saveChanges();
    } else {
      widget.addItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return SizedBox.shrink();

    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: widget.isDark ? Colors.black : Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => widget.closeEditor(widget.currentSection),
        ),
        title: Text('${widget.editorMode} an item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection(),
              _buildTextField('Item name', 'name', nameController, nameMissing),
              _buildTextField('Quantity', 'quantity', quantityController, false),
              _buildDateField('Added on', 'added', addedDateMissing),
              _buildDateField('Expires on', 'expires', false),
              _buildButtonBlock(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    final img = widget.currentItem['img'] ?? '';
    return Row(
      children: [
        GestureDetector(
          onTap: widget.takePhoto,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: nameMissing ? Colors.red : Colors.grey,
              ),
              image: img.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(img),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: img.isEmpty
                ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                : null,
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRadioOption('Fridge', 'fridge'),
            _buildRadioOption('Freezer', 'freezer'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: widget.currentSection,
          onChanged: (val) => setState(() {
            widget.editCategory(val!);
            widget.editField('category', val);
          }),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildTextField(
      String label, String id, TextEditingController controller, bool missing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          errorText: missing ? 'This field is required' : null,
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => widget.editField(id, value),
      ),
    );
  }

  Widget _buildDateField(String label, String id, bool missing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              onConfirm: (date) {
                widget.editDate(id, date.toString());
              },
              currentTime: DateTime.now(),
              locale: LocaleType.en);
        },
        child: AbsorbPointer(
          child: TextField(
            decoration: InputDecoration(
              labelText: label,
              errorText: missing ? 'This field is required' : null,
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(
              text: widget.currentItem[id],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonBlock() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: validate,
          child: Text(widget.editorMode == 'edit' ? 'Save Changes' : 'Add Item'),
        ),
        if (widget.editorMode == 'edit')
          ElevatedButton(
            onPressed: () {
              setState(() {
                isRemoving = !isRemoving;
              });
            },
            child: Text(isRemoving ? 'Cancel' : 'Remove Item'),
          ),
        if (error)
          Text(
            nameMissing ? 'Please provide a name or a photo.' : 'Please provide added date.',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
