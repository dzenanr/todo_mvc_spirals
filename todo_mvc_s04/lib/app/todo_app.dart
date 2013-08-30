part of todo_mvc_app;

class TodoApp {
  Tasks tasks;
  var todos = new List<Todo>();
  Element todoList = query('#todo-list');
  Element footer = query('#footer');
  Element todoCount = query('#todo-count');
  Element clearCompleted = query('#clear-completed');

  TodoApp(this.tasks) {
    load();

    InputElement newTodo = query('#new-todo');
    newTodo.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          add(task);
          newTodo.value = '';
          updateFooter();
        }
      }
    });

    clearCompleted.onClick.listen((MouseEvent e) {
      var completedTodos = new List<Todo>();
      var leftTodos = new List<Todo>();
      for (Todo todo in todos) {
        if (todo.task.completed) {
          completedTodos.add(todo);
        } else {
          leftTodos.add(todo);
        }
      }
      for (Todo completedTodo in completedTodos) {
        remove(completedTodo);
        todos.removeAt(todos.indexOf(completedTodo));
      }
      todos = leftTodos;
      updateFooter();
    });

    updateFooter();
  }

  load() {
    var json = window.localStorage['todos'];
    if (json != null) {
      try {
        var todoList = JSON.decode(json);
        for (Map todo in todoList) {
          var task = new Task(tasks.concept);
          task.fromJson(todo);
          add(task);
        }
      } catch (e) {
        window.console.log(
            'Could not load todos from the local storage. ${e}');
      }
    }
  }

  save() {
    window.localStorage['todos'] = JSON.encode(tasks.toJson());
  }

  add(Task task) {
    tasks.add(task);
    var todo = new Todo(task, this);
    todos.add(todo);
    todoList.nodes.add(todo.createElement());
  }

  remove(Todo todo) {
    var task = todo.task;
    tasks.remove(task);
    todo.remove();
    updateFooter();
  }

  updateFooter() {
    var display = todos.length == 0 ? 'none' : 'block';
    footer.style.display = display;
    updateTodoCount();
  }

  updateTodoCount() {
    todoCount.innerHtml =
        '<b>${tasks.left}</b> item${tasks.left != 1 ? 's' : ''} left';
    save();
  }

}
