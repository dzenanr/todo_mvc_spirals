part of todo_mvc_app;

class Todo {
  DomainSession session;
  Tasks tasks;
  Task task;

  Element todo;
  InputElement completed;
  Element title;

  Todo(this.session, this.tasks, this.task);

  Element create() {
    todo = new Element.html('''
      <li ${task.completed ? 'class="completed"' : ''}>
        <div class='view'>
          <input class='completed' type='checkbox' ${task.completed ? 'checked' : ''}>
          <label id='title'>${task.title}</label>
          <button class='remove'></button>
        </div>
        <input class='edit' value='${task.title}'>
      </li>
    ''');

    title = todo.query('#title');
    InputElement edit = todo.query('.edit');

    title.onDoubleClick.listen((MouseEvent e) {
      todo.classes.add('editing');
      edit.select();
    });

    edit.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        var title = edit.value.trim();
        if (title != '') {
          var action = new SetAttributeAction(
              session, task, 'title', title);
          action.doit();
        }
      }
    });

    completed = todo.query('.completed');
    completed.onClick.listen((MouseEvent e) {
      var action = new SetAttributeAction(
          session, task, 'completed', !task.completed);
      action.doit();
    });

    todo.query('.remove').onClick.listen((MouseEvent e) {
      var action = new RemoveAction(session, tasks, task);
      action.doit();
    });

    return todo;
  }

  remove() {
    todo.remove();
  }

  complete(bool newCompleted) {
    completed.checked = newCompleted;
    if (newCompleted) {
      todo.classes.add('completed');
    } else {
      todo.classes.remove('completed');
    }
  }

  retitle(String newTitle) {
    title.text = newTitle;
    todo.classes.remove('editing');
  }

}
