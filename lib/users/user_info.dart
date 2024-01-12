import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoScreen extends StatelessWidget {
  final User user;

  UserInfoScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: ${user.displayName ?? 'N/A'}'),
            Text('Email: ${user.email ?? 'N/A'}'),
            user.photoURL != null
                ? Image.network(user.photoURL!)
                : Placeholder(fallbackHeight: 100, fallbackWidth: 100),
          ],
        ),
      ),
    );
  }
}
