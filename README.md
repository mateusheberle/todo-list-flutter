## Gerenciador de Tarefas (To-Do) com Flutter e Sqflite

**Introdução**

Este projeto é um gerenciador de tarefas simples desenvolvido com Flutter e Sqflite. Ele permite que você adicione, visualize, edite e exclua tarefas. As tarefas são armazenadas localmente em um banco de dados SQLite.

**Requisitos**

* Flutter instalado
* Sqflite instalado

**Instalação**

1. Clone o repositório:

```
git clone https://github.com/mateusheberle/todo-list-flutter.git
```

2. Navegue para o diretório do projeto:

```
cd todo-list-flutter
```

3. Instale as dependências:

```
flutter pub get
```

4. Execute o aplicativo:

```
flutter run
```

**Funcionalidades**

* **Adicionar tarefas:** Digite o título e a descrição de uma tarefa e pressione o botão.
* **Visualizar tarefas:** Uma lista de todas as tarefas é exibida na tela principal.
* **Editar tarefas:** Toque em uma tarefa para editá-la.
* **Excluir tarefas:** Deslize para a esquerda em uma tarefa para excluí-la.

**Banco de dados**

O banco de dados SQLite armazena as seguintes informações:

* **ID:** Identificador único da tarefa
* **Título:** Título da tarefa
* **Descrição:** Descrição da tarefa
* **Concluído:** Indica se a tarefa está concluída ou não

**Considerações**

* Este é um projeto simples e pode ser expandido para incluir mais funcionalidades, como categorias, prioridades e lembretes.
* O código pode ser melhorado para torná-lo mais eficiente e robusto.

**Contribuições**

Sinta-se à vontade para contribuir com este projeto enviando pull requests ou relatando problemas.
