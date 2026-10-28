import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';

class PostListScreen
    extends StatefulWidget {
  const PostListScreen({
    super.key,
  });

  @override
  State<PostListScreen> createState() =>
      _PostListScreenState();
}

class _PostListScreenState
    extends State<PostListScreen> {
  final ApiService _apiService =
      ApiService();

  List<Post> _posts = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadPosts();
  }

  // =========================
  // LOAD POSTS
  // =========================

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final posts =
          await _apiService.getPosts();

      if (!mounted) return;

      setState(() {
        _posts = posts;
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
              onPressed: _loadPosts,
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
  // POST LIST
  // =========================

  Widget _buildPostList() {
    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _posts.length,
        itemBuilder: (
          context,
          index,
        ) {
          final post = _posts[index];

          return Card(
            margin:
                const EdgeInsets.only(
              bottom: 12,
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  '${post.id}',
                ),
              ),
              title: Text(
                post.title,
              ),
              subtitle: Text(
                post.body,
              ),
              isThreeLine: true,
            ),
          );
        },
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
          'Daftar Posts',
        ),
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? _buildError()
              : _buildPostList(),
    );
  }
}