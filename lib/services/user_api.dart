import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../models/user.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../models/album.dart';
import '../models/photo.dart';
import '../models/todo.dart';

class UserApi {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  // Users
  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Posts
  static Future<List<Post>> fetchPosts({int? userId}) async {
    final url = userId == null 
        ? '$_baseUrl/posts' 
        : '$_baseUrl/posts?userId=$userId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Comments
  static Future<List<Comment>> fetchComments({int? postId}) async {
    final url = postId == null
        ? '$_baseUrl/comments'
        : '$_baseUrl/comments?postId=$postId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  // Albums
  static Future<List<Album>> fetchAlbums({int? userId}) async {
    final url = userId == null
        ? '$_baseUrl/albums'
        : '$_baseUrl/albums?userId=$userId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  // Photos
  static Future<List<Photo>> fetchPhotos({int? albumId}) async {
    final url = albumId == null
        ? '$_baseUrl/photos'
        : '$_baseUrl/photos?albumId=$albumId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }

  // Todos
  static Future<List<Todo>> fetchTodos({int? userId, bool? completed}) async {
    String url = '$_baseUrl/todos';
    if (userId != null) url += '?userId=$userId';
    if (completed != null) {
      url += '${userId == null ? '?' : '&'}completed=$completed';
    }
    
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  // Get user with all data
  static Future<Map<String, dynamic>> getUserWithData(int userId) async {
    try {
      final user = (await fetchUsers()).firstWhere((u) => u.id == userId);
      final posts = await fetchPosts(userId: userId);
      final albums = await fetchAlbums(userId: userId);
      final todos = await fetchTodos(userId: userId);

      return {
        'user': user,
        'posts': posts,
        'albums': albums,
        'todos': todos,
      };
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }
}
