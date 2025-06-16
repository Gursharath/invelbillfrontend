import 'package:flutter/material.dart';
import '../constants/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF2A2A2A),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  radius: 32,
                  child: Image.asset('assets/images/logo.png', height: 40),
                ),
                const SizedBox(height: 12),
                const Text(
                  'InvenBill',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildTile(
              context, Icons.dashboard, 'Dashboard', AppRoutes.dashboard),
          _buildTile(
              context, Icons.add_box, 'Add Product', AppRoutes.addProduct),
          _buildTile(context, Icons.document_scanner, 'Scan Product',
              AppRoutes.scanProduct),
          _buildTile(
              context, Icons.list_alt, 'View Products', AppRoutes.productList),
          _buildTile(context, Icons.inventory, 'Stock Management',
              AppRoutes.stockManagement),
          _buildTile(context, Icons.receipt_long, 'Create Invoice',
              AppRoutes.createInvoice),
          _buildTile(context, Icons.history, 'Invoice History',
              AppRoutes.invoiceHistory),
          _buildTile(
              context, Icons.chat, 'Chat Assistant', AppRoutes.geminiChat),
          const Spacer(),
          const Divider(color: Colors.white24),
          _buildTile(
            context,
            Icons.logout,
            'Logout',
            AppRoutes.login,
            isLogout: true,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    IconData icon,
    String title,
    String route, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading:
          Icon(icon, color: isLogout ? Colors.redAccent : Colors.tealAccent),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.redAccent : Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // close drawer
        if (ModalRoute.of(context)?.settings.name != route) {
          if (isLogout) {
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pushNamed(context, route);
          }
        }
      },
    );
  }
}
