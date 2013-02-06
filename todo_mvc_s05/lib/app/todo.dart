part of todo_mvc_app;

class Todo {
  Task task;
  TodoApp todoApp;
  Element todo;
  InputElement toggle;

  Todo(this.task, this.todoApp);

  Element create() {
    todo = new Element.html('''
      <li ${task.completed ? 'class="completed"' : ''}>
        <div class='view'>
          <input class='toggle-completed' type='checkbox'
            ${task.completed ? 'checked' : ''}>
          <label class='todo-content'>${task.title}</label>
          <button class='remove'></button>
        </div>
      </li>
    ''');

    toggle = todo.query('.toggle-completed');
    toggle.onClick.listen((MouseEvent e) {
      toggleCompleted();
      todoApp.updateCounts();
    });

    todo.query('.remove').onClick.listen((MouseEvent e) {
      todoApp.remove(this);
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
