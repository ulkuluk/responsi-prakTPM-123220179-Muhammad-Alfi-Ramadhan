import 'package:responsi/models/phoneModel.dart';
import 'homePage.dart';
import '../services/phoneService.dart';
import 'package:flutter/material.dart';

class PhoneAddPage extends StatefulWidget {
  const PhoneAddPage({super.key});

  @override
  State<PhoneAddPage> createState() => _PhoneAddPageState();
}

class _PhoneAddPageState extends State<PhoneAddPage> {
  final model = TextEditingController();
  final brand = TextEditingController();
  final price = TextEditingController();
  final ram = TextEditingController();
  final storage = TextEditingController();

  Future<void> _createPhone(BuildContext context) async {
    try {
      double? parsedPrice = double.tryParse(price.text.trim());
      int? parsedRam = int.tryParse(ram.text.trim());
      int? parsedStorage = int.tryParse(storage.text.trim());
      Phone newMovie = Phone(
        model: model.text.trim(),
        brand: brand.text.trim(),
        ram: parsedRam,
        storage: parsedStorage,
        price: parsedPrice,
      );

      final response = await PhoneApi.createPhone(newMovie);

      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil menambah phone baru")),
        );

        Navigator.pop(context);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      } else {
        throw Exception(response["message"]);
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah phone Baru")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: model,
                decoration: const InputDecoration(
                  labelText: "model",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama phone tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: brand,
                decoration: const InputDecoration(
                  labelText: "brand",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama brand tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ram,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "ram",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'ram tidak boleh kosong';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'ram harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: storage,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "storage",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'storage tidak boleh kosong';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'storage harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: price,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "price",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'price tidak boleh kosong';
                  }
                  final parsedPrice = double.tryParse(value.trim());
                  if (parsedPrice == null) {
                    return 'price harus berupa angka desimal';
                  }
                  if (parsedPrice < 0 || parsedPrice > 5) {
                    return 'price harus antara 0 dan 5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _createPhone(context);
                },
                child: const Text("Tambah Phone"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
