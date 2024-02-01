import 'package:flutter/material.dart';
import 'package:future_provider_with_api/another_home.dart';
import 'package:future_provider_with_api/provider_class.dart';
import 'package:provider/provider.dart';

import 'DataModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<List<Post>>(
          create: (context) =>
              PostProvider().fetchPosts("title", "body", 123),
          initialData: [], // Set initialData to an appropriate initial value
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Get List'),
        ),
        body: Consumer<List<Post>>(
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
                        child: Text(post.body.toString()),
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
   Navigator.push(context, MaterialPageRoute(builder: (context)=>AnotherHome()));
    // You can implement the logic to create a new post or navigate to a new page for post creation
  }
}
