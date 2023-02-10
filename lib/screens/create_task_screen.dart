//Dos posibles soluciones:
//1. eliminar del todo el selector de duracion
//2. jugar con codigo asincronico para ver si guarda en _editedTask.

import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/task.dart';
import '../providers/tasks.dart';

class CreateTaskScreen extends StatefulWidget {
  static const routeName = '/create-task';
  const CreateTaskScreen({Key? key}) : super(key: key);

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _descriptionFocusNode = FocusNode();
  final _pickDateFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  DateTime? _selectedDate;
  TimeOfDay? _selectedHour;

  Task _editedTask = Task(
    //This represents an empty task.
    id: '-1',
    title: '',
    description: '',
    duration: Duration.zero,
    dueDate: DateTime.now(),
  );

  var _initValues = {
    'title': '',
    'description': '',
    'duedate': '',
    'duration': '',
  };

  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!_isInit && ModalRoute.of(context)?.settings.arguments != null) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;
      if (productId != null) {
        final existingTask =
            Provider.of<Tasks>(context, listen: false).findById(productId);
        _editedTask = existingTask;
        _initValues = {
          'title': _editedTask.title,
          'description': _editedTask.description,
          'duedate': _editedTask.dueDate.toString(), //I might get an error in here.
          'duration': _editedTask.duration.toString(),
        };
      }
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _pickDateFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();

    setState(() {
      _isLoading = true; //for the indicator.
    });

    if (isValid == false) {
      // print('Validate fields');
      _form.currentState?.save();
    } if(_editedTask.id != '-1' && isValid == true){
      // print('This is an existing product');
      Provider.of<Tasks>(context, listen: false).updateTask(_editedTask.id, _editedTask);
    }else if (isValid == true) {
      // print('Create new and load to database');

      _form.currentState?.save();

      // print('title: '+_editedTask.title);
      // print('description: '+_editedTask.description);
      // print('dueDate: ${_editedTask.dueDate}');
      // print('Duration: ${_editedTask.duration}');
      try {
        await Provider.of<Tasks>(context,
                listen:
                    false) //Alternative add await at the begining. and delete .then()
            .addNewTask(_editedTask);
      } catch (error) {
        return showDialog<Null>(
            //use return to give the future and execute code below. don't forget the <Null> change return for await in alternative.
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('An error ocurred!'),
                  content: const Text('Something went wrong.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Okay'))
                  ],
                ));
      } finally {
        Navigator.of(context).pop();
        _isLoading = false;
      }
    }
  }

  Future<void> _presentDatePicker() async {
    _descriptionFocusNode.unfocus();
    _selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));

    _selectedHour =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (_selectedDate != null && _selectedHour != null) {
      setState(() {
        _selectedDate = DateTime(_selectedDate!.year, _selectedDate!.month,
            _selectedDate!.day, _selectedHour!.hour, _selectedHour!.minute);
        _editedTask = Task(
            //Putting the dueDate
            id: _editedTask.id,
            title: _editedTask.title,
            description: _editedTask.description,
            duration: _editedTask.duration,
            dueDate: _selectedDate!);
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Task',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initValues['title'], 
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // //Saving the in the edited or new task.
                    // print('saved title: $value');
                    _editedTask = Task(
                        id: _editedTask.id,
                        title: value.toString(),
                        description: _editedTask.description,
                        duration: _editedTask.duration,
                        dueDate: _editedTask.dueDate);
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: const InputDecoration(labelText: 'Description'),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_pickDateFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a valid description.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    //Pending the saving Logic.
                    //Saving the in the edited or new task.
                    // print('saved description: $value');
                    _editedTask = Task(
                        id: _editedTask.id,
                        title: _editedTask.title,
                        description: value.toString(),
                        duration: _editedTask.duration,
                        dueDate: _editedTask.dueDate);
                  },
                  focusNode: _descriptionFocusNode,
                  onEditingComplete: () {
                    setState(() {});
                  },
                ),
                ElevatedButton(
                  focusNode: _pickDateFocusNode,
                  child: const Text(
                    'Due date',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _presentDatePicker,
                ),
                _selectedDate == null
                    ? const Center(child: Text('No date selected!'))
                    : Center(
                        child: Text(
                            DateFormat.yMMMMEEEEd().format(_selectedDate!) +
                                '  at: ' +
                                DateFormat.Hm().format(_selectedDate!))),
                const Divider(),
                const Text('Duration:'),
                DurationPicker(
                    duration: _editedTask.duration,
                    snapToMins: 10.0,
                    onChange: (selectedDuration) {
                      setState(() {
                        _editedTask = Task(
                            id: _editedTask.id,
                            title: _editedTask.title,
                            description: _editedTask.description,
                            duration: selectedDuration,
                            dueDate: _editedTask.dueDate);
                      });
                    })
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(15),
        child: FloatingActionButton(
          child: const Icon(Icons.save, color: Colors.white),
          onPressed: () {
            _saveForm();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
