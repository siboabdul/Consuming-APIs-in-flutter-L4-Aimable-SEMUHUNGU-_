import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class AddEditPost extends StatefulWidget {
  final Post? post;

  AddEditPost({this.post});

  @override
  _AddEditPostState createState() => _AddEditPostState();
}

class _AddEditPostState extends State<AddEditPost> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Fill fields if editing
    if (widget.post != null) {
      titleController.text = widget.post!.title;
      bodyController.text = widget.post!.body;
    }
  }

  Future<void> savePost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      if (widget.post == null) {
        await ApiService.createPost(
          Post(title: titleController.text, body: bodyController.text),
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Post added successfully")));
      } else {
        await ApiService.updatePost(
          Post(
            id: widget.post!.id,
            title: titleController.text,
            body: bodyController.text,
          ),
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Post updated successfully")));
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.post != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Post" : "Add Post")),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TITLE FIELD
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter title" : null,
              ),

              SizedBox(height: 15),

              // BODY FIELD
              TextFormField(
                controller: bodyController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Body",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter body" : null,
              ),

              SizedBox(height: 25),

              // BUTTON
              isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: savePost,
                        icon: Icon(isEdit ? Icons.update : Icons.add),
                        label: Text(isEdit ? "Update Post" : "Add Post"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: isEdit
                              ? Colors.orange
                              : Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
