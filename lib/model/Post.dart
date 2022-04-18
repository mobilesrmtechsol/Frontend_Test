import 'dart:convert';

class Post {
    final int userId;
    final int id;
    final String title;
    String body = '';

    Post({required this.userId, required this.id, required this.title, this.body = ''});

    factory Post.fromJson(Map<String, dynamic> jObj) {
        return Post(id: jObj['id'], title: jObj['title'], userId: jObj['userId'], body: jObj['body']);
    }

    @override
    String toString() {
        return 'Post{userId: $userId, id: $id, title: $title, body: $body}';
    }
}