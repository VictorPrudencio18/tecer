import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditGoalPage extends StatefulWidget {
  final Map<String, dynamic> goalData;
  final int index;
  final Function(Map<String, dynamic>) onSave;

  EditGoalPage({required this.goalData, required this.index, required this.onSave});

  @override
  _EditGoalPageState createState() => _EditGoalPageState();
}

class _EditGoalPageState extends State<EditGoalPage> {
  late TextEditingController _customGoalController;
  late TextEditingController _descriptionController;
  late TextEditingController _rewardController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _customGoalController = TextEditingController(text: widget.goalData['goal']);
    _descriptionController = TextEditingController(text: widget.goalData['description']);
    _rewardController = TextEditingController(text: widget.goalData['reward']);
    _dateController = TextEditingController(text: widget.goalData['date'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.goalData['date'])) : '');
    _timeController = TextEditingController(text: widget.goalData['time'] ?? '');
    _selectedDate = widget.goalData['date'] != null ? DateTime.parse(widget.goalData['date']) : null;
    _selectedTime = widget.goalData['time'] != null ? TimeOfDay(
      hour: int.parse(widget.goalData['time'].split(":")[0]),
      minute: int.parse(widget.goalData['time'].split(":")[1].split(" ")[0]),
    ) : null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
        _timeController.text = _selectedTime!.format(context);
      });
  }

  void _saveGoal() {
    Map<String, dynamic> updatedGoal = {
      'goal': _customGoalController.text,
      'progress': widget.goalData['progress'],
      'description': _descriptionController.text,
      'reward': _rewardController.text,
      'date': _selectedDate != null ? _selectedDate!.toIso8601String() : null,
      'time': _selectedTime != null ? _selectedTime!.format(context) : null,
    };
    widget.onSave(updatedGoal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Meta'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(_customGoalController, 'Defina uma meta personalizada', Icons.edit),
            SizedBox(height: 20),
            _buildTextField(_descriptionController, 'Descrição da meta', Icons.description),
            SizedBox(height: 20),
            _buildTextField(_rewardController, 'Prêmio ao concluir a meta', Icons.card_giftcard),
            SizedBox(height: 20),
            _buildTextField(_dateController, 'Data da meta (opcional)', Icons.calendar_today, readOnly: true, onTap: () => _selectDate(context)),
            SizedBox(height: 20),
            _buildTextField(_timeController, 'Hora da meta (opcional)', Icons.access_time, readOnly: true, onTap: () => _selectTime(context)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGoal,
              child: Text('Salvar Meta', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label, IconData icon, {bool readOnly = false, VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(icon, color: Colors.black),
      ),
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
