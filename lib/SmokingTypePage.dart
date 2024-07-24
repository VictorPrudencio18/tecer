import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logintest/SmokingAttitudesPage.dart';

class SmokingTypePage extends StatefulWidget {
  @override
  _SmokingTypePageState createState() => _SmokingTypePageState();
}

class _SmokingTypePageState extends State<SmokingTypePage> {
  final _formKey = GlobalKey<FormState>();
  bool _usesFlavoredTobacco = false;
  String _flavoredTobaccoType = '';

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
                  'Tipo de Cigarro/Produto Tabaco que você usa',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  'Você utiliza produtos de tabaco com sabor? (Por exemplo: mentolado ou com sabor de frutas)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Sim'),
                        value: true,
                        groupValue: _usesFlavoredTobacco,
                        onChanged: (value) {
                          setState(() {
                            _usesFlavoredTobacco = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text('Não'),
                        value: false,
                        groupValue: _usesFlavoredTobacco,
                        onChanged: (value) {
                          setState(() {
                            _usesFlavoredTobacco = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (_usesFlavoredTobacco) ...[
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Especificar tipo de sabor',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _flavoredTobaccoType = value!;
                    },
                  ),
                ],
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _saveTypeData();
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SmokingAttitudesPage()),
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

  void _saveTypeData() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'usesFlavoredTobacco': _usesFlavoredTobacco,
        'flavoredTobaccoType': _flavoredTobaccoType.isNotEmpty ? _flavoredTobaccoType : null,
      }, SetOptions(merge: true));
    }
  }
}
