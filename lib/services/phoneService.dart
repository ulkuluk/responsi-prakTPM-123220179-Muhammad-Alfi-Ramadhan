import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/phoneModel.dart'; 

class PhoneApi {
  static const url =
      "https://tpm-api-responsi-e-f-872136705893.us-central1.run.app/api/v1/phones";

  static Future<Map<String, dynamic>> getPhones() async {
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createPhone(Phone phone) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(phone),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deletePhone(int id) async {
    final hasil = await http.delete(Uri.parse("$url/$id"));
    return jsonDecode(hasil.body);
  }

  static Future<Map<String, dynamic>> getPhoneById(int id) async {
    final hasil = await http.get(Uri.parse("$url/$id"));
    return jsonDecode(hasil.body);
  }

  static Future<Map<String, dynamic>> updatePhoneById(Phone phone) async {
    final hasil = await http.put(
      Uri.parse("$url/${phone.id}"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": phone.model,
        "brand": phone.brand,
        "price": phone.price,
        "imageUrl": phone.imageUrl,
        "ram": phone.ram, 
        "storage": phone.storage, 
        "websiteUrl": phone.websiteUrl,
      }),
    );
    return jsonDecode(hasil.body);
  }
}