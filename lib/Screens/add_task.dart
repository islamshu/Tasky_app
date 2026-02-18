import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_projects/Models/task_model.dart';
import 'package:flutter_projects/core/services/preference_manger.dart';
import 'package:flutter_projects/core/widgets/custom_text_form_filed.dart';

class AddTask extends StatefulWidget {
  AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isHighPriority = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Task")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        CustomTextFormFiled(
                          lable: "Task Name",
                          controller: taskNameController,
                          isValid: true,
                          errorMessage: "Please Enter Task Name",
                          placeHolder: "Finish UI design for login screen",
                        ),

                        SizedBox(height: 20),

                        SizedBox(height: 8),
                        CustomTextFormFiled(
                          lable: "Task Description",
                          controller: taskDescriptionController,
                          isValid: false,
                          maxLines: 6,
                          placeHolder:
                              "Finish onboarding UI and hand off to devs by Thursday.",
                        ),

                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "High Priority  ",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Switch(
                              value: isHighPriority,
                              onChanged: (bool value) {
                                setState(() {
                                  isHighPriority = value;
                                });
                              },
                              // activeTrackColor: Color(0xFF15B86C),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_key.currentState?.validate() ?? false) {
                      final tasksJson = PreferenceManger().getString("tasks");
                      List<dynamic> listTask = [];
                      if (tasksJson != null) {
                        listTask = jsonDecode(tasksJson);
                      }
                      TaskModel model = TaskModel(
                        id: listTask.length + 1,
                        taskName: taskNameController.text,
                        taskDescription: taskDescriptionController.text,
                        isHighPriority: isHighPriority,
                      );

                      listTask.add(model.toJson());
                      final tasksEncode = jsonEncode(listTask);
                      await PreferenceManger().setString("tasks", tasksEncode);
                      // await pref.setString("tasks", tasksEncode);
                      Navigator.of(context).pop(true);
                      // await pref.setString("tasks", EncodeTask);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 40),
                  ),
                  label: Text("Add Task"),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
