import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logintest/AdditionalInfoPage.dart';

class SmokingAttitudesPage extends StatefulWidget {
  @override
  _SmokingAttitudesPageState createState() => _SmokingAttitudesPageState();
}

class _SmokingAttitudesPageState extends State<SmokingAttitudesPage> {
  final _formKey = GlobalKey<FormState>();
  List<String> _reasonsForSmoking = [];
  String _quittingDesire = '';
  bool _hasTriedToQuit = false;
  List<String> _quitMethods = [];
  String _otherReason = '';
  String _otherQuitMethod = '';

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
                  'Percepções e Atitudes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  'E sobre a razão para usar produtos do fumo? (Pode marcar todas as opções que você desejar)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                CheckboxListTile(
                  title: Text('Para relaxar'),
                  value: _reasonsForSmoking.contains('Para relaxar'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Para relaxar', _reasonsForSmoking);
                  },
                ),
                CheckboxListTile(
                  title: Text('Para socializar'),
                  value: _reasonsForSmoking.contains('Para socializar'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Para socializar', _reasonsForSmoking);
                  },
                ),
                CheckboxListTile(
                  title: Text('Por hábito'),
                  value: _reasonsForSmoking.contains('Por hábito'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Por hábito', _reasonsForSmoking);
                  },
                ),
                CheckboxListTile(
                  title: Text('Para lidar com o estresse'),
                  value: _reasonsForSmoking.contains('Para lidar com o estresse'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Para lidar com o estresse', _reasonsForSmoking);
                  },
                ),
                CheckboxListTile(
                  title: Text('Curiosidade'),
                  value: _reasonsForSmoking.contains('Curiosidade'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Curiosidade', _reasonsForSmoking);
                  },
                ),
                CheckboxListTile(
                  title: Text('Outros'),
                  value: _reasonsForSmoking.contains('Outros'),
                  onChanged: (bool? value) {
                    _onCheckboxChanged(value, 'Outros', _reasonsForSmoking);
                    if (value == false) {
                      _otherReason = '';
                    }
                  },
                ),
                if (_reasonsForSmoking.contains('Outros'))
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Especificar outro',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _otherReason = value;
                    },
                    onSaved: (value) {
                      _otherReason = value!;
                    },
                  ),
                SizedBox(height: 16),
                Divider(),
                Text(
                  'Já estamos quase terminando, mas me conta, você gostaria de parar de usar estes produtos?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('Sim, imediatamente'),
                      value: 'Sim, imediatamente',
                      groupValue: _quittingDesire,
                      onChanged: (value) {
                        setState(() {
                          _quittingDesire = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Sim, mas não estou pronto agora'),
                      value: 'Sim, mas não estou pronto agora',
                      groupValue: _quittingDesire,
                      onChanged: (value) {
                        setState(() {
                          _quittingDesire = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Não tenho certeza'),
                      value: 'Não tenho certeza',
                      groupValue: _quittingDesire,
                      onChanged: (value) {
                        setState(() {
                          _quittingDesire = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Não'),
                      value: 'Não',
                      groupValue: _quittingDesire,
                      onChanged: (value) {
                        setState(() {
                          _quittingDesire = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(),
                Text(
                  'Eu gostaria de saber: você já tentou parar?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Sim'),
                        value: true,
                        groupValue: _hasTriedToQuit,
                        onChanged: (value) {
                          setState(() {
                            _hasTriedToQuit = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Não'),
                        value: false,
                        groupValue: _hasTriedToQuit,
                        onChanged: (value) {
                          setState(() {
                            _hasTriedToQuit = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (_hasTriedToQuit) ...[
                  Text(
                    'Se tentou, me fala, o que você fez para parar? (Pode marcar todas as opções que você desejar)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    title: Text('Sem ajuda (tentativa própria)'),
                    value: _quitMethods.contains('Sem ajuda (tentativa própria)'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Sem ajuda (tentativa própria)', _quitMethods);
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Adesivos de nicotina'),
                    value: _quitMethods.contains('Adesivos de nicotina'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Adesivos de nicotina', _quitMethods);
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Gomas de nicotina'),
                    value: _quitMethods.contains('Gomas de nicotina'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Gomas de nicotina', _quitMethods);
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Medicamentos prescritos'),
                    value: _quitMethods.contains('Medicamentos prescritos'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Medicamentos prescritos', _quitMethods);
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Grupos de apoio'),
                    value: _quitMethods.contains('Grupos de apoio'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Grupos de apoio', _quitMethods);
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Outros'),
                    value: _quitMethods.contains('Outros'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Outros', _quitMethods);
                      if (value == false) {
                        _otherQuitMethod = '';
                      }
                    },
                  ),
                  if (_quitMethods.contains('Outros'))
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Especificar outro',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _otherQuitMethod = value;
                      },
                      onSaved: (value) {
                        _otherQuitMethod = value!;
                      },
                    ),
                ],
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _saveAttitudesData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdditionalInfoPage()),
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
  void _onCheckboxChanged(bool? value, String option, List<String> list) {
    setState(() {
      if (value == true) {
        list.add(option);
      } else {
        list.remove(option);
      }
    });
  }

  void _saveAttitudesData() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (_reasonsForSmoking.contains('Outros') && _otherReason.isNotEmpty) {
        _reasonsForSmoking.add(_otherReason);
      }
      if (_quitMethods.contains('Outros') && _otherQuitMethod.isNotEmpty) {
        _quitMethods.add(_otherQuitMethod);
      }
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'reasonsForSmoking': _reasonsForSmoking,
        'quittingDesire': _quittingDesire,
        'hasTriedToQuit': _hasTriedToQuit,
        'quitMethods': _quitMethods,
      }, SetOptions(merge: true));
    }
  }
}
