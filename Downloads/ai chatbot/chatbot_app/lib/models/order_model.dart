class OrderModel {
  final String orderId;
  final String status;
  final DateTime updatedAt;

  OrderModel({required this.orderId, required this.status, required this.updatedAt});

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json['orderId'] as String,
        status: json['status'] as String,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'status': status,
        'updatedAt': updatedAt.toIso8601String(),
      };
}
