import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_projects/Models/task_model.dart';
import 'package:flutter_projects/core/components/tasks_list_wiget.dart';
import 'package:flutter_projects/core/services/preference_manger.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({super.key});

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  bool is_loading = false;
  List<TaskModel> completeTasks = [];

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
      completeTasks = tasksDecode
          .map((elemnt) => TaskModel.formJson(elemnt))
          .toList();
      completeTasks = completeTasks
          .where((_element) => _element.isDone)
          .toList();

      setState(() {
        this.completeTasks = completeTasks;
        is_loading = false;
      });
    } else {
      setState(() {
        is_loading = false;
      });
    }
  }

  _deleteTask(int id) async {
    List<TaskModel> alltasks = [];
    final allTasks = PreferenceManger().getString("tasks");
    if (allTasks != null) {
      final tasksDecode = jsonDecode(allTasks) as List<dynamic>;
      alltasks = tasksDecode.map((e) => TaskModel.formJson(e)).toList();
      alltasks.removeWhere((el) => el.id == id);
      setState(() {
        completeTasks.removeWhere((task) => task.id == id);
      });
      final updated = alltasks
          .map((_element) => _element.toJson())
          .toList();
      PreferenceManger().setString("tasks", jsonEncode(updated));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            "Completed Tasks",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 20),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: is_loading
                ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
                : SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 200,
                ),
                child: TasksListWiget(
                  tasks: completeTasks,
                  OnTap: (bool? value, int? index) async {
                    setState(() {
                      completeTasks[index!].isDone = value ?? false;
                    });

                    final allData = PreferenceManger().getString("tasks");
                    if (allData != null) {
                      List<TaskModel> allDataTask = (jsonDecode(allData) as List)
                          .map((e) => TaskModel.formJson(e))
                          .toList();
                      final newIndex = allDataTask
                          .indexWhere((e) => e.id == completeTasks[index!].id);
                      allDataTask[newIndex] = completeTasks[index!];
                      PreferenceManger().setString("tasks", jsonEncode(allDataTask));
                      _loadTasks();
                    }
                  },
                  OnDelete: (int? id) {
                    _deleteTask(id!);
                  },
                  onEdit: () => _loadTasks(),
                  EmptyMessage: "No Completed Tasks Found",
                ),
              ),
            ),
          ),
        ),



      ],
    );
  }
}
