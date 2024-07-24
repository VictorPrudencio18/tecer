import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logintest/SmokingExperiencePage.dart'; // Importe a nova página
import 'package:logintest/PreventionPage.dart';
import 'package:logintest/NonSmokerGoalsPage.dart';

class SmokingSurveyPage extends StatefulWidget {
  @override
  _SmokingSurveyPageState createState() => _SmokingSurveyPageState();
}

class _SmokingSurveyPageState extends State<SmokingSurveyPage> {
  final _formKey = GlobalKey<FormState>();
  String _age = '';
  String _gender = '';
  String _otherGender = '';
  String _education = '';
  String _otherEducation = '';

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/fumo.png',
                    height: 250,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Olá, tudo bem? Nós que fazemos o aplicativo TECER gostaríamos de fazer algumas perguntas e saber um pouco mais sobre você. Vocês não são obrigados a responder, mas sua resposta é muito importante para pensarmos em outras ações como esta. Ah! Lembrando que suas respostas são confidenciais e sigilosas, vocês não serão identificados. Contamos com a colaboração de vocês e vamos nos divertir aprendendo com o TECER!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 24),
                _buildAgeField(),
                SizedBox(height: 16),
                _buildGenderField(),
                if (_gender == 'Outro') ...[
                  SizedBox(height: 16),
                  _buildOtherGenderField(),
                ],
                SizedBox(height: 16),
                _buildEducationField(),
                if (_education == 'Outros') ...[
                  SizedBox(height: 16),
                  _buildOtherEducationField(),
                ],
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    child: Text(
                      'Próxima Etapa',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgeField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Então me fala, qual a sua idade?',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onSaved: (value) {
        _age = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira a idade';
        }
        if (int.tryParse(value) == null) {
          return 'Por favor, insira um número válido';
        }
        return null;
      },
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Sobre Sexo, como você se define?',
        border: OutlineInputBorder(),
      ),
      items: ['Masculino', 'Feminino', 'LGBTQIA+']
          .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _gender = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, selecione o sexo';
        }
        return null;
      },
    );
  }

  Widget _buildOtherGenderField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Especificar outro',
        border: OutlineInputBorder(),
      ),
      onSaved: (value) {
        _otherGender = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, especifique';
        }
        return null;
      },
    );
  }

  Widget _buildEducationField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Até que série você estudou?',
        border: OutlineInputBorder(),
      ),
      items: [
        'Ensino Fundamental',
        'Ensino Médio',
        'Ensino Superior',
        'Outros'
      ]
          .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _education = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, selecione o ano escolar';
        }
        return null;
      },
    );
  }

  Widget _buildOtherEducationField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Especificar outro',
        border: OutlineInputBorder(),
      ),
      onSaved: (value) {
        _otherEducation = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, especifique';
        }
        return null;
      },
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveSurveyData();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SmokingExperiencePage()), // Substitua pela próxima página do questionário
      );
    }
  }

  void _saveSurveyData() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'age': _age,
        'gender': _gender == 'Outro' ? _otherGender : _gender,
        'education': _education == 'Outros' ? _otherEducation : _education,
      }, SetOptions(merge: true));
    }
  }
}

