import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../services/order_service.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  final OrderService _orderService = OrderService();
  String? _status;
  bool _loading = false;

  Future<void> _fetch() async {
    final user = Provider.of<AppState>(context, listen: false).user;
    if (user == null || user.activeOrderId == null) return;
    setState(() => _loading = true);
    final order = await _orderService.getOrderStatus(user.activeOrderId!);
    setState(() {
      _status = order.status;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Status')),
      body: Center(
        child: _loading ? const CircularProgressIndicator() : Text(_status ?? 'No active order'),
      ),
    );
  }
}
