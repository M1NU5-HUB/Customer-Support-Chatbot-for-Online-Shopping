import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppState>(context).user;
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome ${user?.name ?? 'Guest'}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('/chat'), child: const Text('Open Chatbot')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('/orders'), child: const Text('Order Status')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('/profile'), child: const Text('Profile')),
          ],
        ),
      ),
    );
  }
}
