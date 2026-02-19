import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_projects/Models/task_model.dart';
import 'package:flutter_projects/core/components/task_item_wedget.dart';
import 'package:flutter_projects/core/widgets/custom_checkbox.dart';

class SliverTasksListWiget extends StatelessWidget {
  SliverTasksListWiget({
    super.key,
    required this.tasks,
    required this.OnTap,
    required this.OnDelete,
    required this.onEdit,
    this.EmptyMessage,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) OnTap;
  final Function(int?) OnDelete;
  final Function onEdit;

  final String? EmptyMessage;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? SliverToBoxAdapter(
            child: Center(
              child: Text(
                EmptyMessage ?? "No data",
                style: Theme.of(
                  context,
                ).textTheme.displaySmall!.copyWith(fontSize: 20),
              ),
            ),
          )
        : SliverPadding(
            padding: EdgeInsetsGeometry.only(bottom: 45),
            sliver: SliverList.separated(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return TaskItemWedget(
                  model: tasks[index],
                  onChanged: (bool? value) {
                    OnTap(value, index);
                  },
                  onDelete: (int id) {
                    OnDelete(id);
                  },
                  onEdit: () => onEdit(),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 8);
              },
            ),
          );
  }
}
