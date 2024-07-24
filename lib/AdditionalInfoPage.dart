import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logintest/LockedSectionPage.dart';

class AdditionalInfoPage extends StatefulWidget {
  @override
  _AdditionalInfoPageState createState() => _AdditionalInfoPageState();
}

class _AdditionalInfoPageState extends State<AdditionalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  bool _wantsMoreInfo = false;
  String _additionalComments = '';

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
                  'Informações Adicionais',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  'E então, você gostaria de receber mais informações ou apoio para parar de usar produtos do fumo?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Sim'),
                        value: true,
                        groupValue: _wantsMoreInfo,
                        onChanged: (value) {
                          setState(() {
                            _wantsMoreInfo = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Não'),
                        value: false,
                        groupValue: _wantsMoreInfo,
                        onChanged: (value) {
                          setState(() {
                            _wantsMoreInfo = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Enfim, acabamos! Tem mais alguma coisa que você gostaria de dizer para a gente?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Comentários adicionais',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  onChanged: (value) {
                    _additionalComments = value;
                  },
                  onSaved: (value) {
                    _additionalComments = value!;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _saveAdditionalInfo();
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LockedSectionPage()),
                    );
// Navegar para a próxima página ou finalizar
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

  void _saveAdditionalInfo() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'wantsMoreInfo': _wantsMoreInfo,
        'additionalComments': _additionalComments,
        'hasCompletedSurvey': true,
      }, SetOptions(merge: true));
    }
  }
}
