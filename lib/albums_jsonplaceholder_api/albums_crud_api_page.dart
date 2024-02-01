import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'albums_datamodel.dart';
import 'albums_provider_class.dart';

class AlbumsCrud extends StatefulWidget {
  const AlbumsCrud({super.key});

  @override
  State<AlbumsCrud> createState() => _AlbumsCrudState();
}

class _AlbumsCrudState extends State<AlbumsCrud> {
  final TextEditingController ablumsTitleController = TextEditingController();
  final TextEditingController albumsUserIdController = TextEditingController();

  final TextEditingController updateAlbumTitleController = TextEditingController();
  final TextEditingController updateAlbumUserIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AlbumsProvider>(create: (_) => AlbumsProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comments crud api'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<AlbumsProvider>(
                builder: (context, postProvider, _) {
                  List<Albums> posts = postProvider.posts;

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
                              child: Text(post.userId.toString()),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    ablumsTitleController.text = post.title;
                                    albumsUserIdController.text = post.userId.toString();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Update Post'),
                                          content: Column(
                                            children: [
                                              TextField(
                                                controller: updateAlbumTitleController,
                                                decoration: InputDecoration(
                                                  labelText: 'Title',
                                                ),
                                              ),
                                              TextField(
                                                controller: updateAlbumUserIdController,
                                                decoration: InputDecoration(
                                                  labelText: 'UserId',
                                                ),
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
                                                final updatedPost = Albums(
                                                  id: post.id,
                                                  title: updateAlbumTitleController.text,
                                                  userId: int.parse(updateAlbumUserIdController.text),
                                                );
                                                postProvider.updatePost(updatedPost, context);

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
            Consumer<AlbumsProvider>(
              builder: (context, postProvider, _) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create a new post:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: ablumsTitleController,
                        decoration: InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: albumsUserIdController,
                        decoration: InputDecoration(labelText: 'UserId'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final newPost = Albums(
                              id: 0,
                              title: ablumsTitleController.text,
                              userId: int.parse(albumsUserIdController.text),
                            );
                            await postProvider.createPost(newPost, context);

                            ablumsTitleController.clear();
                            albumsUserIdController.clear();
                          } catch (e) {
                            print("Error creating post: $e");
                          }
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
