part of todo_mvc;

// lib/todo/mvc/tasks.dart

class Task extends TaskGen {

  Task(Concept concept) : super(concept);

  fromJson(Map json) {
    title = json['title'];
    String completedString = json['completed'];
    if (completedString.trim() == 'true') {
      completed = true;
    }
  }

}

class Tasks extends TasksGen {

  Tasks(Concept concept) : super(concept);

}
