import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../features/home/home_page.dart';
import '../../features/explore/presentation/explore_page.dart';
import '../../features/wishlist/presentation/wishlist_page.dart';
import '../../features/profile/profile_page.dart'; 
import '../../screen/admin/add_place_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../theme/app_theme.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    String displayName = "Pengguna Jokka";
    if (userProvider.fullName.isNotEmpty) {
       displayName = userProvider.fullName;
    }

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    border: Border.all(color: JokkaColors.primary, width: 2),
                  ),
                  child: const Icon(Icons.person, size: 50, color: Colors.grey),
                ),
                const SizedBox(height: 15),
                Text(
                  displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  userProvider.user?.email ?? "",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          
          const Divider(thickness: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _buildMenuItem(context, "Profile", Icons.person_outline, const ProfilePage()),
                _buildMenuItem(context, "Home", Icons.home_outlined, const HomePage(), isReplacement: true),
                _buildMenuItem(context, "Explore", Icons.explore_outlined, const ExplorePage(), isReplacement: true),
                _buildMenuItem(context, "Wishlist", Icons.favorite_outline, const WishlistPage(), isReplacement: true),
                
                if (userProvider.isAdmin) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline, color: Color(0xFFE53935)),
                    title: const Text("Tambah Data (Admin)", style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (c) => const AddPlacePage()));
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ]
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Keluar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () async {
                await userProvider.signOut();
                if (context.mounted) {
                   Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Widget page, {bool isReplacement = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        if (isReplacement) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => page));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (c) => page));
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}