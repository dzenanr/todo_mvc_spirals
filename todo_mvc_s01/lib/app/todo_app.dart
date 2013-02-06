part of todo_mvc_app;

class TodoApp {
  Tasks tasks;
	var todoWidgets = new List<TodoWidget>();
	Element todoListElement = query('#todo-list');

	TodoApp(repo) {
	  var todo =
	      repo.getDomainModels(TodoRepo.todoDomainCode);
    var mvc = todo.getModelEntries(TodoRepo.todoMvcModelCode);
    tasks = mvc.getEntry('Task');

    InputElement newTodoElement = query('#new-todo');
    newTodoElement.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodoElement.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          addTodo(task);
          newTodoElement.value = '';
        }
      }
    });
	}

	addTodo(Task task) {
	  tasks.add(task);
		var todoWidget = new TodoWidget(task);
		todoWidgets.add(todoWidget);
		todoListElement.nodes.add(todoWidget.createElement());
	}

}
