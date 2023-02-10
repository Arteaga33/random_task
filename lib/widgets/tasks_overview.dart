import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';
import '../widgets/single_task.dart';

class TasksOverview extends StatelessWidget {
  final AppBar appBarParentData;
  final MediaQueryData mediaQueryParentData;

  const TasksOverview({required this.appBarParentData, required this.mediaQueryParentData, Key? key}) : super (key:key);
  

  @override
  Widget build(BuildContext context) {
    final taskData = Provider.of<Tasks>(context);

    final tasksList = taskData.allTask;

    double calculateDynamicHeight(AppBar appBar, MediaQueryData mediaQuery) {
      //To use all of the available space:
      return (mediaQuery.size.height -
          appBar.preferredSize.height -
          mediaQuery.padding.top);
    }

    return SizedBox(
      height: calculateDynamicHeight(appBarParentData, mediaQueryParentData),
      child: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: tasksList[index],
          child: SingleTask(tasksList[index], null),
        ),
        itemCount: tasksList.length,
      ),
    );
  }
}
