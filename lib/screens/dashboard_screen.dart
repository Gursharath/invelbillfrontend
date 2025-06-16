import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../constants/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 66, 66, 69),
        title: const Text("Dashboard."),
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _OverviewCard(
                  title: "Total Products",
                  value: "120",
                  color: Color(0xFF5DADE2),
                ),
                _OverviewCard(
                  title: "Low Stock",
                  value: "10",
                  color: Color(0xFFF5B041),
                ),
                _OverviewCard(
                  title: "Sales (Today)",
                  value: "₹2500",
                  color: Color(0xFF58D68D),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _ActionButton(
                  icon: Icons.add_box_rounded,
                  label: "Add Product",
                  route: AppRoutes.addProduct,
                  color: Color(0xFF5DADE2),
                ),
                _ActionButton(
                  icon: Icons.qr_code_scanner,
                  label: "Scan Product",
                  route: AppRoutes.scanProduct,
                  color: Color(0xFF48C9B0),
                ),
                _ActionButton(
                  icon: Icons.receipt_long_rounded,
                  label: "Create Invoice",
                  route: AppRoutes.createInvoice,
                  color: Color(0xFFF1948A),
                ),
                _ActionButton(
                  icon: Icons.list_alt,
                  label: "View Products",
                  route: AppRoutes.productList,
                  color: Color(0xFFAF7AC5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _OverviewCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2C2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: color.withOpacity(0.3),
      child: SizedBox(
        width: 110,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        color: const Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: color.withOpacity(0.3),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
