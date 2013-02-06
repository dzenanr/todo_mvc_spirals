part of todo_mvc_app;

class TodoWidget {
  Task task;
  TodoApp todoApp;
  Element element;
  InputElement toggleElement;

  TodoWidget(this.task, this.todoApp);

  Element createElement() {
    element = new Element.html('''
      <li ${task.completed ? 'class="completed"' : ''}>
        <div class='view'>
          <input class='toggle' type='checkbox' ${task.completed ? 'checked' : ''}>
          <label class='todo-content'>${task.title}</label>
        </div>
      </li>
    ''');

    toggleElement = element.query('.toggle');
    toggleElement.onClick.listen((MouseEvent e) {
      toggle();
      todoApp.updateCount();
    });

    return element;
  }

  void toggle() {
    task.completed = !task.completed;
    toggleElement.checked = task.completed;
    if (task.completed) {
      element.classes.add('completed');
    } else {
      element.classes.remove('completed');
    }
  }

}
