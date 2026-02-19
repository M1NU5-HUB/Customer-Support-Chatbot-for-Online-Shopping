import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppState>(context).user;
    final bg = const Color(0xFF081017);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/home')),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const SizedBox(height: 8),
                CircleAvatar(radius: 48, backgroundColor: Colors.white12, child: Text(user?.name.substring(0,1) ?? '?', style: const TextStyle(fontSize: 32))),
                const SizedBox(height: 12),
                Text(user?.name ?? 'John Doe', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(user?.email ?? 'john.doe@example.com', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 22),

                // Support & History
                Align(alignment: Alignment.centerLeft, child: Text('SUPPORT & HISTORY', style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600))),
                const SizedBox(height: 12),
                _OptionCard(icon: Icons.history, label: 'Order History', onTap: () {}),
                const SizedBox(height: 18),

                // Security
                Align(alignment: Alignment.centerLeft, child: Text('SECURITY', style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600))),
                const SizedBox(height: 12),
                _OptionCard(icon: Icons.lock, label: 'Privacy Settings', onTap: () {}),
                const SizedBox(height: 8),
                _OptionCard(icon: Icons.verified_user, label: 'Verification', trailing: const _PendingBadge(), onTap: () {}),

                const SizedBox(height: 28),
                // Logout button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false).logout();
                      context.go('/');
                    },
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700))),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.redAccent.withOpacity(0.5)), backgroundColor: Colors.white10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  ),
                ),

                const SizedBox(height: 18),
                Text('Version 2.4.5 (Beta)', style: TextStyle(color: Colors.white30)),
                const SizedBox(height: 28),
              ]),
            ),
          ),

          // Bottom nav (mini)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFF071018), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)]),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              GestureDetector(onTap: () => context.go('/home'), child: Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.home, color: Colors.white70), SizedBox(height: 6), Text('Home', style: TextStyle(color: Colors.white70))])),
              GestureDetector(onTap: () => context.go('/chat'), child: Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.chat, color: Colors.white70), SizedBox(height: 6), Text('Chat', style: TextStyle(color: Colors.white70))])),
              GestureDetector(onTap: () => context.go('/profile'), child: Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.person, color: Colors.blue), SizedBox(height: 6), Text('Profile', style: TextStyle(color: Colors.blue))])),
            ]),
          )
        ]),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _OptionCard({required this.icon, required this.label, this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFF0F1720), borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          CircleAvatar(backgroundColor: Colors.white12, child: Icon(icon, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
          if (trailing != null) trailing!,
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.white30)
        ]),
      ),
    );
  }
}

class _PendingBadge extends StatelessWidget {
  const _PendingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.orange[700], borderRadius: BorderRadius.circular(8)), child: const Text('Pending', style: TextStyle(color: Colors.white, fontSize: 12)));
  }
}

