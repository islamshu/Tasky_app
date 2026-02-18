import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_projects/Models/task_model.dart';
import 'package:flutter_projects/Widgets/tasks_list_wiget.dart';
import 'package:flutter_projects/core/services/preference_manger.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool is_loading = false;
  List<TaskModel> todoTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    setState(() {
      is_loading = true;
    });
    // await Future.delayed(Duration(microseconds: 100000));
    final finaltasks = PreferenceManger().getString("tasks");
    if (finaltasks != null) {
      final tasksDecode = jsonDecode(finaltasks) as List<dynamic>;
      todoTasks = tasksDecode
          .map((elemnt) => TaskModel.formJson(elemnt))
          .toList();
      todoTasks = todoTasks
          .where((_element) => _element.isDone == false)
          .toList();

      setState(() {
        this.todoTasks = todoTasks;
        is_loading = false;
      });
    } else {
      setState(() {
        is_loading = false;
      });
    }
  }

  _deleteTask(int id) async {
    List<TaskModel> tasks = [];
    final allTasks = PreferenceManger().getString("tasks");
    if (allTasks != null) {
      final tasksDecode = jsonDecode(allTasks) as List<dynamic>;
      tasks = tasksDecode.map((e) => TaskModel.formJson(e)).toList();
      tasks.removeWhere((el) => el.id == id);
      setState(() {
        todoTasks.removeWhere((task) => task.id == id);
      });
      final updated = tasks.map((_element) => _element.toJson()).toList();
      PreferenceManger().setString("tasks", jsonEncode(updated));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            "My Tasks",
            style: Theme.of(
              context,
            ).textTheme.displayLarge!.copyWith(fontSize: 20),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: is_loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 200,
                        ),
                        child: TasksListWiget(
                          tasks: todoTasks,
                          OnTap: (bool? value, int? index) async {
                            setState(() {
                              todoTasks[index!].isDone = value ?? false;
                            });
                            final updatedTask = todoTasks
                                .map((element) => element.toJson())
                                .toList();
                            final allData = PreferenceManger().getString(
                              "tasks",
                            );
                            if (allData != null) {
                              List<TaskModel> allDataTask =
                                  (jsonDecode(allData) as List)
                                      .map(
                                        (_element) =>
                                            TaskModel.formJson(_element),
                                      )
                                      .toList();
                              final newIndex = allDataTask.indexWhere(
                                (e) => e.id == todoTasks[index!].id,
                              );
                              allDataTask[newIndex] = todoTasks[index!];
                              PreferenceManger().setString(
                                "tasks",
                                jsonEncode(allDataTask),
                              );
                              _loadTasks();
                            }
                          },

                          EmptyMessage: "No Tasks Found",
                          OnDelete: (int? id) {
                            _deleteTask(id!);
                          },
                          onEdit: () => _loadTasks(),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
