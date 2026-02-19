import '../models/order_model.dart';
import 'api_service.dart';

class OrderService {
  final ApiService _api = ApiService();

  Future<OrderModel> getOrderStatus(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return OrderModel(orderId: orderId, status: 'Shipped', updatedAt: DateTime.now());
  }
}
