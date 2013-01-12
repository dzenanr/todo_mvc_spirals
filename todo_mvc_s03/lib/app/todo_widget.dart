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
          <button class='destroy'></button>
        </div>
      </li>
    ''');

    toggleElement = element.query('.toggle');
    toggleElement.on.click.add((MouseEvent e) {
      toggle();
      todoApp.updateCount();
    });

    removeTodo() {
      element.remove();
      todoApp.removeTodo(this);
      todoApp.updateFooterDisplay();
    }

    element.query('.destroy').on.click.add((MouseEvent e) {
      removeTodo();
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
