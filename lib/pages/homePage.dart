import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'phoneEditPage.dart';
import '../models/phoneModel.dart';
import '../services/phoneService.dart';
import 'phoneAddPage.dart';
import 'phoneDetailPage.dart';
import 'loginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Halo, ${_username != null ? '$_username' : ''}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => const PhoneAddPage(),
            ),
          ).then((_) => setState(() {}));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _userContainer(), 
      ),
      backgroundColor: const Color(0xFFF5F7FA),
    );
  }

  Widget _userContainer() {
    return FutureBuilder(
      future: PhoneApi.getPhones(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text(
            "Error: ${snapshot.error.toString()}",
            style: const TextStyle(color: Colors.red),
          ));
        } else if (snapshot.hasData) {
          PhoneModel response = PhoneModel.fromJson(snapshot.data!);
          if (response.data == null || response.data!.isEmpty) {
            return const Center(
                child: Text(
              "Tidak ada data film.",
              style: TextStyle(color: Colors.grey),
            ));
          }
          
          return _phonesList(context, response.data!); 
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // Widget _moviesList (GridView) yang sudah ada sebelumnya
  Widget _phonesList(BuildContext context, List<Phone> phones) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.6,
      ),
      itemCount: phones.length,
      itemBuilder: (context, index) {
        final phone = phones[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhoneDetailPage(id: phone.id!),
                ),
              ).then((_) => setState(() {}));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: phone.imageUrl != null && phone.imageUrl!.isNotEmpty
                      ? Image.network(
                          phone.imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          phone.model ?? 'Tidak Ada Judul',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Brand: ${phone.brand ?? 'N/A'}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                        Text(
                          'Harga: ${phone.price?.toStringAsFixed(1) ?? 'N/A'}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PhoneEditPage(id: phone.id!),
                                    ),
                                  ).then((_) => setState(() {}));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 8),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                child: const Text("Edit"),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Konfirmasi Hapus"),
                                        content: Text(
                                          "Apakah Anda yakin ingin menghapus ${phone.model ?? 'item ini'}?",
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("Batal"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Hapus"),
                                            onPressed: () async {
                                              await PhoneApi.deletePhone(phone.id!);
                                              if (!mounted) return;
                                              Navigator.of(context).pop();
                                              setState(() {});
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text('Phone berhasil dihapus!'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 8),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                child: const Text("Delete"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
}