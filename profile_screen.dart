import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screens.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  ProfileScreen({required this.user});

  final _newPasswordController = TextEditingController();

  void _changePassword(BuildContext context) async {
    try {
      await user.updatePassword(_newPasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => _logout(context))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logged in as: ${user.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Change Password'),
              onPressed: () => _changePassword(context),
            ),
          ],
        ),
      ),
    );
  }
}
