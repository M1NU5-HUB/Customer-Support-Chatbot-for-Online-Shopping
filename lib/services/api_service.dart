class ApiService {
  // Placeholder for REST calls. Replace with real HTTP client code.
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'ok': true};
  }

  Future<Map<String, dynamic>> get(String path) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {'ok': true};
  }
}
