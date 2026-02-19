import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_projects/Models/task_model.dart';
import 'package:flutter_projects/core/components/task_item_wedget.dart';
import 'package:flutter_projects/core/widgets/custom_checkbox.dart';

class TasksListWiget extends StatelessWidget {
  TasksListWiget({
    super.key,
    required this.tasks,
    required this.OnTap,
    required this.OnDelete,
    required this.onEdit,
    this.EmptyMessage,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) OnTap;
  final Function( int?) OnDelete;
  final Function onEdit ;

  final String? EmptyMessage;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              EmptyMessage ?? "No data",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 25),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: tasks.length,
                padding: EdgeInsets.only(bottom: 50),
                itemBuilder: (BuildContext context, int index) {
                  return TaskItemWedget(
                    model: tasks[index],
                    onChanged: (bool? value) {
                      OnTap(value, index);
                    }, onDelete: (int id) {
                    OnDelete(id);
                  }, onEdit:()=>onEdit(),

                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 8);
                },
              ),
            ],
          );
  }
}
