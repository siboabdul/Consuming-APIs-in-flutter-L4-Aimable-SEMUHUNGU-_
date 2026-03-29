import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detail.dart';
import 'add_edit_post.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  HomeScreen({required this.toggleTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    posts = ApiService.fetchPosts();
  }

  void refresh() {
    setState(() {
      fetchData();
    });
  }

  void deletePost(int id) async {
    await ApiService.deletePost(id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Post deleted")));
    refresh();
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deletePost(id);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  void openAddEdit({Post? post}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditPost(post: post)),
    );
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts Manager"),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddEdit(),
        child: Icon(Icons.add),
      ),

      body: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final postsList = snapshot.data!;

          return ListView.builder(
            itemCount: postsList.length,
            itemBuilder: (context, index) {
              final post = postsList[index];

              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => openAddEdit(post: post),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => confirmDelete(post.id!),
                          ),
                        ],
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetail(post: post),
                            ),
                          );
                        },
                        child: Text(
                          "View Details",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
