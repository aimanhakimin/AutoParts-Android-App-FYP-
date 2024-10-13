import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'find_components_page.dart';
import 'maintenance_log_page.dart';
import 'track_workshop_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login page after logout
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoParts'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, color: Colors.white), // Logout icon
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.white), // Text color
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent), // Light blue background for button
              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)), // Adjust padding
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/app_background.jpg'), // Background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/home-screen-logo.png',
                      width: 150, // Adjust size as needed
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 4.0), // Adjust spacing as needed
                    Text(
                      'AUTOPARTS',
                      style: TextStyle(
                        fontSize: 32.0, // Adjust size as needed
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Adjust text color
                      ),
                    ),
                    SizedBox(height: 4.0), // Adjust spacing as needed
                    Text(
                      'Manage Your Cars Easier',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0, // Adjust size as needed
                        fontWeight: FontWeight.normal,
                        color: Colors.black, // Adjust text color
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.0), // Add spacing between text and buttons
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/find_components');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent), // Light blue background for button
                        foregroundColor: MaterialStateProperty.all(Colors.white), // Text color
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)), // Adjust padding
                      ),
                      child: Text(
                        'Find Components',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/maintenance_log');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent), // Light blue background for button
                        foregroundColor: MaterialStateProperty.all(Colors.white), // Text color
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)), // Adjust padding
                      ),
                      child: Text(
                        'Maintenance Log',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/track_workshop');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent), // Light blue background for button
                        foregroundColor: MaterialStateProperty.all(Colors.white), // Text color
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)), // Adjust padding
                      ),
                      child: Text(
                        'Track Workshop',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavigationBar(
              currentIndex: 0, // Default to Home
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Find Components',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'Maintenance Log',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Track Workshop',
                ),
              ],
              selectedItemColor: Colors.lightBlueAccent,
              unselectedItemColor: Colors.lightBlueAccent,
              onTap: (int index) {
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/find_components');
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/maintenance_log');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/track_workshop');
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
