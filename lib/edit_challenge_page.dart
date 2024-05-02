import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditChallengePage extends StatefulWidget {
  final String challengeId;

  EditChallengePage({required this.challengeId});

  @override
  _EditChallengePageState createState() => _EditChallengePageState();
}

class _EditChallengePageState extends State<EditChallengePage> {
  final _formKey = GlobalKey<FormState>();
  // Defina controladores e variáveis para cada campo que será editado
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchChallengeDetails();
  }

  void fetchChallengeDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId).get();
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    _titleController.text = data['title'];
    _descriptionController.text = data['description'];
  }

  void saveChallengeDetails() async {
    if (_formKey.currentState!.validate()) {
      // Atualiza os detalhes no Firestore
      await FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Desafio atualizado com sucesso.')));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao atualizar o desafio: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Desafio'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveChallengeDetails,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
              validator: (value) => value!.isEmpty ? 'Este campo não pode ser vazio' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (value) => value!.isEmpty ? 'Este campo não pode ser vazio' : null,
            ),
            // Adicione mais campos conforme necessário
          ],
        ),
      ),
    );
  }
}
