
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_user_model.dart';

class AdminDetailsPage extends StatelessWidget {
  final AdminUserModel admin;

  AdminDetailsPage({required this.admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil do Administrador"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, admin),
            _buildInfoGrid(context, admin),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AdminUserModel admin) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(admin.photoUrl),
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            admin.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            admin.surname,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 16), // Ajuste o espaçamento conforme necessário
        ],
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context, AdminUserModel admin) {
    // Usando ListTile para manter a consistência e simplicidade
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.cake),
            title: Text("Idade"),
            subtitle: Text("${admin.age} Anos"),
          ),
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text("Cidade"),
            subtitle: Text(admin.city),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Gênero"),
            subtitle: Text(admin.gender),
          ),
        ],
      ),
    );
  }
}

