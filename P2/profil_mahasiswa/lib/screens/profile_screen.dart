import 'package:flutter/material.dart';

import '../widgets/profile_photo.dart';
import '../widgets/profile_info.dart';
import '../widgets/social_media_row.dart';
import 'about_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // =========================
          // BAGIAN PROFILE
          // =========================
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),

                    // Foto profil
                    const ProfilePhoto(
                      radius: 60,
                    ),

                    const SizedBox(height: 24),

                    const ProfileInfo(
                      name: 'Yusuf Maulana Al Ikhsan',
                      nim: '25.11.6382',
                      programStudi: 'S1 Informatika',
                      email: 'y.maulana@students.amikom.ac.id',
                      lokasi: 'Yogyakarta, Indonesia',
                    ),

                    const SizedBox(height: 20),

                    const SocialMediaRow(),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.info),
                      label: const Text('Tentang Aplikasi'),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),

                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    label: const Text('Bagikan'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}