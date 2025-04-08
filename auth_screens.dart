import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (isLogin) {
          await _auth.signInWithEmailAndPassword(
            email: emailCtrl.text,
            password: passwordCtrl.text,
          );
        } else {
          await _auth.createUserWithEmailAndPassword(
            email: emailCtrl.text,
            password: passwordCtrl.text,
          );
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(user: _auth.currentUser!),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.contains('@') ? null : 'Enter valid email',
              ),
              TextFormField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) => value!.length >= 6 ? null : 'Min 6 characters',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isLogin ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin
                    ? "Don't have an account? Register"
                    : "Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
