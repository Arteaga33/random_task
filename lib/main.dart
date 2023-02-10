import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_task/screens/selected_task_screen.dart';

import './screens/create_task_screen.dart';
import './providers/tasks.dart';
import './screens/settings_screen.dart';
import './screens/tasks_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Tasks(),
        ),
      ],
      child: MaterialApp(
        title: 'Random Task Picker',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          fontFamily: 'Lato',
        ),
        home: const TaskOverviewScreen(),
        routes: {
          SettingsScreen.routeName: (context) => const SettingsScreen(),
          CreateTaskScreen.routeName:(context) => const CreateTaskScreen(),
          SelectedTaskScreen.routeName: (context) => const SelectedTaskScreen(),
        },
      ),
    );
  }
}
