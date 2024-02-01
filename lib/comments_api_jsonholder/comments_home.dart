import 'package:flutter/material.dart';
import 'package:future_provider_with_api/comments_api_jsonholder/comments_crud_api_page.dart';
import 'package:provider/provider.dart';

import 'comments_datamodel.dart';
import 'comments_provider_class.dart';

class CommentsHomePage extends StatefulWidget {
  const CommentsHomePage({super.key});

  @override
  State<CommentsHomePage> createState() => _CommentsHomePageState();
}

class _CommentsHomePageState extends State<CommentsHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<List<Comments>>(
          create: (context) =>
              CommentsProvider().fetchPosts("name", "email","body", 123),
          initialData: [], // Set initialData to an appropriate initial value
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Get List'),
        ),
        body: Consumer<List<Comments>>(
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
                      title: Text(post.name.toString()),
                      leading: Container(
                        width: 50, // Specify the desired width
                        child: Text(post.email.toString()),
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
    Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentsCrud()));
    // You can implement the logic to create a new post or navigate to a new page for post creation
  }

}
