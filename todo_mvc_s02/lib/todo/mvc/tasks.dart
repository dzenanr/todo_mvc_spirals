part of todo_mvc;

// lib/todo/mvc/tasks.dart

class Task extends TaskGen {

  Task(Concept concept) : super(concept);

}

class Tasks extends TasksGen {

  Tasks(Concept concept) : super(concept);

  int get completed => select((task) => task.completed).count;
  int get left => count - completed;

}
