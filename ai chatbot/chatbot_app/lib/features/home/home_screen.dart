import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.user ??
        (throw Exception('User should be logged in for HomeScreen (use demo login)'));

    final bg = const Color(0xFF0B1220);
    final cardBlue = const Color(0xFF1E88E5);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(backgroundImage: null, radius: 22, child: Text(user.name[0])),
                        const SizedBox(width: 12),
                        Text('Support Home', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text('Hello, ${user.name} 👋', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('How can we help you today?', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
                    const SizedBox(height: 22),

                    Text('Quick Actions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    // Big blue card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardBlue,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: const [Icon(Icons.safety_divider, color: Colors.white70), SizedBox(width: 8), Text('INSTANT SUPPORT', style: TextStyle(color: Colors.white70))]),
                          const SizedBox(height: 12),
                          const Text('Chat with AI Assistant', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          Opacity(opacity: 0.95, child: Text('Get immediate answers to your shopping, returns, and order questions.', style: TextStyle(color: Colors.white.withOpacity(0.9)))),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            onPressed: () => context.go('/chat'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.22),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 6,
                            ),
                            child: const Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12), child: Text('Start Chatting', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('Recent Order', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: Colors.blue)))
                    ]),

                    // Recent order card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: const Color(0xFF0F1720), borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)), child: const Center(child: Icon(Icons.shopping_bag, color: Colors.white))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const Expanded(child: Text('UltraBoost Runner', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                              const SizedBox(width: 8),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.green[600], borderRadius: BorderRadius.circular(12)), child: const Text('On the way', style: TextStyle(color: Colors.white, fontSize: 12)))
                            ]),
                            const SizedBox(height: 6),
                            Row(children: [Text('Order #88219', style: TextStyle(color: Colors.white70)), const SizedBox(width: 8), Text('• Arriving tomorrow', style: TextStyle(color: Colors.white70))]),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(value: 0.7, color: Colors.blueAccent, backgroundColor: Colors.white12, minHeight: 6),
                            )
                          ]),
                        )
                      ]),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // Bottom nav
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: const Color(0xFF071018), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)]),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                GestureDetector(onTap: () => context.go('/home'), child: Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.home, color: Colors.blue), SizedBox(height: 6), Text('Home', style: TextStyle(color: Colors.blue))])),
                GestureDetector(onTap: () => context.go('/chat'), child: Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.chat, color: Colors.white70), SizedBox(height: 6), Text('Chat', style: TextStyle(color: Colors.white70))])),
                GestureDetector(onTap: () => context.go('/profile'), child: Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.person, color: Colors.white70), SizedBox(height: 6), Text('Profile', style: TextStyle(color: Colors.white70))])),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
