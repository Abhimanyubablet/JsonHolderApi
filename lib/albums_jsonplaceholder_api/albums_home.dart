import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'albums_crud_api_page.dart';
import 'albums_datamodel.dart';
import 'albums_provider_class.dart';

class AlbumsHome extends StatefulWidget {
  const AlbumsHome({super.key});

  @override
  State<AlbumsHome> createState() => _AlbumsHomeState();
}

class _AlbumsHomeState extends State<AlbumsHome> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<List<Albums>>(
          create: (context) =>
              AlbumsProvider().fetchPosts("title", 123),
          initialData: [], // Set initialData to an appropriate initial value
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Get List'),
        ),
        body: Consumer<List<Albums>>(
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
                        child: Text(post.userId.toString()),
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
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AlbumsCrud()));
    // You can implement the logic to create a new post or navigate to a new page for post creation
  }


}
