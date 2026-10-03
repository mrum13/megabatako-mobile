import 'package:url_launcher/url_launcher.dart';

void openWhatsApp({required String phoneNumber}) async {
  final url = 'https://wa.me/$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> openMaps(String query) async {
  final uri = Uri.https('www.google.com', '/maps/search/', {
    'api': '1',
    'query': query,
  });

  final success = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );

  if (!success) {
    throw 'Tidak bisa membuka Google Maps';
  }
}