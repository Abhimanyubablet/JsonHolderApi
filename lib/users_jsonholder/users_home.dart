import 'package:flutter/material.dart';
import 'package:future_provider_with_api/users_jsonholder/users_crud.dart';
import 'package:future_provider_with_api/users_jsonholder/users_datamodel.dart';
import 'package:future_provider_with_api/users_jsonholder/users_provider_class.dart';
import 'package:provider/provider.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<List<Users>>(
          create: (context) =>
              UsersProvider().fetchPosts("username","name"),
          initialData: [], // Set initialData to an appropriate initial value
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Get List'),
        ),
        body: Consumer<List<Users>>(
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
                      title: Text(post.username.toString()),
                      leading: Container(
                        width: 50, // Specify the desired width
                        child: Text(post.name.toString()),
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
    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserCrud()));
    // You can implement the logic to create a new post or navigate to a new page for post creation
  }


}
