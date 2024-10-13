import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:carmaintenanceapp/firebase_options.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'find_components_page.dart';
import 'track_workshop_page.dart';
import 'maintenance_log_page.dart';
import 'car_details_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CarDetailsProvider>(
          create: (_) => CarDetailsProvider(),
        ),
        // Add more providers if necessary
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoParts',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Use scaffoldBackgroundColor instead
        fontFamily: 'Montserrat',
        appBarTheme: AppBarTheme(
          color: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/find_components': (context) => FindComponentsPage(),
        '/track_workshop': (context) => TrackWorkshopPage(),
        '/maintenance_log': (context) => MaintenanceLogPage()
      },
    );
  }
}
