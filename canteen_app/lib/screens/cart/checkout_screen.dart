import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/order.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_theme.dart';
import '../orders/order_detail_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedPayment = PaymentMethod.wallet;
  final _instructionsController = TextEditingController();
  bool _isPlacing = false;

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final orders = Provider.of<OrderProvider>(context, listen: false);

    if (_selectedPayment == PaymentMethod.wallet &&
        (auth.user?.walletBalance ?? 0) < cart.total) {
      Fluttertoast.showToast(msg: 'Insufficient wallet balance');
      return;
    }

    setState(() => _isPlacing = true);
    await Future.delayed(const Duration(seconds: 2));

    final order = orders.placeOrder(
      userId: auth.user!.id,
      items: cart.items,
      subtotal: cart.subtotal,
      tax: cart.tax,
      total: cart.total,
      paymentMethod: _selectedPayment,
      specialInstructions: _instructionsController.text,
    );

    if (_selectedPayment == PaymentMethod.wallet) {
      await auth.deductFromWallet(cart.total);
    }

    cart.clearCart();

    if (!mounted) return;
    setState(() => _isPlacing = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderDetailScreen(orderId: order.id, isNewOrder: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionHeader('Order Summary', Icons.receipt_long_outlined),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ...cart.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'x${item.quantity}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.menuItem.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          'TSh ${item.totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                _row('Subtotal', 'TSh ${cart.subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 6),
                _row('Tax', 'TSh ${cart.tax.toStringAsFixed(2)}'),
                const SizedBox(height: 6),
                _row('Total', 'TSh ${cart.total.toStringAsFixed(2)}', isBold: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeader('Special Instructions', Icons.edit_note),
          const SizedBox(height: 12),
          TextField(
            controller: _instructionsController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Any special requests? (e.g., less spicy)',
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeader('Payment Method', Icons.payment),
          const SizedBox(height: 12),
          _paymentOption(
            method: PaymentMethod.wallet,
            icon: Icons.account_balance_wallet,
            title: 'Wallet',
            subtitle: 'Balance: TSh ${auth.user?.walletBalance.toStringAsFixed(2) ?? '0.00'}',
          ),
          const SizedBox(height: 10),
          _paymentOption(
            method: PaymentMethod.upi,
            icon: Icons.qr_code,
            title: 'UPI',
            subtitle: 'Pay via Google Pay, PhonePe, etc.',
          ),
          const SizedBox(height: 10),
          _paymentOption(
            method: PaymentMethod.card,
            icon: Icons.credit_card,
            title: 'Card',
            subtitle: 'Credit / Debit Card',
          ),
          const SizedBox(height: 10),
          _paymentOption(
            method: PaymentMethod.cash,
            icon: Icons.money,
            title: 'Cash on Pickup',
            subtitle: 'Pay when you collect',
          ),
          const SizedBox(height: 100),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isPlacing ? null : _placeOrder,
              child: _isPlacing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Place Order â€¢ TSh ${cart.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? AppTheme.textPrimary : Colors.grey.shade700,
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isBold ? AppTheme.primaryColor : AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _paymentOption({
    required PaymentMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedPayment == method;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = method),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppTheme.primaryColor : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}


