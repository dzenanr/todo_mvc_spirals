part of todo_mvc_app;

class Todo {
  Task task;
  Todos todos;
  Element todo;
  InputElement toggle;

  Todo(this.task, this.todos);

  Element create() {
    todo = new Element.html('''
      <li ${task.completed ? 'class="completed"' : ''}>
        <div class='view'>
          <input class='toggle-completed' type='checkbox' 
            ${task.completed ? 'checked' : ''}>
          <label class='todo-content'>${task.title}</label>
          <button class='remove'></button>
        </div>
        <input class='edit' value='${task.title}'>
      </li>
    ''');

    Element todoContent = todo.query('.todo-content');
    InputElement edit = todo.query('.edit');

    todoContent.onDoubleClick.listen((MouseEvent e) {
      todo.classes.add('editing');
      edit.select();
      //edit.selectionStart = task.title.length;
      edit.focus();
    });

    editingDone(event) {
      task.title = edit.value.trim();
      if (task.title != '') {
        todoContent.text = task.title;
        todo.classes.remove('editing');
        todos.save();
      }
    }

    edit.onKeyPress.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        editingDone(e);
      }
    });

    toggle = todo.query('.toggle-completed');
    toggle.onClick.listen((MouseEvent e) {
      toggleCompleted();
      todos.updateCounts();
    });

    todo.query('.remove').onClick.listen((MouseEvent e) {
      todos.remove(this);
    });

    return todo;
  }

  remove() {
    todo.remove();
  }

  toggleCompleted() {
    task.completed = !task.completed;
    toggle.checked = task.completed;
    if (task.completed) {
      todo.classes.add('completed');
    } else {
      todo.classes.remove('completed');
    }
  }

}
