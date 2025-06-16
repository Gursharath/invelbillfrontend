import 'package:flutter/material.dart';
import 'package:invenbill/screens/gemini_chat_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/add_product_screen.dart';
import '../screens/scan_product_screen.dart';
import '../screens/product_list_screen.dart';
import '../screens/stock_management_screen.dart';
import '../screens/create_invoice_screen.dart';
import '../screens/invoice_pdf_preview_screen.dart';
import '../screens/invoice_history_screen.dart';
import '../screens/admin_user_management_screen.dart';
import '../screens/gemini_chat_screen.dart';

class AppRoutes {
  static const login = '/';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const addProduct = '/add-product';
  static const scanProduct = '/scan-product';
  static const productList = '/product-list';
  static const stockManagement = '/stock-management';
  static const createInvoice = '/create-invoice';
  static const invoicePdfPreview = '/invoice-pdf-preview';
  static const invoiceHistory = '/invoice-history';
  static const adminUserManagement = '/admin-user-management';
  static const geminiChat = '/gemini-chat';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      dashboard: (context) => const DashboardScreen(),
      addProduct: (context) => const AddProductScreen(),
      scanProduct: (context) => const ScanProductScreen(),
      productList: (context) => const ProductListScreen(),
      stockManagement: (context) => const StockManagementScreen(),
      createInvoice: (context) => const CreateInvoiceScreen(),
      invoicePdfPreview: (context) => const InvoicePdfPreviewScreen(),
      invoiceHistory: (context) => const InvoiceHistoryScreen(),
      adminUserManagement: (context) => const AdminUserManagementScreen(),
      geminiChat: (context) => const GeminiChatScreen(),
    };
  }
}
