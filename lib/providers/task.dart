import 'package:flutter/foundation.dart';

enum Priority {
  high,
  medium,
  low,
}

class Task with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  // final Priority priority;
  final Duration duration;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    // required this.priority,
    required this.duration,
    required this.dueDate,
  });
  
 
  // Priority definePriority(DateTime dueTime, int duration) {
  //   final Priority _priority;
  //   if (dueTime.minute > duration && dueTime.hour <= 24) {
  //     _priority = Priority.high;
  //     return _priority;
  //   }
  //   if (dueTime.minute > duration && dueTime.hour <= 72) { //the first condition must be change for an error.
  //     _priority = Priority.medium;
  //     return _priority;
  //   } else {
  //     _priority = Priority.low;
  //     return _priority;
  //   }
  // }
}
