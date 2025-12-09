import 'dart:convert';
import 'package:flutter/material.dart';

class LogMeetingScreen extends StatefulWidget {
  const LogMeetingScreen({super.key});

  @override
  State<LogMeetingScreen> createState() => _LogMeetingScreenState();
}

class _LogMeetingScreenState extends State<LogMeetingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Use a map to store form data for easy JSON conversion
  final Map<String, dynamic> _formData = {
    'date': DateTime.now().toIso8601String(),
    'time': TimeOfDay.now().format(Constants.rootContext ??  Constants.navigatorKey.currentContext!), // Will fix context usage below
    'location': '',
    'topic': null,
    'attendees': <String>[],
  };
  
  // NOTE: TimeOfDay.format needs a context. We will handle time formatting properly in the logic.
  // Let's store raw objects and convert on submit.
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  String? _selectedTopic;
  final List<String> _topics = [
    'The Gospel',
    'Prayer',
    'Discipleship',
    'Evangelism',
    'Stewardship',
    'Dating & Courtship',
  ];

  final List<String> _dummyDisciples = [
    "John",
    "Mark",
    "Luke",
    "Matthew",
    "Peter",
    "Paul",
    "Timothy",
    "Barnabas"
  ];
  
  final Set<String> _selectedAttendees = {};

  @override
  void initState() {
    super.initState();
    _updateDateText();
    _updateTimeText();
  }

  void _updateDateText() {
    // Simple formatting YYYY-MM-DD
    _dateController.text = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
  }

  void _updateTimeText() {
      // We need context to format TimeOfDay with local settings, but in initState/early logic it's safer to just set it later or use a simple formatter.
      // We will update this in build or just use a helper that doesn't rely strictly on localized Material context if not ready.
      // But actually, updateTimeText called from `pickTime` will have context available.
      // For InitState, we'll wait for the first build or just delay.
      // Actually simpler: just don't set text here, set it in the build or use a late initializer that is safe.
      // Let's just do a simple 24h format for default init to be safe, or wait.
      final hour = _selectedTime.hour.toString().padLeft(2, '0');
      final minute = _selectedTime.minute.toString().padLeft(2, '0');
      _timeController.text = "$hour:$minute";
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateText();
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final submissionData = {
        'date': _selectedDate.toIso8601String(),
        'time': "${_selectedTime.hour}:${_selectedTime.minute}",
        'location': _locationController.text,
        'topic': _selectedTopic,
        'attendees': _selectedAttendees.toList(),
      };

      debugPrint(jsonEncode(submissionData));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report Submitted! Check console.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure time text is formatted correctly on first build if it wasn't
    if (_timeController.text.isEmpty) {
       _timeController.text = _selectedTime.format(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log DNG Meeting'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Picker
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () => _pickDate(context),
              ),
              const SizedBox(height: 16),

              // Time Picker
              TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                onTap: () => _pickTime(context),
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g. Starbucks, Church Hall',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Lesson Topic
              DropdownButtonFormField<String>(
                value: _selectedTopic,
                decoration: const InputDecoration(
                  labelText: 'Lesson Topic',
                  border: OutlineInputBorder(),
                ),
                items: _topics.map((topic) {
                  return DropdownMenuItem(
                    value: topic,
                    child: Text(topic),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTopic = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a topic';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Attendees Label
              Text(
                'Attendees',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              // Attendees Multi-Select
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _dummyDisciples.map((disciple) {
                  final isSelected = _selectedAttendees.contains(disciple);
                  return FilterChip(
                    label: Text(disciple),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedAttendees.add(disciple);
                        } else {
                          _selectedAttendees.remove(disciple);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Submit Button
              FilledButton( // Material 3 FilledButton
                onPressed: _submitForm,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Submit Report',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Constants {
    // Fallback for valid context if we needed it in static methods, 
    // but we removed the strict dependency from the initializer list 
    // so this is just a leftover thought pattern, removing from actual usage.
    static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    static BuildContext? get rootContext => navigatorKey.currentContext;
}
