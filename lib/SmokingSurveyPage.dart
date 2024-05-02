import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logintest/LockedSectionPage.dart';// Importe a página LockedSectionPage

class SmokingSurveyPage extends StatefulWidget {
  @override
  _SmokingSurveyPageState createState() => _SmokingSurveyPageState();
}

class _SmokingSurveyPageState extends State<SmokingSurveyPage> {
  final _formKey = GlobalKey<FormState>();
  bool? _smokes;
  bool? _wantsToQuit;
  bool? _hasSmokedBefore;
  List<String> _triggers = [];
  List<String> _customTriggers = [];
  final TextEditingController _triggerController = TextEditingController();
  final List<String> _triggerOptions = ['Estresse', 'Álcool', 'Café', 'Trabalho', 'Seus amigos', 'Outros'];
  bool _isOtherSelected = false;

  void _submitSurvey() async {
    if (_formKey.currentState!.validate()) {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'smokes': _smokes,
        'wantsToQuit': _wantsToQuit,
        'hasSmokedBefore': _hasSmokedBefore,
        'triggers': _triggers,
        'customTriggers': _customTriggers,
        'hasCompletedSurvey': true,
      }); // Handle completion and errors as needed
      // Navegue para a página LockedSectionPage após enviar o questionário
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LockedSectionPage()), // Página de destino após enviar o questionário
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
        title: Text(
          "Questionário sobre Fumo",
          style: TextStyle(color: Colors.white), // Mudando a cor do texto do AppBar para branco
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 255, 255, 255), // Cor de fundo mais clara
              const Color.fromARGB(255, 240, 240, 240), // Cor de fundo mais escura
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              Text(
                "Você fuma atualmente?",
                style: TextStyle(fontSize: 18, color: Colors.black), // Mudando a cor do texto para preto
              ),
              SwitchListTile(
                title: Text("Sim"),
                value: _smokes ?? false,
                onChanged: (bool value) {
                  setState(() {
                    _smokes = value;
                  });
                },
              ),
              Text(
                "Você tem vontade de parar de fumar?",
                style: TextStyle(fontSize: 18, color: Colors.black), // Mudando a cor do texto para preto
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
              Text(
                "Você já fumou antes?",
                style: TextStyle(fontSize: 18, color: Colors.black), // Mudando a cor do texto para preto
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
              Text(
                "Quais são os gatilhos que fazem você querer fumar?",
                style: TextStyle(fontSize: 18, color: Colors.black), // Mudando a cor do texto para preto
              ),
              Wrap(
                spacing: 8.0,
                children: _triggerOptions.map((String trigger) {
                  return _buildChip(trigger);
                }).toList(),
              ),
              // Campo de entrada para gatilhos personalizados
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
              // Exibição de gatilhos personalizados como chips
              Wrap(
                spacing: 8.0,
                children: _customTriggers.map((trigger) => _buildChip(trigger)).toList(),
              ),
              SizedBox(height: 12), // Adicionando espaço entre os chips e o botão de enviar respostas
              // Botão para enviar as respostas do questionário
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
