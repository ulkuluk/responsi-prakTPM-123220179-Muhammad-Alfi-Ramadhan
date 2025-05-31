import 'package:flutter/material.dart';
import '../models/phoneModel.dart';
import '../services/phoneService.dart';
import 'phoneEditPage.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneDetailPage extends StatelessWidget {
  final int id;
  const PhoneDetailPage({super.key, required this.id});

  Future<void> _launchPhoneUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Tidak bisa membuka URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Phone"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhoneEditPage(id: id)),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: PhoneApi.getPhoneById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final phoneData = snapshot.data!["data"];
            if (phoneData == null) {
              return const Center(child: Text("phone tidak ditemukan."));
            }
            Phone phone = Phone.fromJson(phoneData);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child:
                        phone.imageUrl != null && phone.imageUrl!.isNotEmpty
                            ? Image.network(
                              phone.imageUrl!,
                              height: 250,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 100,
                                );
                              },
                            )
                            : const Icon(Icons.movie, size: 150),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    phone.model ?? 'Tidak Ada Judul',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Ram: ${phone.ram ?? '-'} ',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Storage: ${phone.storage ?? '-'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: const Color.fromARGB(255, 9, 109, 23),
                        size: 20,
                      ),
                      Text(
                        '${phone.price?.toStringAsFixed(1) ?? '-'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed:
                          phone.websiteUrl != null &&
                                  phone.websiteUrl!.isNotEmpty
                              ? () => _launchPhoneUrl(phone.websiteUrl!)
                              : null,
                      label: const Text(
                        "Lihat Web",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Tidak ada data movie."));
          }
        },
      ),
    );
  }
}
