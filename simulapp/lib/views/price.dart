// lib/views/prices_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/price_viewmodel.dart';

class PricesPage extends StatelessWidget {
  const PricesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PriceViewModel(),
      child: const _PricesPageContent(),
    );
  }
}

class _PricesPageContent extends StatelessWidget {
  const _PricesPageContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PriceViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: Colors.orange,
            ),
            SizedBox(width: 8),
            Text(
              'Precios de Exámenes de Inglés',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: viewModel.examPrices.length,
          itemBuilder: (context, index) {
            final exam = viewModel.examPrices[index];
            return _buildExamCard(context, exam.name, exam.imageUrl, exam.price, exam.url);
          },
        ),
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, String examName, String imageUrl, String price, String url) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    examName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.open_in_new, color: Colors.orange),
              onPressed: () async {
                try {
                  await Provider.of<PriceViewModel>(context, listen: false).launchURL(url);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error launching URL: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}