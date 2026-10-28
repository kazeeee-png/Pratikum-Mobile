import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/user_card.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({
    super.key,
  });

  @override
  State<UserListScreen> createState() =>
      _UserListScreenState();
}

class _UserListScreenState
    extends State<UserListScreen> {
  final ApiService _apiService =
      ApiService();

  final TextEditingController
      _searchController =
      TextEditingController();

  List<User> _users = [];
  List<User> _filteredUsers = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadUsers();

    _searchController.addListener(
      _filterUsers,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // =========================
  // LOAD USERS
  // =========================

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users =
          await _apiService.getUsers();

      if (!mounted) return;

      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // =========================
  // SEARCH USER
  // =========================

  void _filterUsers() {
    final keyword =
        _searchController.text.toLowerCase();

    setState(() {
      _filteredUsers = _users.where((user) {
        return user.name
                .toLowerCase()
                .contains(keyword) ||
            user.email
                .toLowerCase()
                .contains(keyword);
      }).toList();
    });
  }

  // =========================
  // USER DETAIL
  // =========================

  Future<void> _showUserDetail(
    User user,
  ) async {
    try {
      final detail =
          await _apiService.getUserById(
        user.id,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              detail.name,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Username: ${detail.username}',
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${detail.email}',
                ),
                const SizedBox(height: 8),
                Text(
                  'Phone: ${detail.phone}',
                ),
                const SizedBox(height: 8),
                Text(
                  'Website: ${detail.website}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Tutup',
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // =========================
  // ERROR
  // =========================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ??
                  'Terjadi kesalahan.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUsers,
              child: const Text(
                'Coba Lagi',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar User',
        ),
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? _buildError()
              : Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.all(
                        12,
                      ),
                      child: TextField(
                        controller:
                            _searchController,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Cari user',
                          hintText:
                              'Nama atau email',
                          prefixIcon:
                              Icon(Icons.search),
                          border:
                              OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          _filteredUsers.isEmpty
                              ? const Center(
                                  child: Text(
                                    'User tidak ditemukan',
                                  ),
                                )
                              : ListView.builder(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 12,
                                  ),
                                  itemCount:
                                      _filteredUsers
                                          .length,
                                  itemBuilder:
                                      (context,
                                          index) {
                                    final user =
                                        _filteredUsers[
                                            index];

                                    return UserCard(
                                      user: user,
                                      onTap: () {
                                        _showUserDetail(
                                          user,
                                        );
                                      },
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
    );
  }
}