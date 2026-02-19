import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_projects/Models/task_model.dart';
import 'package:flutter_projects/core/enums/task_item_actions_enum.dart';
import 'package:flutter_projects/core/services/preference_manger.dart';
import 'package:flutter_projects/core/themes/theme_controller.dart';
import 'package:flutter_projects/core/widgets/custom_checkbox.dart';
import 'package:flutter_projects/core/widgets/custom_text_form_filed.dart';

class TaskItemWedget extends StatelessWidget {
  const TaskItemWedget({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,

  });

  final TaskModel model;
  final Function(bool?) onChanged;
  final Function(int) onDelete;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: !ThemeController.isDark()
              ? Color(0xFFD1DAD6)
              : Colors.transparent,
        ),
      ),

      child: Row(
        children: [
          SizedBox(width: 8),
          CustomCheckbox(
            value: model.isDone,
            onChanged: (bool? value) {
              onChanged(value);
            },
          ),

          SizedBox(width: 16),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.taskName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: model.isDone
                      ? Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      : Theme
                      .of(context)
                      .textTheme
                      .titleMedium,
                ),
                if (model.taskDescription.isNotEmpty)
                  Text(
                    model.taskDescription,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: model.isDone
                        ? Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                        : Theme
                        .of(context)
                        .textTheme
                        .titleSmall,
                  ),
              ],
            ),
          ),
          PopupMenuButton<TaskItemActionsEnum>(
            icon: Icon(
              Icons.more_vert,
              color: ThemeController.isDark()
                  ? (model.isDone ? Color(0xFFA0A0A0) : Color(0xFFFFFCFC))
                  : (!model.isDone ? Color(0xFF3A4640) : Color(0xFF6A6A6A)),
            ),
            onSelected: (value) async {
              switch (value) {
                case TaskItemActionsEnum.markAsdone:
                  onChanged(!model.isDone);
                case TaskItemActionsEnum.edit:
                final resutl =   await _showButtonSheet(context, model);
                if(resutl == true){
                  onEdit();
                }
                case TaskItemActionsEnum.delete:
                  _showAlertDialog(context);
              }
            },
            itemBuilder: (context) =>
            [
              ...TaskItemActionsEnum.values.map(
                    (e) => PopupMenuItem(child: Text(e.name), value: e),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String?> _showAlertDialog(context) {
    final TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormFiled(
                lable: "text",
                controller: controller,
                isValid: true,
                errorMessage: "you need to show this",
              ),
              Text('Are you sure to delete this task'),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onDelete(model.id);
                Navigator.pop(context);
              },
              child: Text("Delete"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showButtonSheet(BuildContext context, TaskModel model) {
    TextEditingController textController =
    TextEditingController(text: model.taskName);

    TextEditingController descriptionController =
    TextEditingController(text: model.taskDescription);

    final _key = GlobalKey<FormState>();
    bool isHighPriority = model.isHighPriority;

    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // isScrollControlled: true, // سطر مهم
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) setState) {
            return Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // مهم
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 8),

                    CustomTextFormFiled(
                      lable: "Task Name",
                      controller: textController,
                      isValid: true,
                      errorMessage: "Please Enter Task Name",
                      placeHolder: "Finish UI design for login screen",
                    ),

                    SizedBox(height: 20),

                    CustomTextFormFiled(
                      lable: "Task Description",
                      controller: descriptionController,
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
                          "High Priority",
                          style:Theme.of(context).textTheme.titleMedium,
                        ),
                        Switch(
                          value: isHighPriority,
                          onChanged: (bool value) {
                            setState(() {
                              isHighPriority = value;
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 40),

                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_key.currentState?.validate() ?? false) {
                          final taskJson = PreferenceManger().getString(
                              "tasks");
                          List<dynamic> list = [];
                          if (taskJson != null) {
                            list = jsonDecode(taskJson);
                          }
                          TaskModel newModel = TaskModel(
                              id: model.id,
                              taskName: textController.text,
                              taskDescription:  descriptionController.text,
                              isHighPriority: isHighPriority,
                              isDone :model.isDone
                          );
                          
                         final task = list.firstWhere((e)=>e["id"] == model.id);
                         final int index = list.indexOf(task);
                         list[index]=newModel;
                         final taskEncode = jsonEncode(list);
                         await PreferenceManger().setString("tasks", taskEncode);
                          Navigator.pop(context,true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40),
                      ),
                      label: Text("Edit Task"),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

