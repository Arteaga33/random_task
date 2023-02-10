import 'package:flutter/material.dart';
import 'package:random_task/screens/create_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:random_task/screens/selected_task_screen.dart';

import '../widgets/tasks_overview.dart';
import '../widgets/app_drawer.dart';
import '../providers/tasks.dart';

class TaskOverviewScreen extends StatelessWidget {
  const TaskOverviewScreen({Key? key}) : super(key: key);

  Future<void> _refreshTasks(BuildContext context) async {
    try {
      await Provider.of<Tasks>(context, listen: false).fetchAndSetTasks();
    } catch (error) {
      print('the error is because: $error');
    } //If i delete this it actually show me near the code.
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = true;
    //Load task, pending loading indicator.
    try {//TODO: improve this code to show an indicator. properly.
      Provider.of<Tasks>(context, listen: false).fetchAndSetTasks();
      isLoading = false;
    } catch (error) {
      print(error);
    }

    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      title: const Text(
        'Random Task Selector',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Good',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              ' Luck',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
              SelectedTaskScreen.routeName,
              arguments: Provider.of<Tasks>(context, listen: false)
                  .randomTaskChooser()
                  .id),
          child: SizedBox(
            height: 50,
            child: Image.network(
              'https://www.pngrepo.com/png/50195/180/dice.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: myAppBar,
      drawer: const AppDrawer(),
      body: isLoading
          ? const CircularProgressIndicator()
          : RefreshIndicator(
              onRefresh: () => _refreshTasks(context),
              child: TasksOverview(
                appBarParentData: myAppBar,
                mediaQueryParentData: mediaQuery,
              ),
            ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(15),
        child: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(CreateTaskScreen.routeName);
          }, //Here goes the acction to add a new Task.
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
