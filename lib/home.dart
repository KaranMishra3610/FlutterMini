import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user=FirebaseAuth.instance.currentUser;

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Homepage")),
      body: Center(
        child: Text('${user!.email}'),
      ), // Center
      floatingActionButton: FloatingActionButton(
        onPressed: () => signout(),
        child: Icon(Icons.login_rounded),
      ), // FloatingActionButton
    ); // Scaffold
  }

}
