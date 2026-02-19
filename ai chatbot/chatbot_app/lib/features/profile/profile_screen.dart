import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppState>(context).user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Name: ${user?.name ?? '-'}'),
          const SizedBox(height: 8),
          Text('Email: ${user?.email ?? '-'}'),
          const SizedBox(height: 8),
          Text('Active Order: ${user?.activeOrderId ?? '-'}'),
        ]),
      ),
    );
  }
}
