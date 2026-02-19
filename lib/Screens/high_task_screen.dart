import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_projects/Models/task_model.dart';
import 'package:flutter_projects/Widgets/tasks_list_wiget.dart';
import 'package:flutter_projects/core/services/preference_manger.dart';

class HighTaskScreen extends StatefulWidget {
  const HighTaskScreen({super.key});

  @override
  State<HighTaskScreen> createState() => _HighTaskScreenState();
}

class _HighTaskScreenState extends State<HighTaskScreen> {
  bool is_loading = false;
  List<TaskModel> hightask = [];

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
      hightask = tasksDecode
          .map((elemnt) => TaskModel.formJson(elemnt))
          .toList();
      hightask = hightask.where((_element) => _element.isHighPriority).toList();
      hightask = hightask.reversed.toList();

      setState(() {
        this.hightask = hightask;
        is_loading = false;
      });
    } else {
      setState(() {
        is_loading = false;
      });
    }
  }

  void _deleteTask(id) async {
    List<TaskModel> tasks = [];
    final allTasks = PreferenceManger().getString("tasks");
    if (allTasks != null) {
      final tasksDecode = jsonDecode(allTasks) as List<dynamic>;
      tasks = tasksDecode.map((e) => TaskModel.formJson(e)).toList();
      tasks.removeWhere((el) => el.id == id);
      setState(() {
        hightask.removeWhere((task) => task.id == id);
      });
      final updateTask = tasks.map((elemnet) => elemnet.toJson()).toList();
      PreferenceManger().setString("tasks", jsonEncode(updateTask));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("High Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: is_loading
              ? CircularProgressIndicator(color: Colors.white)
              : SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 200,
                    ),
                    child: TasksListWiget(
                      tasks: hightask,
                      OnTap: (bool? value, int? index) async {
                        setState(() {
                          hightask[index!].isDone = value ?? false;
                        });
                        final updatedTask = hightask
                            .map((element) => element.toJson())
                            .toList();
                        final allData = PreferenceManger().getString("tasks");
                        if (allData != null) {
                          List<TaskModel> allDataTask =
                              (jsonDecode(allData) as List)
                                  .map(
                                    (_element) => TaskModel.formJson(_element),
                                  )
                                  .toList();
                          final newIndex = allDataTask.indexWhere(
                            (e) => e.id == hightask[index!].id,
                          );
                          allDataTask[newIndex] = hightask[index!];
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
    );
  }
}
