import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_projects/Models/task_model.dart';
import 'package:flutter_projects/Screens/add_task.dart';
import 'package:flutter_projects/Widgets/archieved_tasks_widget.dart';
import 'package:flutter_projects/Widgets/high_priority_tasks_widget.dart';
import 'package:flutter_projects/Widgets/sliver_tasks_list_wiget.dart';
import 'package:flutter_projects/Widgets/tasks_list_wiget.dart';
import 'package:flutter_projects/core/services/preference_manger.dart';
import 'package:flutter_projects/core/widgets/custom_svg_wedget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  bool isCheck = false;
  List<TaskModel> tasks = [];
  bool is_loading = false;
  int totalTask = 0;
  int doneTask = 0;
  double percantege = 0;
  String? userImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadTasks();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    userImagePath = PreferenceManger().getString("image_profile");
  }

  void _loadUserName() async {
    setState(() {
      userName = PreferenceManger().getString("userName");
    });
  }

  void _loadTasks() async {
    setState(() {
      is_loading = true;
    });
    final finaltasks = PreferenceManger().getString("tasks");
    if (finaltasks != null) {
      final tasksDecode = jsonDecode(finaltasks) as List<dynamic>;

      setState(() {
        tasks = tasksDecode
            .map((elemnt) => TaskModel.formJson(elemnt))
            .toList();
        is_loading = false;
        _loadStatistic();
      });
    } else {
      setState(() {
        is_loading = false;
      });
    }
  }

  _doneTask(bool? value, int? index) async {
    setState(() {
      tasks[index!].isDone = value ?? false;
      _loadStatistic();
    });
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferenceManger().setString("tasks", jsonEncode(updatedTask));
  }

  _deleteTask(int id) async {
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      _loadStatistic();
    });
    final updated = tasks.map((_element) => _element.toJson()).toList();
    PreferenceManger().setString("tasks", jsonEncode(updated));
  }

  _loadStatistic() {
    totalTask = tasks.length;
    doneTask = tasks.where((e) => e.isDone).length;
    percantege = doneTask == 0 ? 0 : doneTask / totalTask;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: userImagePath == null ? AssetImage("assets/images/avatar.png") :
                        FileImage(File(userImagePath!)),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening ,$userName",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'One task at a time.One step closer.',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Yuhuu ,Your work Is ",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        "almost done ! ",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      CustomSvgWedget(
                        path:
                            "assets/images/waving-hand-medium-light-skin-tone-svgrepo-com 1.svg",
                        withFilter: false,
                      ),
                    ],
                  ),
                  ArchievedTasksWidget(
                    totalTask: totalTask,
                    doneTask: doneTask,
                    percantege: percantege,
                  ),
                  SizedBox(height: 8),
                  HighPriorityTasksWidget(
                    tasks: tasks,
                    OnTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    refresh: () {
                      _loadTasks();
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: Text(
                      "My Tasks",
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall!.copyWith(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            is_loading
                ? SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : SliverTasksListWiget(
                    tasks: tasks,
                    OnTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },

                    EmptyMessage: "No Data",
                    OnDelete: (int? id) {
                      _deleteTask(id!);
                    }, onEdit: ()=> _loadTasks(),
                  ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 40,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddTask();
                },
              ),
            );
            if (result != null && result) {
              _loadTasks();
            }
          },

          icon: Icon(Icons.add),
          label: Text("Add New Task"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
