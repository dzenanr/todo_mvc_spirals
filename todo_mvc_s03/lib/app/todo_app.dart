part of todo_mvc_app;

class TodoApp {
  Tasks tasks;
  var todoWidgets = new List<TodoWidget>();
  Element todoListElement = query('#todo-list');
  Element footerElement = query('#footer');
  Element countElement = query('#todo-count');
  Element clearCompletedElement = query('#clear-completed');

  TodoApp(repo) {
    var todo =
        repo.getDomainModels(TodoRepo.todoDomainCode);
    var mvc = todo.getModelEntries(TodoRepo.todoMvcModelCode);
    tasks = mvc.getEntry('Task');

    InputElement newTodoElement = query('#new-todo');
    newTodoElement.on.keyPress.add((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodoElement.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          addTodo(task);
          newTodoElement.value = '';
          updateFooterDisplay();
        }
      }
    });

    clearCompletedElement.on.click.add((MouseEvent e) {
      var newList = new List<TodoWidget>();
      for (TodoWidget todoWidget in todoWidgets) {
        if (todoWidget.task.completed) {
          todoWidget.element.remove();
        } else {
          newList.add(todoWidget);
        }
      }
      todoWidgets = newList;
      updateFooterDisplay();
    });

    updateFooterDisplay();
  }

  addTodo(Task todo) {
    tasks.add(todo);
    var todoWidget = new TodoWidget(todo, this);
    todoWidgets.add(todoWidget);
    todoListElement.nodes.add(todoWidget.createElement());
  }

  removeTodo(TodoWidget todoWidget) {
    var task = todoWidget.task;
    tasks.remove(task);
    todoWidgets.removeAt(todoWidgets.indexOf(todoWidget));
  }

  updateFooterDisplay() {
    var display = todoWidgets.length == 0 ? 'none' : 'block';
    footerElement.style.display = display;
    updateCount();
  }

  updateCount() {
    countElement.innerHTML =
        '<b>${tasks.left}</b> item${tasks.left != 1 ? 's' : ''} left';
  }

}
