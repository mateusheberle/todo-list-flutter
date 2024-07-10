class Item {
  final int id;
  final String title;
  final String description;
  final bool isDone;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });

  @override
  String toString() {
    return 'Item{id: $id, title: $title, description: $description, isDone: $isDone}';
  }
}
