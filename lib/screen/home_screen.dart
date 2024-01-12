import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ui/translator_ui.dart';
import '../ui/space_invaders_ui.dart';
import '../ui/tictactoe_ui.dart';
import '../ui/color_match_ui.dart';
import '../users/auth_services.dart';
import '../users/user_info.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-Use App'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                await _showSignInOptions(context);
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserInfoScreen(user: user)));
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            _buildFeatureCard('Translator', Icons.language, Colors.purple, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TranslatorApp()))),
            _buildFeatureCard('Space Invaders', Icons.videogame_asset, Colors.blue, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SpaceInvadersGame()))),
            _buildFeatureCard('Tic Tac Toe', Icons.grid_on, Colors.green, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TicTacToe()))),
            _buildFeatureCard('Color Match', Icons.palette, Colors.orange, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ColorMatchGame()))),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: color,
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  Future<void> _showSignInOptions(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Sign in Anonymously'),
                onTap: () async {
                  await _authService.signInAnonymously();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.g_mobiledata),
                title: Text('Sign in with Google'),
                onTap: () async {
                  await _authService.signInWithGoogle();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.facebook),
                title: Text('Sign in with Facebook'),
                onTap: () async {
                  await _authService.signInWithFacebook();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
