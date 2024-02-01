import 'package:flutter/material.dart';
import 'package:future_provider_with_api/provider_class.dart';
import 'package:provider/provider.dart';

import 'DataModel.dart';

class AnotherHome extends StatefulWidget {
  const AnotherHome({Key? key}) : super(key: key);

  @override
  State<AnotherHome> createState() => _AnotherHomeState();
}

class _AnotherHomeState extends State<AnotherHome> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  final TextEditingController updateTitleController = TextEditingController();
  final TextEditingController updateBodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(create: (_) => PostProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create, Update, Delete List'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<PostProvider>(
                builder: (context, postProvider, _) {
                  List<Post> posts = postProvider.posts;

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
                            title: Text(post.title.toString()),
                            leading: Container(
                              width: 50,
                              child: Text(post.body.toString()),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    titleController.text = post.title;
                                    bodyController.text = post.body;

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Update Post'),
                                          content: Column(
                                            children: [
                                              TextField(
                                                controller: updateTitleController,
                                                decoration: InputDecoration(
                                                    labelText: 'Title'),
                                              ),
                                              TextField(
                                                controller: updateBodyController,
                                                decoration: InputDecoration(
                                                    labelText: 'Body'),
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
                                                final updatedPost = Post(
                                                  userId: post.userId,
                                                  id: post.id,
                                                  title: updateTitleController.text,
                                                  body: updateBodyController.text,
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
            Consumer<PostProvider>(
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
                        controller: titleController,
                        decoration: InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: bodyController,
                        decoration: InputDecoration(labelText: 'Body'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final newPost = Post(
                            userId: 1,
                            id: 0,
                            title: titleController.text,
                            body: bodyController.text,
                          );
                          await postProvider.createPost(newPost, context);

                          titleController.clear();
                          bodyController.clear();
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