import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com/posts";

  // GET all posts
  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }

  // CREATE post
  static Future<void> createPost(Post post) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-type": "application/json"},
      body: json.encode(post.toJson()),
    );
  }

  // UPDATE post
  static Future<void> updatePost(Post post) async {
    await http.put(
      Uri.parse("$baseUrl/${post.id}"),
      headers: {"Content-type": "application/json"},
      body: json.encode(post.toJson()),
    );
  }

  // DELETE post
  static Future<void> deletePost(int id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}
