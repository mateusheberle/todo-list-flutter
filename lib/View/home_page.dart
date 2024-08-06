import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Model/item.dart';
import '../Controller/controller.dart';
import '../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Controller _controller;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = Controller();
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.preto,
      appBar: AppBar(
        backgroundColor: Cores.preto,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Your Notes',
              style: TextStyle(
                color: Cores.branco,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                letterSpacing: -3.0,
              ),
            ),
            const SizedBox(width: 16), // Espaçamento entre o título e o ícone
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: Cores.preto,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      await _callShowDialogAlert(context);
                    },
                    onLongPress: () {
                      _controller.removeAll();
                      _controller.todoList.clear();
                    },
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Cores.branco,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
          backgroundColor: Cores.vermelho,
          foregroundColor: Cores.branco,
          icon: Icons.delete,
          label: 'Remover',
        ),
      ],
    );
  }

  Container checkBoxWidget(Item item, BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Cores.preto,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Cores.branco,
            width: 1,
          ),
        ),
      ),
      child: CheckboxListTile(
        checkColor: Cores.preto,
        activeColor: Cores.verdinho,
        shape: const CircleBorder(),
        title: Text(
          item.title,
          style: TextStyle(
            color: Cores.branco,
            decorationColor: Cores.branco,
            decoration:
                item.isDone ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          item.description,
          style: TextStyle(
            color: Cores.branco,
            decorationColor: Cores.branco,
            decoration:
                item.isDone ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        visualDensity: VisualDensity.comfortable,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        secondary: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: !item.isDone ? Cores.verdinho : Cores.cinza,
          ),
          child: GestureDetector(
            onTap: () async {
              _controller.titleController.text = item.title;
              _controller.descriptionController.text = item.description;
              await _callShowDialogAlert(context, item: item);
            },
            child: Icon(
              Icons.edit,
              color: !item.isDone ? Cores.preto : Cores.branco,
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
  }

  Future<bool?> _removeConfirmation(BuildContext context, Item item) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Cores.preto,
          title: const Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Cores.verdinho,
                size: 50,
              ),
              Text(
                'Remover item',
                style: TextStyle(
                  color: Cores.branco,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "Confirmar exclusão?",
                  style: TextStyle(
                    color: Cores.branco,
                  ),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child:
                    const Text("Sim", style: TextStyle(color: Cores.branco))),
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child:
                    const Text("Não", style: TextStyle(color: Cores.branco))),
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
          backgroundColor: Cores.cinza,
          actionsOverflowButtonSpacing: 50,
          titlePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
          titleTextStyle: const TextStyle(
            color: Cores.branco,
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
                focusNode: _titleFocusNode,
                controller: _controller.titleController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Cores.branco,
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  label: Text('Título'),
                  hintText: 'título',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    color: Cores.branco,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                    borderSide: BorderSide(
                      color: Cores.branco,
                      width: 1,
                    ),
                  ),
                ),
                onSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                focusNode: _descriptionFocusNode,
                controller: _controller.descriptionController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Cores.branco,
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  label: Text('Descrição'),
                  hintText: 'descrição',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    color: Cores.branco,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                    borderSide: BorderSide(
                      color: Cores.branco,
                      width: 1,
                    ),
                  ),
                ),
                onSubmitted: (value) {
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
                              isDone: !item.isDone,
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: Cores.cinza,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                if (item != null && item.id > 0) {
                                  _controller.updateItem(
                                    Item(
                                      id: item.id,
                                      title: _controller.titleController.text,
                                      description: _controller
                                          .descriptionController.text,
                                      isDone: item.isDone,
                                    ),
                                  );
                                } else {
                                  _controller.addItem(
                                    title: _controller.titleController.text,
                                    description:
                                        _controller.descriptionController.text,
                                  );
                                }
                                _controller.titleController.clear();
                                _controller.descriptionController.clear();
                                Navigator.of(context).pop();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.check,
                                  color: Cores.branco,
                                ),
                              ),
                            ),
                          ),
                        ),
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
