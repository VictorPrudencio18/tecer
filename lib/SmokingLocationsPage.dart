import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logintest/SmokingTypePage.dart';

class SmokingLocationsPage extends StatefulWidget {
  @override
  _SmokingLocationsPageState createState() => _SmokingLocationsPageState();
}

class _SmokingLocationsPageState extends State<SmokingLocationsPage> {
  final _formKey = GlobalKey<FormState>();
  List<String> _smokingLocations = [];
  bool _hasRestrictedPlace = false;
  String _restrictedPlace = '';
  String _otherLocation = '';

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
                  'Locais de Consumo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  'E se você usa produtos do fumo, onde costuma usar? (Pode marcar todas as opções que você desejar) ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                CheckboxListTile(
                  title: Text('Em casa'),
                  value: _smokingLocations.contains('Em casa'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Em casa');
                  },
                ),
                CheckboxListTile(
                  title: Text('Na casa de amigos'),
                  value: _smokingLocations.contains('Na casa de amigos'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Na casa de amigos');
                  },
                ),
                CheckboxListTile(
                  title: Text('Na escola/faculdade'),
                  value: _smokingLocations.contains('Na escola/faculdade'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Na escola/faculdade');
                  },
                ),
                CheckboxListTile(
                  title: Text('Em festas/eventos sociais'),
                  value: _smokingLocations.contains('Em festas/eventos sociais'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Em festas/eventos sociais');
                  },
                ),
                CheckboxListTile(
                  title: Text('Em locais públicos (parques, ruas, etc.)'),
                  value: _smokingLocations.contains('Em locais públicos (parques, ruas, etc.)'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Em locais públicos (parques, ruas, etc.)');
                  },
                ),
                CheckboxListTile(
                  title: Text('Outros'),
                  value: _smokingLocations.contains('Outros'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Outros');
                    if (value == false) {
                      _otherLocation = '';
                    }
                  },
                ),
                if (_smokingLocations.contains('Outros'))
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Especificar outro',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _otherLocation = value;
                    },
                    onSaved: (value) {
                      _otherLocation = value!;
                    },
                  ),
                SizedBox(height: 16),
                Divider(),
                Text(
                  'Outra coisa, existe algum lugar onde você gostaria de usar produtos do fumo, mas não o faz por causa das proibições?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Sim'),
                        value: true,
                        groupValue: _hasRestrictedPlace,
                        onChanged: (value) {
                          setState(() {
                            _hasRestrictedPlace = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Não'),
                        value: false,
                        groupValue: _hasRestrictedPlace,
                        onChanged: (value) {
                          setState(() {
                            _hasRestrictedPlace = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (_hasRestrictedPlace) ...[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Especificar local',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _restrictedPlace = value;
                    },
                    onSaved: (value) {
                      _restrictedPlace = value!;
                    },
                  ),
                ],
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _saveLocationsData();
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SmokingTypePage()),
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

  void _onCheckboxChanged(bool? value, String location) {
    setState(() {
      if (value == true) {
        _smokingLocations.add(location);
      } else {
        _smokingLocations.remove(location);
      }
    });
  }

  void _saveLocationsData() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (_smokingLocations.contains('Outros') && _otherLocation.isNotEmpty) {
        _smokingLocations.add(_otherLocation);
      }
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'smokingLocations': _smokingLocations,
        'hasRestrictedPlace': _hasRestrictedPlace,
        'restrictedPlace': _restrictedPlace,
      }, SetOptions(merge: true));
    }
  }
}
