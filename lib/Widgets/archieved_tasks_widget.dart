import 'dart:math';

import 'package:flutter/material.dart';

class ArchievedTasksWidget extends StatelessWidget {
  const ArchievedTasksWidget({
    super.key,
    required this.totalTask,
    required this.doneTask,
    required this.percantege,
  });

  final int totalTask;

  final int doneTask;

  final double percantege;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Achieved Tasks",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 4),
                Text(
                  "$doneTask Out of $totalTask Done",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: -pi / 2,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      value: percantege,
                      valueColor: AlwaysStoppedAnimation(Color(0xff15B86C)),
                      backgroundColor: Color(0xff6D6D6D),
                      strokeWidth: 4,
                    ),
                  ),
                ),
                Text(
                  "${(percantege * 100).toInt()}%",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
