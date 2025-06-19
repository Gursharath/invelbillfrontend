import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              gradient: LinearGradient(
                colors: [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.tealAccent, Colors.cyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.tealAccent.withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 34,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 64,
                        width: 64,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'InvenBill',
                  style: GoogleFonts.orbitron(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.tealAccent,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.tealAccent.withOpacity(0.7),
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildTile(
              context, Icons.dashboard, 'Dashboard', AppRoutes.dashboard),
          _buildTile(
              context, Icons.add_box, 'Add Product', AppRoutes.addProduct),
          _buildTile(context, Icons.search, 'Scanned Product Detail',
              AppRoutes.scanProductDetail),
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
          _buildTile(context, Icons.videogame_asset, 'Snake Game',
              AppRoutes.snakeGame),
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
      leading: Icon(
        icon,
        color: isLogout ? Colors.redAccent : Colors.tealAccent,
      ),
      title: Text(
        title,
        style: GoogleFonts.orbitron(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isLogout ? Colors.redAccent : Colors.white,
          letterSpacing: 1.0,
          shadows: isLogout
              ? []
              : [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.tealAccent.withOpacity(0.5),
                    offset: const Offset(0, 1),
                  ),
                ],
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
