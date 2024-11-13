// prices.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PricesPage extends StatelessWidget {
  const PricesPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: ListView(
          children: [
            _buildExamCard(
              'The Examination for the Certificate of Proficiency in English (ECPE)',
              'https://i.imgur.com/KnCNWOs.png',
              '\$160.00',
              'https://cultural.edu.pe/tacna/examenes-internacionales/para-certificar-tu-ingles/',
            ),
            _buildExamCard(
              'IELTS Academic',
              'https://i.imgur.com/nySl3Iz.png',
              'S/.950',
              'https://ieltsregistration.britishcouncil.org/',
            ),
            _buildExamCard(
              'B2 First (FCE)',
              'https://i.imgur.com/FAVHB5v.png',
              'S/.695',
              'https://britanico.edu.pe/ingles/examenes-internacionales/b2-first-fce/',
            ),
            _buildExamCard(
              'C1 Advanced (CAE)',
              'https://i.imgur.com/SjTfyUT.png',
              'S/.745',
              'https://idiomas.pucp.edu.pe/examenes-internacionales/cambridge-esol/jovenes-y-adultos/cae-certificate-in-advanced-english/',
            ),
            _buildExamCard(
              'ECPE Examination for the Certificate of Proficiency in English',
              'https://i.imgur.com/7USKH6s.png',
              'S/ 949',
              'https://www.icpna.edu.pe/examen/examination-for-the-certificate-of-proficiency-in-english',
            ),
            _buildExamCard(
              'B2 English test (ISE II)',
              'https://i.imgur.com/iampz37.png',
              '£180',
              'https://www.trinitycollege.com/qualifications/SELT/B2-ISE-II',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(String examName, String imageUrl, String price, String url) {
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
                final Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
