# Dismissible()

    widget nativo do flutter
    permite que o usuário arraste o item para fora da lista para removê-lo.

```dart
Dismissible(
    // CROSSAXISENDOFFSET: arrastar para o lado em um angulo diferente do reto 
    crossAxisEndOffset: 0.5, 
    // CONFIRMDISMISS: função que retorna um Future<bool> que indica se o item pode ser removido ou não
    confirmDismiss: (DismissDirection direction) async {
        return await _removeConfirmacao(context, direction);
    } 
    // ONDISMISSED: função que é chamada quando o item é removido, 
    // direction - indica a direção do arraste (startToEnd ou endToStart)
    onDismissed: (DismissDirection direction) {
        if(direction == DismissDirection.startToEnd){
            _removerAnotacao(index);
        }
    }
    // BACKGROUND: widget que é exibido atrás do item quando ele é arrastado (principal)
    background: Container(
        color: Colors.red,
        child: Align(
            child: Icon(
                Icons.delete,
                color: Colors.white,
            ),
        ),
    ),
    // SECONDARYBACKGROUND: widget que é exibido atrás do item quando ele é arrastado (segundo)
    secondaryBackground: Container(
        color: Colors.green,
        child: Align(
            child: Icon(
                Icons.archive,
                color: Colors.white,
            ),
        ),
    ),
)
```

### [Pacote flutter_slidable](https://pub.dev/packages/flutter_slidable)

+ elegante
+ recursos

### widget: Slidable()

#### possibilidades de 'motion':
- behind motion
- drawer motion
- scroll motion
- stretch motion

