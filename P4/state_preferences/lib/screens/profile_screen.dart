import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final _formKey =
      GlobalKey<FormState>();

  late TextEditingController
      _nameController;

  late TextEditingController
      _emailController;

  final TextEditingController
      _favoriteController =
      TextEditingController();

  bool _initialized = false;

  // =========================
  // FIX ERROR MODUL
  // =========================

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final provider =
          context.read<UserProvider>();

      _nameController =
          TextEditingController(
        text: provider.user.name,
      );

      _emailController =
          TextEditingController(
        text: provider.user.email,
      );

      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _favoriteController.dispose();

    super.dispose();
  }

  // =========================
  // LATIHAN 5
  // =========================

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final name =
        _nameController.text.trim();

    final email =
        _emailController.text.trim();

    final provider =
        context.read<UserProvider>();

    // Cek karakter/tag berbahaya
    final dangerousPattern = RegExp(
      r'<\s*/?\s*script\b[^>]*>',
      caseSensitive: false,
    );

    if (dangerousPattern.hasMatch(
      name,
    )) {
      _showError(
        'Nama mengandung karakter berbahaya.',
      );
      return;
    }

    // Cek email dari SharedPreferences
    final prefs =
        await SharedPreferences
            .getInstance();

    final savedEmail =
        prefs.getString(
      'user_email',
    );

    // Kalau email sama dengan email
    // milik user sekarang, tetap boleh.
    if (savedEmail != null &&
        savedEmail.isNotEmpty &&
        savedEmail.toLowerCase() ==
            email.toLowerCase() &&
        savedEmail.toLowerCase() !=
            provider.user.email
                .toLowerCase()) {
      _showError(
        'Email sudah digunakan.',
      );
      return;
    }

    final updatedUser =
        provider.user.copyWith(
      name: name,
      email: email,
      isLoggedIn: true,
    );

    await provider.updateUser(
      updatedUser,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Profil berhasil disimpan',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> _logout() async {
    final result =
        await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
        title:
            const Text('Logout'),
        content: const Text(
          'Apakah Anda yakin ingin logout?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              false,
            ),
            child:
                const Text('Batal'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              true,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await context
          .read<UserProvider>()
          .logout();

      if (!mounted) return;

      Navigator.pop(context);
    }
  }

  // =========================
  // LATIHAN 3
  // =========================

  Future<void> _addFavorite() async {
    final value =
        _favoriteController.text
            .trim();

    if (value.isEmpty) {
      return;
    }

    await context
        .read<UserProvider>()
        .addFavorite(value);

    _favoriteController.clear();
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<UserProvider>(
      builder: (
        context,
        provider,
        child,
      ) {
        return Scaffold(
          appBar: AppBar(
            title:
                const Text('Profil'),
            backgroundColor:
                Colors.deepPurple,
            foregroundColor:
                Colors.white,

            actions: [
              if (provider
                  .user
                  .isLoggedIn)
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                  ),
                  onPressed: _logout,
                  tooltip: 'Logout',
                ),
            ],
          ),

          body: provider.isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .stretch,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),

                        const CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Colors
                                  .deepPurple,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color:
                                Colors.white,
                          ),
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        TextFormField(
                          controller:
                              _nameController,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Nama',
                            prefixIcon:
                                Icon(
                              Icons.person,
                            ),
                            border:
                                OutlineInputBorder(),
                          ),
                          validator:
                              (value) {
                            if (value ==
                                    null ||
                                value
                                    .trim()
                                    .isEmpty) {
                              return 'Nama tidak boleh kosong';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        TextFormField(
                          controller:
                              _emailController,
                          keyboardType:
                              TextInputType
                                  .emailAddress,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Email',
                            prefixIcon:
                                Icon(
                              Icons.email,
                            ),
                            border:
                                OutlineInputBorder(),
                          ),
                          validator:
                              (value) {
                            if (value ==
                                    null ||
                                value
                                    .trim()
                                    .isEmpty) {
                              return 'Email tidak boleh kosong';
                            }

                            final emailRegex =
                                RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            );

                            if (!emailRegex
                                .hasMatch(
                              value.trim(),
                            )) {
                              return 'Format email tidak valid';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        ElevatedButton
                            .icon(
                          onPressed:
                              _saveProfile,
                          icon:
                              const Icon(
                            Icons.save,
                          ),
                          label:
                              const Text(
                            'Simpan Profil',
                          ),
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                Colors
                                    .deepPurple,
                            foregroundColor:
                                Colors.white,
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical: 16,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 28,
                        ),

                        // =================
                        // FAVORIT
                        // =================

                        const Text(
                          'Daftar Favorit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child:
                                  TextField(
                                controller:
                                    _favoriteController,
                                decoration:
                                    const InputDecoration(
                                  labelText:
                                      'Tambah hobi',
                                  border:
                                      OutlineInputBorder(),
                                ),
                                onSubmitted:
                                    (_) =>
                                        _addFavorite(),
                              ),
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            IconButton.filled(
                              onPressed:
                                  _addFavorite,
                              icon:
                                  const Icon(
                                Icons.add,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        if (provider
                            .favorites
                            .isEmpty)
                          const Text(
                            'Belum ada favorit.',
                          )
                        else
                          ...provider
                              .favorites
                              .map(
                            (favorite) =>
                                Card(
                              child:
                                  ListTile(
                                leading:
                                    const Icon(
                                  Icons.star,
                                ),
                                title:
                                    Text(
                                  favorite,
                                ),
                                trailing:
                                    IconButton(
                                  icon:
                                      const Icon(
                                    Icons
                                        .delete,
                                  ),
                                  onPressed:
                                      () {
                                    provider
                                        .removeFavorite(
                                      favorite,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(
                          height: 20,
                        ),

                        // =================
                        // CATATAN KEAMANAN
                        // =================

                        Card(
                          color:
                              Colors.amber[50],
                          child:
                              const Padding(
                            padding:
                                EdgeInsets.all(
                              16,
                            ),
                            child:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'Catatan Keamanan',
                                      style:
                                          TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 8,
                                ),

                                Text(
                                  'Data disimpan di SharedPreferences (plaintext). '
                                  'Jangan simpan password atau data sensitif di sini. '
                                  'Gunakan secure storage untuk data sensitif.',
                                  style:
                                      TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
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