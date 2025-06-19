import 'package:flutter/material.dart';
import 'package:json_place_holder/models/user.dart';
import 'package:json_place_holder/models/post.dart';
import 'package:json_place_holder/models/album.dart';
import 'package:json_place_holder/models/todo.dart';
import 'package:json_place_holder/services/user_api.dart';
import 'package:json_place_holder/screens/detail_screen.dart';
import 'package:json_place_holder/widgets/user_item.dart';
import 'package:json_place_holder/widgets/post_item.dart';
import 'package:json_place_holder/widgets/album_item.dart';
import 'package:json_place_holder/widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<User>> futureUsers;
  late Future<List<Post>> futurePosts;
  late Future<List<Album>> futureAlbums;
  late Future<List<Todo>> futureTodos;
  String _searchQuery = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      futureUsers = UserApi.fetchUsers();
      futurePosts = UserApi.fetchPosts();
      futureAlbums = UserApi.fetchAlbums();
      futureTodos = UserApi.fetchTodos();
    });
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSONPlaceholder Social'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Usuarios'),
            Tab(icon: Icon(Icons.article), text: 'Publicaciones'),
            Tab(icon: Icon(Icons.photo_album), text: 'Álbumes'),
            Tab(icon: Icon(Icons.check_circle), text: 'Tareas'),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: _getSearchHint(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUsersTab(),
                _buildPostsTab(),
                _buildAlbumsTab(),
                _buildTodosTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSearchHint() {
    switch (_currentIndex) {
      case 0:
        return 'Buscar usuarios...';
      case 1:
        return 'Buscar publicaciones...';
      case 2:
        return 'Buscar álbumes...';
      case 3:
        return 'Buscar tareas...';
      default:
        return 'Buscar...';
    }
  }

  Widget _buildUsersTab() {
    return FutureBuilder<List<User>>(
      future: futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron usuarios'));
        }

        final users = snapshot.data!;
        final filteredUsers = _searchQuery.isEmpty
            ? users
            : users.where((user) =>
                user.name.toLowerCase().contains(_searchQuery) ||
                user.email.toLowerCase().contains(_searchQuery) ||
                user.username.toLowerCase().contains(_searchQuery)).toList();

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return UserItem(
              user: user,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(user: user),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPostsTab() {
    return FutureBuilder<List<Post>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron publicaciones'));
        }

        final posts = snapshot.data!;
        final filteredPosts = _searchQuery.isEmpty
            ? posts
            : posts.where((post) =>
                post.title.toLowerCase().contains(_searchQuery) ||
                post.body.toLowerCase().contains(_searchQuery)).toList();

        return ListView.builder(
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) {
            final post = filteredPosts[index];
            return PostItem(post: post);
          },
        );
      },
    );
  }

  Widget _buildAlbumsTab() {
    return FutureBuilder<List<Album>>(
      future: futureAlbums,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron álbumes'));
        }

        final albums = snapshot.data!;
        final filteredAlbums = _searchQuery.isEmpty
            ? albums
            : albums.where((album) =>
                album.title.toLowerCase().contains(_searchQuery)).toList();

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.8,
          ),
          itemCount: filteredAlbums.length,
          itemBuilder: (context, index) {
            final album = filteredAlbums[index];
            return AlbumItem(album: album);
          },
        );
      },
    );
  }

  Widget _buildTodosTab() {
    return FutureBuilder<List<Todo>>(
      future: futureTodos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron tareas'));
        }

        final todos = snapshot.data!;
        final filteredTodos = _searchQuery.isEmpty
            ? todos
            : todos.where((todo) =>
                todo.title.toLowerCase().contains(_searchQuery)).toList();

        return ListView.builder(
          itemCount: filteredTodos.length,
          itemBuilder: (context, index) {
            final todo = filteredTodos[index];
            return TodoItem(todo: todo);
          },
        );
      },
    );
  }
}
