import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class PBlogDetailScreen extends StatelessWidget {
  final PzBlogModel? data;
  const PBlogDetailScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var blog = data;
    if (blog == null) {
      return const Text('Blog data is loading');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                blog.coverImage,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (c, e, s) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 60),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(blog.authorAvatar),
                        radius: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          blog.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Icon(Icons.visibility, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 2),
                      Text(
                        '${blog.viewCount}',
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.thumb_up, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 2),
                      Text(
                        '${blog.likesCount}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    blog.tags.join(' • '),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    blog.content,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${blog.readTimeMinutes} min read',
                        style: const TextStyle(fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        'Published: ${blog.publishedAt.split('T').first}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
