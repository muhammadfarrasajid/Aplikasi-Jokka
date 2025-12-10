import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../core/widgets/side_menu.dart';
import '../auth/presentation/login_page.dart';
import '../../../core/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    String displayName = "Pengguna Jokka";
    if (userProvider.fullName.isNotEmpty) {
      displayName = userProvider.fullName;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      
      endDrawer: const SideMenu(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_jokka_header.png',
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text(
                "JOKKA",
                style: TextStyle(
                    color: Color(0xFFE53935),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          // HAMBURGER MENU
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 32),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                border: Border.all(color: JokkaColors.primary, width: 3),
              ),
              child: const Icon(Icons.person, size: 80, color: Colors.grey),
            ),
            
            const SizedBox(height: 24),

            _buildProfileInfoTile(
              label: "Nama Lengkap", 
              value: displayName, 
              icon: Icons.person_outline
            ),
            
            const SizedBox(height: 16),
            
            _buildProfileInfoTile(
              label: "Email", 
              value: user?.email ?? "-", 
              icon: Icons.email_outlined
            ),

             const SizedBox(height: 16),
            
            _buildProfileInfoTile(
              label: "Status Akun", 
              value: userProvider.isAdmin ? "Administrator" : "User Biasa", 
              icon: Icons.verified_user_outlined,
              valueColor: userProvider.isAdmin ? Colors.green : Colors.black87
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  await userProvider.signOut();

                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text(
                      "Keluar Akun",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoTile({
    required String label, 
    required String value, 
    required IconData icon,
    Color valueColor = Colors.black87
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(icon, color: Colors.grey[700], size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}