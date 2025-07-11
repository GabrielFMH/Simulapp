// lib/viewmodels/price_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/price_model.dart';

class PriceViewModel extends ChangeNotifier {
  final List<ExamPrice> _examPrices = [
    ExamPrice(
      name: 'The Examination for the Certificate of Proficiency in English (ECPE)',
      imageUrl: 'https://i.imgur.com/KnCNWOs.png',
      price: '\$160.00',
      url: 'https://cultural.edu.pe/tacna/examenes-internacionales/para-certificar-tu-ingles/',
    ),
    ExamPrice(
      name: 'IELTS Academic',
      imageUrl: 'https://i.imgur.com/nySl3Iz.png',
      price: 'S/.950',
      url: 'https://ieltsregistration.britishcouncil.org/',
    ),
    ExamPrice(
      name: 'B2 First (FCE)',
      imageUrl: 'https://i.imgur.com/FAVHB5v.png',
      price: 'S/.695',
      url: 'https://britanico.edu.pe/ingles/examenes-internacionales/b2-first-fce/',
    ),
    ExamPrice(
      name: 'C1 Advanced (CAE)',
      imageUrl: 'https://i.imgur.com/SjTfyUT.png',
      price: 'S/.745',
      url: 'https://idiomas.pucp.edu.pe/examenes-internacionales/cambridge-esol/jovenes-y-adultos/cae-certificate-in-advanced-english/',
    ),
    ExamPrice(
      name: 'ECPE Examination for the Certificate of Proficiency in English',
      imageUrl: 'https://i.imgur.com/7USKH6s.png',
      price: 'S/ 949',
      url: 'https://www.icpna.edu.pe/examen/examination-for-the-certificate-of-proficiency-in-english',
    ),
    ExamPrice(
      name: 'B2 English test (ISE II)',
      imageUrl: 'https://i.imgur.com/iampz37.png',
      price: '£180',
      url: 'https://www.trinitycollege.com/qualifications/SELT/B2-ISE-II',
    ),
  ];

  List<ExamPrice> get examPrices => _examPrices;

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}