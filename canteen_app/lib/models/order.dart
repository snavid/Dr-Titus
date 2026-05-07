import 'cart_item.dart';

enum OrderStatus { pending, confirmed, preparing, ready, completed, cancelled }

extension OrderStatusExt on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

enum PaymentMethod { wallet, card, upi, cash }

extension PaymentMethodExt on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.wallet:
        return 'Wallet';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.cash:
        return 'Cash on Pickup';
    }
  }
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final DateTime? estimatedReadyTime;
  final String tokenNumber;
  final String? specialInstructions;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    required this.tokenNumber,
    this.estimatedReadyTime,
    this.specialInstructions,
  });

  Order copyWith({
    OrderStatus? status,
    DateTime? estimatedReadyTime,
  }) {
    return Order(
      id: id,
      userId: userId,
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
      tokenNumber: tokenNumber,
      estimatedReadyTime: estimatedReadyTime ?? this.estimatedReadyTime,
      specialInstructions: specialInstructions,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((i) => i.toJson()).toList(),
        'subtotal': subtotal,
        'tax': tax,
        'total': total,
        'status': status.name,
        'paymentMethod': paymentMethod.name,
        'createdAt': createdAt.toIso8601String(),
        'estimatedReadyTime': estimatedReadyTime?.toIso8601String(),
        'tokenNumber': tokenNumber,
        'specialInstructions': specialInstructions,
      };
}


