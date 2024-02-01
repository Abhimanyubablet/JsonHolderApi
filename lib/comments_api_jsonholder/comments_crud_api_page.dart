import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'comments_datamodel.dart';
import 'comments_provider_class.dart';

class CommentsCrud extends StatefulWidget {
  const CommentsCrud({super.key});

  @override
  State<CommentsCrud> createState() => _CommentsCrudState();
}

class _CommentsCrudState extends State<CommentsCrud> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController updateNameController = TextEditingController();
  final TextEditingController updateEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommentsProvider>(create: (_) => CommentsProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comments crud api'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<CommentsProvider>(
                builder: (context, postProvider, _) {
                  List<Comments> posts = postProvider.posts;

                  if (posts == null) {
                    return Center(child: CircularProgressIndicator());
                  } else if (posts.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        var post = posts[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(post.name.toString()),
                            leading: Container(
                              width: 50,
                              child: Text(post.email.toString()),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    nameController.text = post.name;
                                    emailController.text = post.email;

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Update Post'),
                                          content: Column(
                                            children: [
                                              TextField(
                                                controller: updateNameController,
                                                decoration: InputDecoration(
                                                    labelText: 'Name'),
                                              ),
                                              TextField(
                                                controller: updateEmailController,
                                                decoration: InputDecoration(
                                                    labelText: 'Email'),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                final updatedPost = Comments(
                                                  postId: post.postId,
                                                  id: post.id,
                                                  name: updateNameController.text,
                                                  email: updateEmailController.text,
                                                  body: post.body,
                                                );
                                                postProvider
                                                    .updatePost(updatedPost, context);

                                                Navigator.pop(context);
                                              },
                                              child: Text('Update'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    postProvider.deletePost(post.id, context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Consumer<CommentsProvider>(
              builder: (context, postProvider, _) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create a new post:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final newPost = Comments(
                            postId: 1,
                            id: 0,
                            name: nameController.text,
                            email: emailController.text,
                            body: "Hello"
                          );
                          await postProvider.createPost(newPost, context);

                          nameController.clear();
                          emailController.clear();
                        },
                        child: Text('Add Post'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
