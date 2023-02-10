import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_task/screens/create_task_screen.dart';

import '../providers/task.dart';
import '../providers/tasks.dart';

class SingleTask extends StatelessWidget {
  final Task singleTask;

  const SingleTask(this.singleTask, Key? key) : super (key:key);

  @override
  Widget build(BuildContext context) {
  final allTask = Provider.of<Tasks>(context, listen: false);

    return Card(
      elevation: 7,
      margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
      child: SizedBox(
        height: 80,
        child: ListTile(
          leading: const SizedBox(
            height: 80,
            width: 20,
            child: Icon(Icons.task_outlined),
          ),
          title: Text(singleTask.title),
          subtitle: SizedBox(
            height: 50,
            child: SingleChildScrollView(
              child: Text(singleTask.description),
            ),
          ),
          trailing:
              SizedBox(
                width: 100,//Can be inprove dynamically
                child: Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.of(context).pushNamed(CreateTaskScreen.routeName, arguments: singleTask.id);
                    }, icon: const Icon(Icons.edit)),
                    IconButton(onPressed: () {
                      print(singleTask.id);
                      allTask.removeTaskById(singleTask.id);
                    }, icon: Icon(Icons.delete, color: Theme.of(context).errorColor,)),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
