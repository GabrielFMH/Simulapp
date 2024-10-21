// prices.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Asegúrate de importar tu archivo de colores si lo tienes separado
// import 'app_colors.dart';

class PricesPage extends StatelessWidget {
  const PricesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Puedes personalizar los colores aquí o usar una clase de colores personalizada
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
              'Precios de Examenes de Ingles',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              ' (Todos disponibles)',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
              },
              border: TableBorder.symmetric(
                inside: BorderSide(width: 1, color: Colors.grey.shade300),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Examen de Ingles',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Instituto',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Precios',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                _buildTableRow(
                  'The Examination for the Certificate of Proficiency in English (ECPE)',
                  'https://i.imgur.com/KnCNWOs.png',
                  '\$160.00',
                  'https://cultural.edu.pe/tacna/examenes-internacionales/para-certificar-tu-ingles/',
                ),
                _buildTableRow(
                  'IELTS Academic',
                  'https://i.imgur.com/nySl3Iz.png',
                  'S/.950',
                  'https://ieltsregistration.britishcouncil.org/ors/book-test?country=PE&location=5443&examType=ac&examFormat=cd&examDate=2024-10-18&__hstc=233199745.fc1a662c146aa2c7844480976a16ad09.1728925981830.1728925981830.1729015612105.2&__hssc=233199745.1.1729015612105&__hsfp=2008282439&_gl=1*1uyufkt*_gcl_au*MTkwMzEzNjcxNC4xNzI4OTI1OTgw*_ga*MTkyMjI2MjU3Ny4xNzI4OTI1OTc5*_ga_X5M3D7HLQQ*MTcyOTAxODI4OC4zLjAuMTcyOTAxODI4OC42MC4wLjA.*_ga_JKMKJHES2F*MTcyOTAxODI4OC4zLjAuMTcyOTAxODI4OC42MC4wLjA.',
                ),
                _buildTableRow(
                  'B2 First (FCE)',
                  'https://i.imgur.com/FAVHB5v.png',
                  'S/.695',
                  'https://britanico.edu.pe/ingles/examenes-internacionales/b2-first-fce/',
                ),
                _buildTableRow(
                  'C1 Advanced (CAE)',
                  'https://i.imgur.com/SjTfyUT.png',
                  'S/.745',
                  'https://idiomas.pucp.edu.pe/examenes-internacionales/cambridge-esol/jovenes-y-adultos/cae-certificate-in-advanced-english/',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(
    String model,
    String iconUrl,
    String price,
    String url,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Image.network(
              iconUrl,
              width: 200,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              price,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.blue, // Color azul para simular un enlace
                decoration: TextDecoration.underline, // Subrayado para simular un enlace
              ),
            ),
          ),
        ),
      ],
    );
  }
}
