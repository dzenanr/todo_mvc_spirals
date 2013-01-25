part of todo_mvc_app;

class TodoApp implements ActionReactionApi, PastReactionApi {
  DomainSession session;
  Tasks tasks;

  Todos _todos;
  Element _main = query('#main');
  InputElement _completeAll = query('#complete-all');
  Element _footer = query('#footer');
  Element _leftCount = query('#left-count');
  Element _clearCompleted = query('#clear-completed');
  Element _undo = query('#undo');
  Element _redo = query('#redo');
  Element _errors = query('#errors');

  TodoApp(TodoModels domain) {
    session = domain.newSession();
    domain.startActionReaction(this);
    session.past.startPastReaction(this);
    MvcEntries model = domain.getModelEntries(TodoRepo.todoMvcModelCode);
    tasks = model.getEntry('Task');

    _todos = new Todos(this);
    //load todos
    String json = window.localStorage['todos'];
    if (json != null) {
      tasks.fromJson(parse(json));
      for (Task task in tasks) {
        _todos.add(task);
      }
      _updateFooter();
    }

    InputElement newTodo = query('#new-todo');
    newTodo.on.keyPress.add((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          newTodo.value = '';
          new AddAction(session, tasks, task).doit();
          _possibleErrors();
        }
      }
    });

    _completeAll.on.click.add((Event e) {
      var transaction = new Transaction('complete-all', session);
      if (tasks.left.length == 0) {
        for (Task task in tasks) {
          transaction.add(
              new SetAttributeAction(session, task, 'completed', false));
        }
      } else {
        for (Task task in tasks.left) {
          transaction.add(
              new SetAttributeAction(session, task, 'completed', true));
        }
      }
      transaction.doit();
    });

    _clearCompleted.on.click.add((MouseEvent e) {
      for (Task task in tasks.completed) {
        new RemoveAction(session, tasks.completed, task).doit();
      }
    });

    _undo.style.display = 'none';
    _undo.on.click.add((MouseEvent e) {
      session.past.undo();
    });

    _redo.style.display = 'none';
    _redo.on.click.add((MouseEvent e) {
      session.past.redo();
    });
  }

  _save() {
    window.localStorage['todos'] = stringify(tasks.toJson());
  }

  _possibleErrors() {
    _errors.innerHtml = '<p>${tasks.errors.toString()}</p>';
    tasks.errors.clear();
  }

  _updateFooter() {
    var display = tasks.length == 0 ? 'none' : 'block';
    _completeAll.style.display = display;
    _main.style.display = display;
    _footer.style.display = display;

    // update counts
    var completedLength = tasks.completed.length;
    var leftLength = tasks.left.length;
    _completeAll.checked = (completedLength == tasks.length);
    _leftCount.innerHtml =
        '<b>${leftLength}</b> todo${leftLength != 1 ? 's' : ''} left';
    if (completedLength == 0) {
      _clearCompleted.style.display = 'none';
    } else {
      _clearCompleted.style.display = 'block';
      _clearCompleted.text = 'Clear completed (${tasks.completed.length})';
    }

    _possibleErrors();
  }

  react(ActionApi action) {
    updateTodo(SetAttributeAction action) {
      if (action.property == 'completed') {
        _todos.complete(action.entity);
      } else if (action.property == 'title') {
        _todos.retitle(action.entity);
      }
    }

    if (action is AddAction) {
      if (action.undone) {
        _todos.remove(action.entity);
      } else {
        _todos.add(action.entity);
      }
    } else if (action is RemoveAction) {
      if (action.undone) {
        _todos.add(action.entity);
      } else {
        _todos.remove(action.entity);
      }
    } else if (action is SetAttributeAction) {
      updateTodo(action);
    } else if (action is Transaction) {
      for (var transactionAction in action.past.actions) {
        if (transactionAction is SetAttributeAction) {
          updateTodo(transactionAction);
        }
      }
    }

    _updateFooter();
    _save();
  }

  reactCannotUndo() {
    _undo.style.display = 'none';
  }

  reactCanUndo() {
    _undo.style.display = 'block';
  }

  reactCanRedo() {
    _redo.style.display = 'block';
  }

  reactCannotRedo() {
    _redo.style.display = 'none';
  }

}

