// TODO Implement this library.
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/product.dart';

class PdfUtil {
  static Future<void> generateProductReport(List<Product> products) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Product Inventory Report')),
          pw.Table.fromTextArray(
            headers: ['Name', 'Barcode', 'Price', 'Quantity', 'Total Value'],
            data: products.map((product) {
              final total =
                  (product.price * product.quantity).toStringAsFixed(2);
              return [
                product.name,
                product.barcode,
                '₹${product.price.toStringAsFixed(2)}',
                product.quantity.toString(),
                '₹$total',
              ];
            }).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
