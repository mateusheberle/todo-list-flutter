import '../Model/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
        title: const Text('Atividade EBAC todo list'),
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
                // startActionPane - ação da esquerda
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  // dismissible - o que fazer ao arrastar até o final
                  dismissible: DismissiblePane(
                    closeOnCancel: true,
                    confirmDismiss: () async {
                      return await _removeConfirmation(context, item) ?? false;
                    },
                    onDismissed: () {
                      _controller.removeItem(index);
                    },
                  ),
                  // dismissible - quando o usuário começa a puxar até o final,
                  // os outros botões somem e aparece esse texto de 'Remover'
/*
                  dismissible: Container(
                    child: const Center(
                      child: Text('Remover'),
                    ),
                  ),
*/
                  children: [
                    // slidableAction -  o que acontece quando clica no item
                    SlidableAction(
                      onPressed: (context) async {
                        final canRemove =
                            await _removeConfirmation(context, item) ?? false;
                        if (canRemove) {
                          _controller.removeItem(index);
                        }
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Remover',
                    ),
                  ],
                ),
                // endActionPane - ação da direita
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(
                    closeOnCancel: true,
                    confirmDismiss: () async {
                      return await _removeConfirmation(context, item) ?? false;
                    },
                    onDismissed: () {
                      _controller.removeItem(index);
                    },
                  ),
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        final canRemove =
                            await _removeConfirmation(context, item) ?? false;
                        if (canRemove) {
                          _controller.removeItem(index);
                        }
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Remover',
                    ),
                  ],
                ),
                child: CheckboxListTile(
                  activeColor: Colors.green,
                  title: Text(
                    item.title,
                    style: TextStyle(
                      decoration: item.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    item.description,
                    style: TextStyle(
                      decoration: item.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  visualDensity: VisualDensity.comfortable,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  secondary: Container(
                    width: 120,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: !item.isDone ? Colors.amber : Colors.grey,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        if (!item.isDone) {
                          _controller.titleController.text = item.title;
                          _controller.descriptionController.text =
                              item.description;
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
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _callShowDialogAlert(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
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
      barrierDismissible: false,
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
            color: Colors.blue,
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
                  label: Text('title'),
                  hintText: 'Título',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 16,
                color: Colors.grey.withOpacity(0.5),
              ),
              TextField(
                controller: _controller.descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  label: Text('description'),
                  hintText: 'Descrição',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
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
                              description:
                                  _controller.descriptionController.text,
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
                      )),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
