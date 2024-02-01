import 'package:flutter/material.dart';
import 'package:future_provider_with_api/photos_jsonholder/photos_crud.dart';
import 'package:future_provider_with_api/photos_jsonholder/photos_datamodel.dart';
import 'package:future_provider_with_api/photos_jsonholder/photos_provider_class.dart';
import 'package:provider/provider.dart';

class PhotosHome extends StatefulWidget {
  const PhotosHome({super.key});

  @override
  State<PhotosHome> createState() => _PhotosHomeState();
}

class _PhotosHomeState extends State<PhotosHome> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<List<Photos>>(
          create: (context) =>
              PhotosProvider().fetchPosts("title", "url","thumbnailUrl", 123),
          initialData: [], // Set initialData to an appropriate initial value
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Get List'),
        ),
        body: Consumer<List<Photos>>(
          builder: (context, posts, _) {
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
                        width: 50, // Specify the desired width
                        child: Image.network(
                          post.url, // Assuming post.email contains a valid image URL
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _handleFloatingActionButton(context);
          },
          tooltip: 'Create Post',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
  void _handleFloatingActionButton(BuildContext context) {
    // Handle the tap on the floating action button here
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotosCrud()));
    // You can implement the logic to create a new post or navigate to a new page for post creation
  }
}
