import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _toggleVoice = true;
  var _highUrgency = true;
  var _mediumUrgency = true;
  var _lowUrgencency = true;

  Widget _buildSwitchListTile(
    String title,
    String description,
    bool currentValue,
    Function(bool newValue) updateValue,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(description),
      value: currentValue,
      onChanged: updateValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters and settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
      ),
      drawer: const AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text('Adjust your preferences, voice and tasks urgency.'),
          ),
          Expanded(
            child: ListView(
              children: [
                const Divider(),
                _buildSwitchListTile(
                    'Voice Notification.',
                    'Toggle the voice sound of selected task and configured timers.',
                    _toggleVoice, (newValue) {
                  setState(() {
                    _toggleVoice = newValue;
                  });
                }),
                const Divider(),
                _buildSwitchListTile(
                    'High Urgency.', 'Show high urgency tasks', _highUrgency,
                    (newValue) {
                  setState(() {
                    _highUrgency = newValue;
                  });
                }),
                const Divider(),
                _buildSwitchListTile('Medium Urgency.',
                    'Show medium urgency tasks', _mediumUrgency, (newValue) {
                  setState(() {
                    _mediumUrgency = newValue;
                  });
                }),
                const Divider(),
                _buildSwitchListTile('Medium Urgency.',
                    'Show low urgency tasks', _lowUrgencency, (newValue) {
                  setState(() {
                    _lowUrgencency = newValue;
                  });
                }),
                const Divider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
