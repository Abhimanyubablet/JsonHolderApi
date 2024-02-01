import 'package:flutter/material.dart';
import 'package:future_provider_with_api/photos_jsonholder/photos_datamodel.dart';
import 'package:future_provider_with_api/photos_jsonholder/photos_provider_class.dart';
import 'package:provider/provider.dart';

class PhotosCrud extends StatefulWidget {
  const PhotosCrud({super.key});

  @override
  State<PhotosCrud> createState() => _PhotosCrudState();
}

class _PhotosCrudState extends State<PhotosCrud> {

  final TextEditingController photosTitleController = TextEditingController();
  final TextEditingController photosAlbumIdController = TextEditingController();

  final TextEditingController updatePhotosTitleController = TextEditingController();
  final TextEditingController updatePhotosAlbumIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PhotosProvider>(create: (_) => PhotosProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comments crud api'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<PhotosProvider>(
                builder: (context, postProvider, _) {
                  List<Photos> posts = postProvider.posts;

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
                              child: Text(post.albumId.toString()),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    photosTitleController.text = post.title;
                                    photosAlbumIdController.text = post.albumId.toString();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Update Post'),
                                          content: Column(
                                            children: [
                                              TextField(
                                                controller: updatePhotosTitleController,
                                                decoration: InputDecoration(
                                                  labelText: 'Title',
                                                ),
                                              ),
                                              TextField(
                                                controller: updatePhotosAlbumIdController,
                                                decoration: InputDecoration(
                                                  labelText: 'AlbumId',
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
                                                final updatedPost = Photos(
                                                  id: post.id,
                                                  title: updatePhotosTitleController.text,
                                                  albumId: int.parse(updatePhotosAlbumIdController.text), url: '', thumbnailUrl: '',
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
            Consumer<PhotosProvider>(
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
                        controller: photosTitleController,
                        decoration: InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: photosAlbumIdController,
                        decoration: InputDecoration(labelText: 'AlbumId'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final newPost = Photos(
                              id: 0,
                              title: photosTitleController.text,
                              albumId: int.parse(photosAlbumIdController.text), url: '', thumbnailUrl: '',
                            );
                            await postProvider.createPost(newPost, context);

                            photosTitleController.clear();
                            photosAlbumIdController.clear();
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
