part of todo_mvc;

// lib/todo/mvc/tasks.dart

class Task extends TaskGen {

  Task(Concept concept) : super(concept);

}

class Tasks extends TasksGen {

  Tasks(Concept concept) : super(concept);

  int get completed => selectWhere((task) => task.completed).length;
  int get left => length - completed;

}
