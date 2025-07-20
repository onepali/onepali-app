import 'package:flutter/material.dart';

class GuestDashboardScreen extends StatefulWidget {
  const GuestDashboardScreen({super.key});

  @override
  State<GuestDashboardScreen> createState() => _GuestDashboardScreenState();
}

class _GuestDashboardScreenState extends State<GuestDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('GuestDashboardScreen')));
  }
}
