import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logintest/LockedSectionPage.dart'; // Importe a página LockedSectionPage

class DetailedSmokingSurveyPage extends StatefulWidget {
  final bool smokes;

  DetailedSmokingSurveyPage({required this.smokes});

  @override
  _DetailedSmokingSurveyPageState createState() => _DetailedSmokingSurveyPageState();
}

class _DetailedSmokingSurveyPageState extends State<DetailedSmokingSurveyPage> {
  final _formKey = GlobalKey<FormState>();
  bool? _wantsToQuit;
  bool? _hasSmokedBefore;
  String? _smokingType;
  String? _smokingFrequency;
  int? _smokingYears;
  List<String> _triggers = [];
  List<String> _customTriggers = [];
  final TextEditingController _triggerController = TextEditingController();
  final TextEditingController _customSmokingTypeController = TextEditingController();
  final List<String> _triggerOptions = ['Estresse', 'Álcool', 'Café', 'Trabalho', 'Seus amigos', 'Outros'];
  final List<String> _smokingTypeOptions = ['Cigarro comum', 'Cigarro de palha', 'Vape', 'Outro'];
  final TextEditingController _smokingYearsController = TextEditingController();
  bool _isOtherSelected = false;
  bool _isOtherSmokingTypeSelected = false;

  void _submitSurvey() async {
    if (_formKey.currentState!.validate()) {
      var user = FirebaseAuth.instance.currentUser;
      _triggers.addAll(_customTriggers); // Adiciona gatilhos personalizados à lista de gatilhos
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'smokes': widget.smokes,
        'wantsToQuit': _wantsToQuit,
        'hasSmokedBefore': widget.smokes ? null : _hasSmokedBefore,
        'smokingType': _isOtherSmokingTypeSelected ? _customSmokingTypeController.text.trim() : _smokingType,
        'smokingFrequency': _smokingFrequency,
        'smokingYears': _smokingYears,
        'triggers': _triggers,
        'hasCompletedSurvey': true,
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LockedSectionPage()),
      );
    }
  }

  void _addCustomTrigger() {
    final triggerText = _triggerController.text.trim();
    if (triggerText.isNotEmpty && !_customTriggers.contains(triggerText)) {
      setState(() {
        _customTriggers.add(triggerText);
        _triggerController.clear();
      });
    }
  }

  Widget _buildChip(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_triggers.contains(label)) {
            _triggers.remove(label);
            if (label == 'Outros') {
              _isOtherSelected = false;
            }
          } else {
            _triggers.add(label);
            if (label == 'Outros') {
              _isOtherSelected = true;
            }
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        margin: EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          color: _triggers.contains(label) ? Colors.deepPurple : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _triggers.contains(label) ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Questionário sobre Fumo"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 240, 240, 240),
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              if (!widget.smokes) ...[
                Text(
                  "Você já fumou antes?",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SwitchListTile(
                  title: Text("Sim"),
                  value: _hasSmokedBefore ?? false,
                  onChanged: (bool value) {
                    setState(() {
                      _hasSmokedBefore = value;
                    });
                  },
                ),
                SizedBox(height: 24),
              ],
              Text(
                "Você tem vontade de parar de fumar?",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SwitchListTile(
                title: Text("Sim"),
                value: _wantsToQuit ?? false,
                onChanged: (bool value) {
                  setState(() {
                    _wantsToQuit = value;
                  });
                },
              ),
              SizedBox(height: 24),
              Text(
                "Tipo de fumo:",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              DropdownButtonFormField<String>(
                value: _smokingType,
                items: _smokingTypeOptions.map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                )).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _smokingType = value;
                    _isOtherSmokingTypeSelected = value == 'Outro';
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tipo de fumo',
                ),
              ),
              if (_isOtherSmokingTypeSelected) ...[
                SizedBox(height: 16),
                TextFormField(
                  controller: _customSmokingTypeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Digite o tipo de fumo',
                  ),
                  validator: (value) {
                    if (_isOtherSmokingTypeSelected && (value == null || value.isEmpty)) {
                      return 'Por favor, insira o tipo de fumo';
                    }
                    return null;
                  },
                ),
              ],
              SizedBox(height: 16),
              Text(
                "Frequência de fumo:",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              DropdownButtonFormField<String>(
                value: _smokingFrequency,
                items: ['Diário', 'Semanal', 'Mensal']
                    .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _smokingFrequency = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Frequência de fumo',
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Há quanto tempo você fuma? (em anos)",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              TextFormField(
                controller: _smokingYearsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Anos fumando',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número de anos';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _smokingYears = int.tryParse(value);
                  });
                },
              ),
              SizedBox(height: 24),
              Text(
                "Quais são os gatilhos que fazem você querer fumar?",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              Wrap(
                spacing: 8.0,
                children: _triggerOptions.map((String trigger) {
                  return _buildChip(trigger);
                }).toList(),
              ),
              if (_isOtherSelected)
                TextField(
                  controller: _triggerController,
                  decoration: InputDecoration(
                    labelText: 'Digite outros gatilhos',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addCustomTrigger,
                    ),
                  ),
                  onSubmitted: (value) => _addCustomTrigger(),
                ),
              Wrap(
                spacing: 8.0,
                children: _customTriggers.map((trigger) => _buildChip(trigger)).toList(),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submitSurvey,
                child: Text("Enviar Respostas"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
