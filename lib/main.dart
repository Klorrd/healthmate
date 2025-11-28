import 'package:flutter/material.dart';
import 'package:healthmate/features/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'features/health_records/health_records_provider.dart';

void main() {
  runApp(const HealthMateApp());
}

class HealthMateApp extends StatelessWidget {
  const HealthMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HealthRecordsProvider()..loadRecords(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HealthMate',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1E1E1E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2D2D2D),
            foregroundColor: Colors.white,
          ),
          cardColor: const Color(0xFF2D2D2D),
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const DashboardScreen(), 
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("HealthMate App Running")));
  }
}
