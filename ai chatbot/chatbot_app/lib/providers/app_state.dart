import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

class AppState extends ChangeNotifier {
  UserModel? user;
  final List<MessageModel> messages = [];
  int selectedChatVariant = 1;

  bool get isLoggedIn => user != null;

  void login(UserModel u) {
    user = u;
    notifyListeners();
  }

  void logout() {
    user = null;
    messages.clear();
    notifyListeners();
  }

  void addMessage(MessageModel m) {
    messages.add(m);
    notifyListeners();
  }

  void setChatVariant(int v) {
    selectedChatVariant = v;
    notifyListeners();
  }
}
