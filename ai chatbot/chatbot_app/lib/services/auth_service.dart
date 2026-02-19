import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Dummy user for scaffold
    return UserModel(userId: 'user_123', name: 'Demo User', email: email, avatarUrl: null, activeOrderId: 'order_789');
  }
}
