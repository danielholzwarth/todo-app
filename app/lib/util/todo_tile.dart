import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;

  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(left: deviceSize.width * 0.05, top: deviceSize.width * 0.05, right: deviceSize.width * 0.05),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(12),
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Theme.of(context).colorScheme.error,
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(deviceSize.width * 0.03),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                checkColor: Theme.of(context).colorScheme.onPrimary,
              ),
              Text(
                taskName,
                style: TextStyle(
                  decoration: taskCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
