import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// PERBAIKAN: Mundur 3 folder (../../../) agar sampai ke folder lib/
import '../../../providers/user_provider.dart';
import '../../../screen/admin/add_place_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_jokka_header.png',
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text(
                "JOKKA",
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: userProvider.isAdmin
                ? GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPlacePage(),
                      ),
                    ),
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.black,
                      size: 32,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Halaman Profil sedang dikerjakan teman!",
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.account_circle_outlined,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Explore / Daftar wisata Jokka',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
