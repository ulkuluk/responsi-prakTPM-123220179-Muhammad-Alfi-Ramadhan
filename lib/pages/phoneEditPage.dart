import '../models/phoneModel.dart';
import 'homePage.dart';
import '../services/phoneService.dart';
import 'package:flutter/material.dart';

class PhoneEditPage extends StatefulWidget {
  final int id;
  const PhoneEditPage({super.key, required this.id});

  @override
  State<PhoneEditPage> createState() => _PhoneEditPageState();
}

class _PhoneEditPageState extends State<PhoneEditPage> {
  final model = TextEditingController();
  final brand = TextEditingController();
  final price = TextEditingController();
  final ram = TextEditingController();
  final storage = TextEditingController();


  bool isLoaded = false;

  Future<void> _editPhone(BuildContext context) async {
    try {
      double? parsedPrice = double.tryParse(price.text.trim());
      int? parsedRam = int.tryParse(ram.text.trim());
      int? parsedStorage = int.tryParse(storage.text.trim());
      Phone updatedPhone = Phone(
        id: widget.id,
        model: model.text.trim(),
        brand: brand.text.trim(),
        ram: parsedRam,
        storage: parsedStorage,
        price: parsedPrice,
      );

      final response = await PhoneApi.updatePhoneById(updatedPhone);

      

      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil mengubah movie")),
        );
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      } else {
        throw Exception(response["message"] ?? 'Gagal update movie');
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
      appBar: AppBar(title: const Text("Edit Phone")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: PhoneApi.getPhoneById(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              if (!isLoaded) {
                Phone phone = Phone.fromJson(snapshot.data!["data"]);
                model.text = phone.model ?? '';
                brand.text = phone.brand ?? '';
                ram.text = phone.ram?.toString() ?? '';
                storage.text = phone.storage?.toString() ?? '';
                price.text = phone.price?.toString() ?? '';


                isLoaded = true;
              }

              return Form(
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
                          return 'model tidak boleh kosong';
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
                          return 'model tidak boleh kosong';
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
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "price",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'price tidak boleh kosong';
                        }
                        final parsedRating = double.tryParse(value.trim());
                        if (parsedRating == null) {
                          return 'price harus berupa angka desimal';
                        }
                        if (parsedRating < 0 || parsedRating > 5) {
                          return 'price harus antara 0 dan 5';
                        }
                        return null;
                      },
                    ),
                    

                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _editPhone(context);
                      },
                      child: const Text("Simpan Perubahan"),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
