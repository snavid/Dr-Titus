import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  final _uuid = const Uuid();

  List<Order> get orders => List.unmodifiable(_orders.reversed);

  List<Order> get activeOrders => _orders
      .where((o) =>
          o.status != OrderStatus.completed && o.status != OrderStatus.cancelled)
      .toList()
      .reversed
      .toList();

  List<Order> get pastOrders => _orders
      .where((o) =>
          o.status == OrderStatus.completed || o.status == OrderStatus.cancelled)
      .toList()
      .reversed
      .toList();

  Order placeOrder({
    required String userId,
    required List<CartItem> items,
    required double subtotal,
    required double tax,
    required double total,
    required PaymentMethod paymentMethod,
    String? specialInstructions,
  }) {
    final tokenNumber = (100 + _orders.length + 1).toString();
    final order = Order(
      id: _uuid.v4(),
      userId: userId,
      items: List.from(items),
      subtotal: subtotal,
      tax: tax,
      total: total,
      status: OrderStatus.confirmed,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      estimatedReadyTime: DateTime.now().add(const Duration(minutes: 15)),
      tokenNumber: tokenNumber,
      specialInstructions: specialInstructions,
    );

    _orders.add(order);
    notifyListeners();

    // Simulate progress: confirmed -> preparing -> ready
    _simulateOrderProgress(order.id);

    return order;
  }

  void _simulateOrderProgress(String orderId) {
    Future.delayed(const Duration(seconds: 5), () {
      updateOrderStatus(orderId, OrderStatus.preparing);
    });
    Future.delayed(const Duration(seconds: 15), () {
      updateOrderStatus(orderId, OrderStatus.ready);
    });
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }
}


