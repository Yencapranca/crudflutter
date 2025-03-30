import 'package:flutter/material.dart';
import 'api_service.dart';
import 'users.dart';

void main() {
  runApp(MaterialApp(home: LoginScreen()));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoggedIn = false;
  String? loggedInUser;

  void handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    await ApiService.loginUser(email, password);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserScreen()),
    );
  }

  void handleLogout() {
    setState(() {
      isLoggedIn = false;
      loggedInUser = null;
      emailController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: handleLogin, child: Text("Login")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}