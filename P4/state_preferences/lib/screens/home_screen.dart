import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (
        context,
        provider,
        child,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            backgroundColor:
                Colors.deepPurple,
            foregroundColor: Colors.white,

            // Latihan 1
            actions: [
              IconButton(
                tooltip: provider.isDarkMode
                    ? 'Mode Terang'
                    : 'Mode Gelap',
                icon: Icon(
                  provider.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed:
                    provider.toggleDarkMode,
              ),
            ],
          ),

          body: provider.isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )
              : Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.home,
                          size: 80,
                          color:
                              Colors.deepPurple,
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        Text(
                          provider.user.isLoggedIn
                              ? 'Selamat datang, ${provider.user.name}!'
                              : 'Selamat datang, Tamu!',
                          style:
                              const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                          textAlign:
                              TextAlign.center,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        if (provider
                            .user
                            .isLoggedIn) ...[
                          Text(
                            'Email: ${provider.user.email}',
                            style:
                                const TextStyle(
                              fontSize: 14,
                              color:
                                  Colors.grey,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                        ],

                        // Latihan 2
                        Card(
                          child: Padding(
                            padding:
                                const EdgeInsets
                                    .all(16),
                            child: Text(
                              'Aplikasi telah dibuka '
                              '${provider.visitCount} kali',
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const ProfileScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            provider.user
                                    .isLoggedIn
                                ? Icons.person
                                : Icons.login,
                          ),
                          label: Text(
                            provider.user
                                    .isLoggedIn
                                ? 'Lihat Profil'
                                : 'Login / Daftar',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}