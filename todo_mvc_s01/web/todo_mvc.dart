
import 'dart:html';
import 'dart:isolate';
import 'dart:math';

import 'package:dartling/dartling.dart';
import 'package:dartling/dartling_app.dart';

import 'package:todo_mvc/todo_mvc.dart';
import 'package:todo_mvc/todo_mvc_app.dart';

main() {
  new TodoApp(new TodoRepo());
}



