import 'package:flutter/material.dart';
import 'admin_user_model.dart';
import 'admin_details_page.dart';

class AdminHighlightWidget extends StatelessWidget {
  final AdminUserModel adminUser;

  AdminHighlightWidget({required this.adminUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdminDetailsPage(admin: adminUser),
            ),
          );
        },
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(adminUser.photoUrl),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.verified_user,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              adminUser.name,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
