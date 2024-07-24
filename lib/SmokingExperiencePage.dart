import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logintest/SmokingConsumptionPage.dart';
import 'package:logintest/NonSmokerGoalsPage.dart';

class SmokingExperiencePage extends StatefulWidget {
  @override
  _SmokingExperiencePageState createState() => _SmokingExperiencePageState();
}

class _SmokingExperiencePageState extends State<SmokingExperiencePage> {
  final _formKey = GlobalKey<FormState>();
  bool _triedSmoking = false;
  String _firstTriedAge = '';
  List<String> _frequentTypes = [];
  String _preferredBrand = '';
  String _currentFrequency = '';

  final TextEditingController _firstTriedAgeController = TextEditingController();
  final TextEditingController _preferredBrandController = TextEditingController();
  final TextEditingController _otherTypeController = TextEditingController();

  @override
  void dispose() {
    _firstTriedAgeController.dispose();
    _preferredBrandController.dispose();
    _otherTypeController.dispose();
    super.dispose();
  }

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
                  'Experiências com Fumo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  'Me conta, se você já experimentou algum(uns) destes produtos do fumo: cigarro tradicional, fumo mascado, cachimbo, charuto, cigarro eletrônico, narguilé, fumo de enrolar ou rapé.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Sim'),
                        value: true,
                        groupValue: _triedSmoking,
                        onChanged: (value) {
                          setState(() {
                            _triedSmoking = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Não'),
                        value: false,
                        groupValue: _triedSmoking,
                        onChanged: (value) {
                          setState(() {
                            _triedSmoking = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (_triedSmoking) ...[
                  SizedBox(height: 16),
                  Text(
                    'Caso já tenha experimentado, com qual idade você fez isso pela primeira vez?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _firstTriedAgeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _firstTriedAge = value!;
                    },
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  Text(
                    'Vamos lá, caso você faça uso de produtos do fumo, qual é o tipo que você mais usa? (Pode marcar todas as opções que você desejar)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    title: Text('Cigarro tradicional'),
                    value: _frequentTypes.contains('Cigarro tradicional'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Cigarro tradicional');
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Cigarro eletrônico'),
                    value: _frequentTypes.contains('Cigarro eletrônico'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Cigarro eletrônico');
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Narguilé'),
                    value: _frequentTypes.contains('Narguilé'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Narguilé');
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Charuto'),
                    value: _frequentTypes.contains('Charuto'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Charuto');
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Fumo de enrolar'),
                    value: _frequentTypes.contains('Fumo de enrolar'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Fumo de enrolar');
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Masco fumo'),
                    value: _frequentTypes.contains('Masco fumo'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Masco fumo');
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Rapé'),
                    value: _frequentTypes.contains('Rapé'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Rapé');
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Outros'),
                    value: _frequentTypes.contains('Outros'),
                    onChanged: (bool? value) {
                      _onCheckboxChanged(value, 'Outros');
                    },
                  ),
                  if (_frequentTypes.contains('Outros'))
                    TextFormField(
                      controller: _otherTypeController,
                      decoration: InputDecoration(
                        labelText: 'Especificar outro',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _frequentTypes.add(value!);
                      },
                    ),
                  SizedBox(height: 16),
                  Divider(),
                  Text(
                    'Falando de produtos do fumo, qual a sua marca preferida?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _preferredBrandController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _preferredBrand = value!;
                    },
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  Text(
                    'Me conta, se você usa produtos do fumo, qual a frequência atualmente?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: [
                      RadioListTile<String>(
                        title: Text('Nunca usei'),
                        value: 'Nunca usei',
                        groupValue: _currentFrequency,
                        onChanged: (value) {
                          setState(() {
                            _currentFrequency = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Já experimentei, mas não uso atualmente'),
                        value: 'Já experimentei, mas não uso atualmente',
                        groupValue: _currentFrequency,
                        onChanged: (value) {
                          setState(() {
                            _currentFrequency = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Uso ocasionalmente (menos de uma vez por semana)'),
                        value: 'Uso ocasionalmente (menos de uma vez por semana)',
                        groupValue: _currentFrequency,
                        onChanged: (value) {
                          setState(() {
                            _currentFrequency = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Uso regularmente (pelo menos uma vez por semana)'),
                        value: 'Uso regularmente (pelo menos uma vez por semana)',
                        groupValue: _currentFrequency,
                        onChanged: (value) {
                          setState(() {
                            _currentFrequency = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Uso diariamente'),
                        value: 'Uso diariamente',
                        groupValue: _currentFrequency,
                        onChanged: (value) {
                          setState(() {
                            _currentFrequency = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _saveExperienceData();
                      if (_triedSmoking) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SmokingConsumptionPage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NonSmokerGoalsPage()),
                        );
                      }
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

  void _onCheckboxChanged(bool? value, String type) {
    setState(() {
      if (value == true) {
        _frequentTypes.add(type);
      } else {
        _frequentTypes.remove(type);
      }
    });
  }

  void _saveExperienceData() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'triedSmoking': _triedSmoking,
        'firstTriedAge': _firstTriedAgeController.text,
        'frequentTypes': _frequentTypes,
        'preferredBrand': _preferredBrandController.text,
        'currentFrequency': _currentFrequency,
        if (!_triedSmoking) 'hasCompletedSurvey': true,
      }, SetOptions(merge: true));
    }
  }
}
