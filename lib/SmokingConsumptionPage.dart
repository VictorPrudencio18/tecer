import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logintest/SmokingLocationsPage.dart';

class SmokingConsumptionPage extends StatefulWidget {
  @override
  _SmokingConsumptionPageState createState() => _SmokingConsumptionPageState();
}

class _SmokingConsumptionPageState extends State<SmokingConsumptionPage> {
  final _formKey = GlobalKey<FormState>();
  String _dailySmoking = '';
  String _dailyChewing = '';
  String _smokingWithOthers = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prevenção contra o Fumo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Text(
                  'Consumo Diário',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  'De novo, se você usa produtos do fumo, quantas vezes faz isso por dia?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('Não fumo'),
                      value: 'Não fumo',
                      groupValue: _dailySmoking,
                      onChanged: (value) {
                        setState(() {
                          _dailySmoking = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('1-5 vezes'),
                      value: '1-5 vezes',
                      groupValue: _dailySmoking,
                      onChanged: (value) {
                        setState(() {
                          _dailySmoking = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('6-10 vezes'),
                      value: '6-10 vezes',
                      groupValue: _dailySmoking,
                      onChanged: (value) {
                        setState(() {
                          _dailySmoking = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('11-20 vezes'),
                      value: '11-20 vezes',
                      groupValue: _dailySmoking,
                      onChanged: (value) {
                        setState(() {
                          _dailySmoking = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Mais de 20 vezes'),
                      value: 'Mais de 20 vezes',
                      groupValue: _dailySmoking,
                      onChanged: (value) {
                        setState(() {
                          _dailySmoking = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(),
                Text(
                  'Caso masque tabaco, quantas vezes masca tabaco por dia?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('Não masco'),
                      value: 'Não masco',
                      groupValue: _dailyChewing,
                      onChanged: (value) {
                        setState(() {
                          _dailyChewing = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('1-3 vezes'),
                      value: '1-3 vezes',
                      groupValue: _dailyChewing,
                      onChanged: (value) {
                        setState(() {
                          _dailyChewing = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('4-6 vezes'),
                      value: '4-6 vezes',
                      groupValue: _dailyChewing,
                      onChanged: (value) {
                        setState(() {
                          _dailyChewing = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('6-10 vezes'),
                      value: '6-10 vezes',
                      groupValue: _dailyChewing,
                      onChanged: (value) {
                        setState(() {
                          _dailyChewing = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Mais de 10 vezes'),
                      value: 'Mais de 10 vezes',
                      groupValue: _dailyChewing,
                      onChanged: (value) {
                        setState(() {
                          _dailyChewing = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(),
                Text(
                  'Então, se você usa produtos do fumo, faz isso sozinho ou com outras pessoas?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('Sempre sozinho'),
                      value: 'Sempre sozinho',
                      groupValue: _smokingWithOthers,
                      onChanged: (value) {
                        setState(() {
                          _smokingWithOthers = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Geralmente sozinho'),
                      value: 'Geralmente sozinho',
                      groupValue: _smokingWithOthers,
                      onChanged: (value) {
                        setState(() {
                          _smokingWithOthers = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Tanto sozinho quanto com outras pessoas'),
                      value: 'Tanto sozinho quanto com outras pessoas',
                      groupValue: _smokingWithOthers,
                      onChanged: (value) {
                        setState(() {
                          _smokingWithOthers = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Geralmente com outras pessoas'),
                      value: 'Geralmente com outras pessoas',
                      groupValue: _smokingWithOthers,
                      onChanged: (value) {
                        setState(() {
                          _smokingWithOthers = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Sempre com outras pessoas'),
                      value: 'Sempre com outras pessoas',
                      groupValue: _smokingWithOthers,
                      onChanged: (value) {
                        setState(() {
                          _smokingWithOthers = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _saveConsumptionData();
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SmokingLocationsPage()),
                      );
 // Navegar para a próxima página do questionário
                    }
                  },
                  child: Text(
                    'Enviar',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveConsumptionData() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'dailySmoking': _dailySmoking,
        'dailyChewing': _dailyChewing,
        'smokingWithOthers': _smokingWithOthers,
      }, SetOptions(merge: true));
    }
  }
}
