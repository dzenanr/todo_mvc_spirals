part of todo_mvc_app;

class TodoApp implements ActionReactionApi, PastReactionApi {
  DomainSession session;
  Tasks tasks;

  Todos todos;
  Element main = querySelector('#main');
  InputElement completeAll = querySelector('#complete-all');
  Element footer = querySelector('#footer');
  Element leftCount = querySelector('#left-count');
  Element clearCompleted = querySelector('#clear-completed');
  Element undo = querySelector('#undo');
  Element redo = querySelector('#redo');
  Element errors = querySelector('#errors');

  TodoApp(TodoModels domain) {
    session = domain.newSession();
    domain.startActionReaction(this);
    session.past.startPastReaction(this);
    MvcEntries model = domain.getModelEntries(TodoRepo.todoMvcModelCode);
    tasks = model.getEntry('Task');

    todos = new Todos(this);
    //load todos
    String json = window.localStorage['todos'];
    if (json != null) {
      tasks.fromJson(json);
      for (Task task in tasks) {
        todos.add(task);
      }
      _updateFooter();
      displayErrorsIfAny();
    }

    InputElement newTodo = querySelector('#new-todo');
    newTodo.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = newTodo.value.trim();
        if (title != '') {
          var task = new Task(tasks.concept);
          task.title = title;
          newTodo.value = '';
          var action = new AddAction(session, tasks, task);
          action.doit();
          displayErrorsIfAny();
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

    undo.style.display = 'none';
    undo.onClick.listen((MouseEvent e) {
      session.past.undo();
    });

    redo.style.display = 'none';
    redo.onClick.listen((MouseEvent e) {
      session.past.redo();
    });
  }

  displayErrorsIfAny() {
    errors.innerHtml = tasks.errors.toString();
    tasks.errors.clear();
  }

  _save() {
    window.localStorage['todos'] = tasks.toJson();
  }

  _updateFooter() {
    var display = tasks.length == 0 ? 'none' : 'block';
    completeAll.style.display = display;
    main.style.display = display;
    footer.style.display = display;

    // update counts
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

  react(BasicAction action) {
    if (action is AddAction) {
      _displayAction(action);
      if (action.state == 'undone') {
        todos.remove(action.entity);
      } else {
        todos.add(action.entity);
      }
    } else if (action is RemoveAction) {
      _displayAction(action);
      if (action.state == 'undone') {
        todos.add(action.entity);
      } else {
        todos.remove(action.entity);
      }
    } else if (action is SetAttributeAction) {
      if (action.property == 'completed') {
        todos.complete(action.entity);
      } else if (action.property == 'title') {
        todos.retitle(action.entity);
      }
    }
    _updateFooter();
    _save();
  }

  reactCannotUndo() {
    undo.style.display = 'none';
  }

  reactCanUndo() {
    undo.style.display = 'block';
  }

  reactCanRedo() {
    redo.style.display = 'block';
  }

  reactCannotRedo() {
    redo.style.display = 'none';
  }

  _displayAction(BasicAction action) {
    if (action is AddAction) {
      AddAction addAction = action;
      Task task = addAction.entity;
      task.display(prefix: 'add');
      print(addAction.toString());
    } else if (action is RemoveAction) {
      RemoveAction removeAction = action;
      Task task = removeAction.entity;
      task.display(prefix: 'remove');   
      print(removeAction.toString());
    } else if (action is SetAttributeAction) {
      SetAttributeAction setAttributeAction = action;
      if (setAttributeAction.property == 'completed') {
        todos.complete(setAttributeAction.entity);
      } else if (setAttributeAction.property == 'title') {
        todos.retitle(setAttributeAction.entity);
      }
    }
  }

}

