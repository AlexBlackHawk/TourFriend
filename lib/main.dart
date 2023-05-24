import 'package:flutter/material.dart';
import 'screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const TravelAgencyWorkOptimization());
}

class TravelAgencyWorkOptimization extends StatelessWidget {
  const TravelAgencyWorkOptimization({super.key});

  static const String _title = 'TourFriend';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: StartScreen(),
    );
  }
}
