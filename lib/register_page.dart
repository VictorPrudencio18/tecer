import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPageStep1 extends StatefulWidget {
  @override
  _RegisterPageStep1State createState() => _RegisterPageStep1State();
}

class _RegisterPageStep1State extends State<RegisterPageStep1> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _registerStep1() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text, password: _passwordController.text);
        // Redirecionamento para a Etapa 2 com o UID do usuário
        Navigator.of(context).pushNamed('/registerStep2',
            arguments: userCredential.user!.uid);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Falha no registro: ${e.message}"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register - Step 1', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'example@email.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@'))
                    return 'Digite um email válido';
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6)
                    return 'A senha precisa ter no mínimo 6 caracteres';
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _registerStep1,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text('Continue to Step 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
