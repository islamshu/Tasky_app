import 'package:flutter/material.dart';
import 'package:flutter_projects/Models/task_model.dart';
import 'package:flutter_projects/Screens/high_task_screen.dart';
import 'package:flutter_projects/core/themes/theme_controller.dart';
import 'package:flutter_projects/core/widgets/custom_checkbox.dart';
import 'package:flutter_projects/core/widgets/custom_svg_wedget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({
    super.key,
    required this.tasks,
    required this.OnTap,
    required this.refresh,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) OnTap;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "High Priority Tasks",
                    style: TextStyle(
                      color: Color(0xFF15B86C),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        tasks.reversed.where((e) => e.isHighPriority).length > 4
                        ? 4
                        : tasks.reversed.where((e) => e.isHighPriority).length,
                    itemBuilder: (BuildContext context, int index) {
                      final task = tasks.reversed
                          .where((e) => e.isHighPriority)
                          .toList()[index];

                      return Row(
                        children: [
                          CustomCheckbox(
                            value: task.isDone,
                            onChanged: (bool? value) {
                              final index = tasks.indexWhere(
                                (el) => el.id == task.id,
                              );
                              OnTap(value, index);
                            },
                          ),

                          Expanded(
                            child: Text(
                              task.taskName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: task.isDone
                                  ? Theme.of(context).textTheme.titleLarge
                                  : Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                final resutl = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext contect) {
                      return HighTaskScreen();
                    },
                  ),
                );
                refresh();
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 42,
                  height: 42,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: ThemeController.isDark() ? Color(0xff6E6E6E) :Color(0xffD1DAD6) ),
                  ),
                  child: CustomSvgWedget(path: "assets/images/arrow-up-right.svg"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
