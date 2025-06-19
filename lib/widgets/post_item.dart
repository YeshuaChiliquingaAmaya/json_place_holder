import 'package:flutter/material.dart';
import 'package:json_place_holder/models/post.dart';
import 'package:json_place_holder/services/user_api.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.body,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.comment, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                FutureBuilder<int>(
                  future: UserApi.fetchComments(postId: post.id).then((comments) => comments.length),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('...');
                    }
                    return Text(
                      '${snapshot.data ?? 0} comentarios',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
