import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Model/item.dart';
import '../Controller/controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = Controller();
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('todo list'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _controller.removeAll();
              _controller.todoList.clear();
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: _controller.todoList.length,
            itemBuilder: (context, index) {
              final item = _controller.todoList[index];
              return Slidable(
                key: ValueKey(item.toString()),
                startActionPane: actionWidget(
                    context, item, index), // startActionPane - ação da esquerda
                endActionPane: actionWidget(
                    context, item, index), // endActionPane - ação da direita
                child: checkBoxWidget(item, context),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _callShowDialogAlert(context),
        tooltip: 'Adicionar nota',
        child: const Icon(Icons.add),
      ),
    );
  }

  ActionPane actionWidget(BuildContext context, Item item, int index) {
    return ActionPane(
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(
        closeOnCancel: true,
        confirmDismiss: () async =>
            await _removeConfirmation(context, item) ?? false,
        onDismissed: () => _controller.removeItem(index, item),
      ),
      children: [
        SlidableAction(
          onPressed: (context) async {
            final canRemove = await _removeConfirmation(context, item) ?? false;
            if (canRemove) {
              _controller.removeItem(index, item);
            }
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Remover',
        ),
      ],
    );
  }

  CheckboxListTile checkBoxWidget(Item item, BuildContext context) {
    return CheckboxListTile(
      activeColor: Colors.teal,
      title: Text(
        item.title,
        style: TextStyle(
          decoration:
              item.isDone ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        item.description,
        style: TextStyle(
          decoration:
              item.isDone ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity: VisualDensity.comfortable,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      secondary: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: !item.isDone ? Colors.amber : Colors.grey,
        ),
        child: GestureDetector(
          onTap: () async {
            if (!item.isDone) {
              _controller.titleController.text = item.title;
              _controller.descriptionController.text = item.description;
              await _callShowDialogAlert(context, item: item);
            } else {
              return;
            }
          },
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
      value: item.isDone,
      onChanged: (value) {
        _controller.updateItem(
          Item(
            id: item.id,
            title: item.title,
            description: item.description,
            isDone: value ?? false,
          ),
        );
      },
    );
  }

  Future<bool?> _removeConfirmation(BuildContext context, Item item) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 50,
              ),
              Text(
                'Remover item',
              ),
            ],
          ),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text("Confirmar exclusão?"),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Sim")),
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Não")),
          ],
        );
      },
    );
  }

  Future<dynamic> _callShowDialogAlert(context, {Item? item}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          actionsOverflowButtonSpacing: 50,
          titlePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
          titleTextStyle: const TextStyle(
            color: Colors.teal,
            fontSize: 18,
          ),
          title: const Center(child: Text('Adicionar item')),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: _controller.titleController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  label: Text('Título'),
                  hintText: 'título',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _controller.descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  label: Text('Descrição'),
                  hintText: 'descrição',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      if (item != null && item.id > 0) {
                        _controller.updateItem(
                          Item(
                            id: item.id,
                            title: _controller.titleController.text,
                            description: _controller.descriptionController.text,
                            isDone: item.isDone,
                          ),
                        );
                      } else {
                        _controller.addItem(
                          title: _controller.titleController.text,
                          description: _controller.descriptionController.text,
                        );
                      }
                      _controller.titleController.clear();
                      _controller.descriptionController.clear();
                      Navigator.of(context).pop();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: const Icon(
                      Icons.check,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
