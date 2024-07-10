import '../Model/item.dart';
import 'package:flutter/material.dart';

class Controller extends ValueNotifier<List<Item>> {
  List<Item> todoList = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Controller()
      : super([Item(id: 0, title: '', description: '', isDone: false)]);

  void addItem({required String title, required String description}) {
    if (title != '' && description != '') {
      final item = _createNewItem(Item(
        id: _generateId(),
        title: title,
        description: description,
        isDone: false,
      ));

      if (item == null) {
        return;
      }

      todoList.add(item);
      notifyListeners();
    }
  }

  void updateItem(Item item) {
    final oldItem = todoList.where((element) => element.id == item.id);

    if (item.id < 1 || oldItem.isEmpty || item.title.isEmpty) {
      return;
    }

    final index = todoList.indexOf(oldItem.first);
    final newItem = _createNewItem(item);

    if (newItem == null) {
      return;
    }

    todoList.removeAt(index);
    todoList.insert(index, newItem);

    _clearControllers();
    notifyListeners();
  }

  void removeItem(int index) {
    todoList.removeAt(index);
    notifyListeners();
  }

  Item? _createNewItem(Item newItem) {
    if (newItem.id < 1) {
      return null;
    }

    final newId = newItem.id > 0 ? newItem.id : _generateId();

    final item = Item(
      id: newId,
      title: newItem.title,
      description: newItem.description,
      isDone: newItem.isDone,
    );
    return item;
  }

  int _generateId() {
    return todoList.isEmpty ? 1 : todoList.last.id + 1;
  }

  _clearControllers() {
    titleController.clear();
    descriptionController.clear();
  }
}
