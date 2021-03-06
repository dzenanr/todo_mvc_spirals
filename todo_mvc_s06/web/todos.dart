
import 'package:todo_mvc/todo_mvc.dart';
import 'package:todo_mvc/todo_mvc_app.dart';

main() {
  var repo = new TodoRepo();
  var todo = repo.getDomainModels(TodoRepo.todoDomainCode);
  var mvc = todo.getModelEntries(TodoRepo.todoMvcModelCode);
  Tasks tasks = mvc.getEntry('Task');
  new Todos(tasks);
}



