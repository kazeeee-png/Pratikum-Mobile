import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/secure_storage_service.dart';
import 'user_list_screen.dart';
import 'post_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  final ApiService _apiService =
      ApiService();

  final SecureStorageService
      _secureStorage =
      SecureStorageService();

  final TextEditingController
      _emailController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isLoggedIn = false;

  String? _token;

  @override
  void initState() {
    super.initState();

    _checkLoginStatus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // =========================
  // CHECK LOGIN
  // =========================

  Future<void> _checkLoginStatus() async {
    final token =
        await _secureStorage.getToken();

    if (!mounted) return;

    setState(() {
      _token = token;
      _isLoggedIn =
          token != null && token.isNotEmpty;
    });
  }

  // =========================
  // LOGIN
  // =========================

  Future<void> _login() async {
    final email =
        _emailController.text.trim();

    final password =
        _passwordController.text;

    if (email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Email dan password tidak boleh kosong.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token =
          await _apiService.login(
        email,
        password,
      );

      await _secureStorage.saveToken(
        token,
      );

      if (!mounted) return;

      setState(() {
        _token = token;
        _isLoggedIn = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Login berhasil.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

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
  // LOGOUT
  // =========================

  Future<void> _logout() async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi Logout',
          ),
          content: const Text(
            'Apakah kamu yakin ingin logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Batal',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Logout',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _secureStorage.deleteToken();

    if (!mounted) return;

    setState(() {
      _token = null;
      _isLoggedIn = false;
    });

    _emailController.clear();
    _passwordController.clear();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Logout berhasil.',
        ),
      ),
    );
  }

  // =========================
  // LOGIN SCREEN
  // =========================

  Widget _buildLoginScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.lock_outline,
              size: 80,
            ),

            const SizedBox(height: 20),

            const Text(
              'Login',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller:
                  _emailController,
              keyboardType:
                  TextInputType.emailAddress,
              decoration:
                  const InputDecoration(
                labelText: 'Email',
                prefixIcon:
                    Icon(Icons.email),
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  _passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText: 'Password',
                prefixIcon:
                    Icon(Icons.lock),
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : _login,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Login',
                      ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Gunakan email dan password apa saja '
              'yang tidak kosong untuk simulasi login.',
              textAlign:
                  TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // HOME SETELAH LOGIN
  // =========================

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.verified_user,
            size: 70,
          ),

          const SizedBox(height: 16),

          const Text(
            'Status Login',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Login berhasil',
            style: TextStyle(
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding:
                  const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Token tersimpan:',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _token ?? '-',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const UserListScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.people,
              ),
              label: const Text(
                'Daftar User',
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const PostListScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.article,
              ),
              label: const Text(
                'Daftar Posts',
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(
                Icons.logout,
              ),
              label: const Text(
                'Logout',
              ),
            ),
          ),
        ],
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
        title: Text(
          _isLoggedIn
              ? 'Home'
              : 'Login',
        ),
      ),
      body: _isLoggedIn
          ? _buildHomeContent()
          : _buildLoginScreen(),
    );
  }
}