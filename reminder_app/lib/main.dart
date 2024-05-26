import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReminderApp(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyText2: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

class ReminderApp extends StatefulWidget {
  @override
  _ReminderAppState createState() => _ReminderAppState();
}

class _ReminderAppState extends State<ReminderApp> {
  String _selectedDay = 'Monday';
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedActivity = 'Wake up';
  String _repetitionCycle = 'Daily';
  AudioCache _audioCache = AudioCache();

  final List<String> _daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  final List<String> _activities = [
    'Wake up',
    'Go to gym',
    'Breakfast',
    'Meetings',
    'Lunch',
    'Quick nap',
    'Go to library',
    'Dinner',
    'Go to sleep',
  ];

  final List<String> _repetitionCycles = [
    'Daily',
    'Weekly',
    'Monthly',
  ];

  @override
  void initState() {
    super.initState();
    // Load the audio file
    _audioCache.load('sound.mp3');
  }

  void _setReminder() {
    final now = DateTime.now();
    final reminderTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final formattedTime =
        "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}";

    // Implement logic to set reminder
    print(
        'Reminder set for $_selectedActivity on $_selectedDay at $formattedTime with repetition cycle: $_repetitionCycle');

    // Check if it's time for the reminder
    if (now.isAfter(reminderTime.subtract(Duration(minutes: 1))) &&
        now.isBefore(reminderTime.add(Duration(minutes: 1)))) {
      // Play alarm sound when the reminder time is up
      _audioCache.play('sound.mp3');

      // Show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Time for $_selectedActivity!'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reminder-App",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height - kToolbarHeight - 16.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.blue.shade300],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButton<String>(
                        value: _selectedDay,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedDay = newValue!;
                          });
                        },
                        items: _daysOfWeek
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(width: 8.0),
                                Text(
                                  value,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedTime = picked;
                            });
                          }
                        },
                        icon: Icon(Icons.access_time),
                        label: Text(
                          "Select Time: ${_selectedTime.format(context)}",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      DropdownButton<String>(
                        value: _selectedActivity,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedActivity = newValue!;
                          });
                        },
                        items: _activities
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(Icons.event),
                                SizedBox(width: 8.0),
                                Text(
                                  value,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.0),
                      DropdownButton<String>(
                        value: _repetitionCycle,
                        onChanged: (newValue) {
                          setState(() {
                            _repetitionCycle = newValue!;
                          });
                        },
                        items: _repetitionCycles
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(Icons.repeat),
                                SizedBox(width: 8.0),
                                Text(
                                  value,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _setReminder,
                        child: Text(
                          'Set Reminder',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
