import 'package:flutter/material.dart';

class SocialMediaRow extends StatelessWidget {
  const SocialMediaRow({super.key});

  void showSocialMedia(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name diklik'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            showSocialMedia(context, 'Instagram');
          },
          icon: const Icon(
            Icons.camera_alt,
            size: 30,
          ),
          tooltip: 'Instagram',
        ),

        IconButton(
          onPressed: () {
            showSocialMedia(context, 'LinkedIn');
          },
          icon: const Icon(
            Icons.work,
            size: 30,
          ),
          tooltip: 'LinkedIn',
        ),

        IconButton(
          onPressed: () {
            showSocialMedia(context, 'GitHub');
          },
          icon: const Icon(
            Icons.code,
            size: 30,
          ),
          tooltip: 'GitHub',
        ),
      ],
    );
  }
}