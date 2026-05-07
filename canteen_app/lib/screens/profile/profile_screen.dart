import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';
import '../wallet/wallet_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final user = auth.user;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 12),
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            // Avatar card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                    child: Text(
                      (user?.name.isNotEmpty ?? false)
                          ? user!.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Guest',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                        if (user?.phone != null && user!.phone.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            user.phone,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                        if (user?.studentId != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'ID: ${user!.studentId}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showEditProfile(context, auth),
                    icon: const Icon(Icons.edit_rounded,
                        color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _statsRow(user?.walletBalance ?? 0),
            const SizedBox(height: 24),

            // Account section
            _menuSection('Account', [
              _MenuItemData(
                icon: Icons.account_balance_wallet,
                title: 'My Wallet',
                subtitle: 'TSh ${(user?.walletBalance ?? 0).toStringAsFixed(0)} available',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const WalletScreen())),
              ),
              _MenuItemData(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Update your name, email & phone',
                onTap: () => _showEditProfile(context, auth),
              ),
              _MenuItemData(
                icon: Icons.location_on_outlined,
                title: 'Saved Addresses',
                subtitle: '${settings.savedAddresses.length} saved location(s)',
                onTap: () => _showAddresses(context, settings),
              ),
            ]),
            const SizedBox(height: 16),

            // Preferences section
            _menuSection('Preferences', [
              _MenuItemData(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: settings.orderNotifications
                    ? 'Order alerts on'
                    : 'Notifications off',
                onTap: () => _showNotifications(context, settings),
              ),
              _MenuItemData(
                icon: Icons.language,
                title: 'Language',
                subtitle: settings.language,
                onTap: () => _showLanguage(context, settings),
              ),
              _MenuItemData(
                icon: settings.isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                title: 'Theme',
                subtitle: settings.isDark ? 'Dark Mode' : 'Light Mode',
                onTap: () => settings.toggleTheme(),
                trailing: Switch.adaptive(
                  value: settings.isDark,
                  onChanged: (_) => settings.toggleTheme(),
                  activeThumbColor: AppTheme.primaryColor,
                ),
              ),
            ]),
            const SizedBox(height: 16),

            // Support section
            _menuSection('Support', [
              _MenuItemData(
                icon: Icons.help_outline,
                title: 'Help & FAQ',
                subtitle: 'Get answers to common questions',
                onTap: () => _showFaq(context),
              ),
              _MenuItemData(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                subtitle: 'Help us improve',
                onTap: () => _showFeedback(context),
              ),
              _MenuItemData(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'Version 1.0.0',
                onTap: () => _showAbout(context),
              ),
            ]),
            const SizedBox(height: 16),

            // Logout
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout,
                      color: AppTheme.errorColor, size: 20),
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _logout(context),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Edit Profile ──────────────────────────────────────────────────────────
  void _showEditProfile(BuildContext context, AuthProvider auth) {
    final nameCtrl = TextEditingController(text: auth.user?.name);
    final emailCtrl = TextEditingController(text: auth.user?.email);
    final phoneCtrl = TextEditingController(text: auth.user?.phone);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Phone is required' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    await auth.updateProfile(
                      name: nameCtrl.text.trim(),
                      email: emailCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                    );
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Saved Addresses ───────────────────────────────────────────────────────
  void _showAddresses(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final ctrl = TextEditingController();
          return Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Saved Addresses',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Saved pickup / delivery locations on campus',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                if (settings.savedAddresses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No saved addresses yet',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  )
                else
                  ...settings.savedAddresses.asMap().entries.map((e) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: AppTheme.lightBg,
                          child: Icon(Icons.location_on_rounded,
                              color: AppTheme.primaryColor, size: 18),
                        ),
                        title: Text(e.value,
                            style: const TextStyle(fontSize: 14)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppTheme.errorColor, size: 20),
                          onPressed: () async {
                            await settings.removeAddress(e.key);
                            setState(() {});
                          },
                        ),
                      )),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ctrl,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Block C, Room 204',
                          prefixIcon: Icon(Icons.add_location_alt_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final text = ctrl.text.trim();
                        if (text.isEmpty) return;
                        await settings.addAddress(text);
                        ctrl.clear();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14)),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Notifications ─────────────────────────────────────────────────────────
  void _showNotifications(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: const Text('Notifications'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile.adaptive(
                title: const Text('Order Updates',
                    style: TextStyle(fontSize: 14)),
                subtitle: const Text(
                    'Get notified when your order is ready',
                    style: TextStyle(fontSize: 12)),
                value: settings.orderNotifications,
                onChanged: (val) async {
                  await settings.setOrderNotifications(val);
                  setState(() {});
                },
              ),
              SwitchListTile.adaptive(
                title: const Text('Promotions & Offers',
                    style: TextStyle(fontSize: 14)),
                subtitle: const Text('Daily deals and special menus',
                    style: TextStyle(fontSize: 12)),
                value: settings.promoNotifications,
                onChanged: (val) async {
                  await settings.setPromoNotifications(val);
                  setState(() {});
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Language ──────────────────────────────────────────────────────────────
  void _showLanguage(BuildContext context, SettingsProvider settings) {
    const languages = ['English', 'Swahili'];
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: const Text('Select Language'),
          content: RadioGroup<String>(
            groupValue: settings.language,
            onChanged: (val) async {
              if (val != null) {
                await settings.setLanguage(val);
                setState(() {});
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languages.map((lang) {
                final selected = settings.language == lang;
                return RadioListTile<String>(
                  value: lang,
                  title: Text(lang,
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: selected
                            ? AppTheme.primaryColor
                            : AppTheme.textPrimary,
                      )),
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  // ── FAQ ───────────────────────────────────────────────────────────────────
  void _showFaq(BuildContext context) {
    final faqs = [
      ('How do I place an order?',
          'Browse the menu, add items to your cart, and proceed to checkout. Pay using your wallet balance.'),
      ('How do I top up my wallet?',
          'Go to Profile > My Wallet and choose a top-up amount. Payments are processed instantly.'),
      ('Can I cancel my order?',
          'Orders can be cancelled before they reach "Preparing" status. Go to Orders and tap Cancel.'),
      ('How do I know my order is ready?',
          'You will receive a notification and the order status will change to "Ready". Use your token number to collect.'),
      ('What is the token number?',
          'A unique number assigned to your order for collection at the counter.'),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollCtrl) => ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Help & FAQ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...faqs.map((faq) => ExpansionTile(
                  title: Text(faq.$1,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Text(faq.$2,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              height: 1.5)),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  // ── Feedback ──────────────────────────────────────────────────────────────
  void _showFeedback(BuildContext context) {
    final ctrl = TextEditingController();
    int rating = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Send Feedback',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Rate your experience'),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  5,
                  (i) => GestureDetector(
                    onTap: () => setState(() => rating = i + 1),
                    child: Icon(
                      i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: AppTheme.accentColor,
                      size: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tell us what you think...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your feedback!'),
                        backgroundColor: AppTheme.successColor,
                      ),
                    );
                  },
                  child: const Text('Submit Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── About ─────────────────────────────────────────────────────────────────
  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Canteen App',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.restaurant_menu_rounded,
            color: Colors.white, size: 34),
      ),
      children: [
        const Text(
          'A smart canteen ordering app that lets you browse the menu, order food, and track your order status in real time.',
          style: TextStyle(fontSize: 13, height: 1.5),
        ),
      ],
    );
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout?'),
        content:
            const Text('You will need to sign in again to use the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false)
                  .logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout',
                style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }

  Widget _statsRow(double balance) {
    return Row(
      children: [
        Expanded(
          child: _statCard(Icons.account_balance_wallet,
              'TSh ${balance.toStringAsFixed(0)}', 'Balance', AppTheme.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
              Icons.receipt_long, '12', 'Orders', AppTheme.secondaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child:
              _statCard(Icons.star, '4.8', 'Rating', AppTheme.accentColor),
        ),
      ],
    );
  }

  Widget _statCard(
      IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _menuSection(String title, List<_MenuItemData> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon,
                          color: AppTheme.primaryColor, size: 20),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      item.subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600),
                    ),
                    trailing: item.trailing ??
                        const Icon(Icons.arrow_forward_ios,
                            size: 14, color: AppTheme.textSecondary),
                    onTap: item.onTap,
                  ),
                  if (!isLast)
                    Divider(
                        height: 1,
                        indent: 70,
                        color: Colors.grey.shade100),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });
}
