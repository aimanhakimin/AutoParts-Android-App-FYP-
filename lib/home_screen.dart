import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (kDebugMode) {
        print('Error logging out: $e');
      }
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
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.lightBlueAccent),
              padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/app_background.jpg'),
                fit: BoxFit.cover,
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
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 4.0),
                    const Text(
                      'AUTOPARTS',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    const Text(
                      'Manage Your Cars Easier',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50.0),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/find_components');
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.lightBlueAccent),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)),
                      ),
                      child: const Text(
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
                        backgroundColor: WidgetStateProperty.all(Colors.lightBlueAccent),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)),
                      ),
                      child: const Text(
                        'Maintenance Log',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/track_workshop');
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.lightBlueAccent),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)),
                      ),
                      child: const Text(
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
            child: newMethod(context),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar newMethod(BuildContext context) {
    return BottomNavigationBar(
            currentIndex: 0,
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
          );
  }
}
