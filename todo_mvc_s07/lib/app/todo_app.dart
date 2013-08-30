part of todo_mvc_app;

class TodoApp implements ActionReactionApi {
  DomainSession session;
  Tasks tasks;

  Todos todos = new Todos();
  Element main = query('#main');
  InputElement completeAll = query('#complete-all');
  Element footer = query('#footer');
  Element leftCount = query('#left-count');
  Element clearCompleted = query('#clear-completed');

  TodoApp(TodoModels domain) {
    session = domain.newSession();
    domain.startActionReaction(this);
    MvcEntries model = domain.getModelEntries(TodoRepo.todoMvcModelCode);
    tasks = model.getEntry('Task');
    //load todos
    String json = window.localStorage['todos'];
    if (json != null) {
      var todoList = JSON.decode(json);
      tasks.from(json);
      for (Task task in tasks) {
        _add(task);
      }
      _updateFooter();
    }

    InputElement newTodo = query('#new-todo');
    newTodo.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          newTodo.value = '';
          var action = new AddAction(session, tasks, task);
          action.doit();
        }
      }
    });

    completeAll.onClick.listen((Event e) {
      if (tasks.left.length == 0) {
        for (Task task in tasks) {
          var action = new SetAttributeAction(
              session, task, 'completed', false);
          action.doit();
        }
      } else {
        for (Task task in tasks.left) {
          var action = new SetAttributeAction(
              session, task, 'completed', true);
          action.doit();
        }
      }
    });

    clearCompleted.onClick.listen((MouseEvent e) {
      for (Task task in tasks.completed) {
        var action = new RemoveAction(session, tasks.completed, task);
        action.doit();
      }
    });
  }

  _save() {
    window.localStorage['todos'] = JSON.encode(tasks.toJson());
  }

  _add(Task task) {
    var todo = new Todo(session, tasks, task);
    todos.add(todo);
  }

  _remove(Task task) {
    for (Todo todo in todos.toList()) {
      if (todo.task == task) {
        todos.remove(todo);
      }
    }
  }

  _completeTodo(Task task) {
    for (Todo todo in todos) {
      if (todo.task == task) {
        todo.complete(task.completed);
      }
    }
  }

  _retitleTodo(Task task) {
    for (Todo todo in todos) {
      if (todo.task == task) {
        todo.retitle(task.title);
      }
    }
  }

  _updateFooter() {
    updateCounts() {
      var completedLength = tasks.completed.length;
      var leftLength = tasks.left.length;
      completeAll.checked = (completedLength == tasks.length);
      leftCount.innerHtml =
          '<b>${leftLength}</b> todo${leftLength != 1 ? 's' : ''} left';
          if (completedLength == 0) {
            clearCompleted.style.display = 'none';
          } else {
            clearCompleted.style.display = 'block';
            clearCompleted.text = 'Clear completed (${tasks.completed.length})';
          }
    }

    var display = todos.count == 0 ? 'none' : 'block';
    main.style.display = display;
    footer.style.display = display;
    updateCounts();
  }

  react(BasicAction action) {
    if (action is AddAction) {
      _add((action as AddAction).entity);
    } else if (action is RemoveAction) {
      _remove((action as RemoveAction).entity);
    } else if (action is SetAttributeAction) {
      SetAttributeAction setAttributeAction = action;
      if (setAttributeAction.property == 'completed') {
        _completeTodo(setAttributeAction.entity);
      } else if (setAttributeAction.property == 'title') {
        _retitleTodo(setAttributeAction.entity);
      }
    }
    _updateFooter();
    _save();
  }

}

