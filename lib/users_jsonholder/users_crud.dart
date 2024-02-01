import 'package:flutter/material.dart';
import 'package:future_provider_with_api/users_jsonholder/users_datamodel.dart';
import 'package:future_provider_with_api/users_jsonholder/users_provider_class.dart';
import 'package:provider/provider.dart';

class UserCrud extends StatefulWidget {
  const UserCrud({Key? key}) : super(key: key);

  @override
  State<UserCrud> createState() => _UserCrudState();
}

class _UserCrudState extends State<UserCrud> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final TextEditingController updateUserNameController = TextEditingController();
  final TextEditingController updateNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersProvider>(create: (_) => UsersProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create, Update, Delete List'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<UsersProvider>(
                builder: (context, postProvider, _) {
                  List<Users> posts = postProvider.posts ?? [];

                  if (posts.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        var post = posts[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(post.username ?? ''),
                            leading: Container(
                              width: 50,
                              child: Text(post.name ?? ''),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    updateUserNameController.text = post.username ?? '';
                                    updateNameController.text = post.name ?? '';

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Update Post'),
                                          content: Column(
                                            children: [
                                              TextField(
                                                controller: updateUserNameController,
                                                decoration: InputDecoration(labelText: 'UserName'),
                                              ),
                                              TextField(
                                                controller: updateNameController,
                                                decoration: InputDecoration(labelText: 'Name'),
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
                                                // Validate and handle null values
                                                final updatedPost = Users(
                                                  id: 0,
                                                  name: nameController.text ?? '',
                                                  username: userNameController.text ?? '',
                                                  email: '',
                                                  address: Address(
                                                    street: '',
                                                    suite: '',
                                                    city: '',
                                                    zipcode: '',
                                                    geo: Geo(lat: '', lng: ''),
                                                  ),
                                                  phone: '',
                                                  website: '',
                                                  company: Company(
                                                    name: '',
                                                    catchPhrase: '',
                                                    bs: '',
                                                  ),
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
            Consumer<UsersProvider>(
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
                        controller: userNameController,
                        decoration: InputDecoration(labelText: 'UserName'),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          // Validate and handle null values
                          final newPost = Users(
                            id: 0,
                            name: nameController.text ?? '',
                            username: userNameController.text ?? '',
                            email: '',
                            address: Address(
                              street: '',
                              suite: '',
                              city: '',
                              zipcode: '',
                              geo: Geo(lat: '', lng: ''),
                            ),
                            phone: '',
                            website: '',
                            company: Company(
                              name: '',
                              catchPhrase: '',
                              bs: '',
                            ),
                          );
                          await postProvider.createPost(newPost, context);
                          userNameController.clear();
                          nameController.clear();
                        },
                        child: Text('Add User'),
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


