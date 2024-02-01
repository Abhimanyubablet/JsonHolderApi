import 'package:flutter/material.dart';
import 'package:future_provider_with_api/todos_jsonHolder/todo_datamodel.dart';
import 'package:future_provider_with_api/todos_jsonHolder/todo_provider_class.dart';
import 'package:provider/provider.dart';

class TodoCrud extends StatefulWidget {
  const TodoCrud({super.key});

  @override
  State<TodoCrud> createState() => _TodoCrudState();
}

class _TodoCrudState extends State<TodoCrud> {

  final TextEditingController TodoTitleController = TextEditingController();
  final TextEditingController TodoUserIdController = TextEditingController();

  final TextEditingController updateTodoTitleController = TextEditingController();
  final TextEditingController updateTodoUserIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoProvider>(create: (_) => TodoProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comments crud api'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<TodoProvider>(
                builder: (context, postProvider, _) {
                  List<Todo> posts = postProvider.posts;

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
                                    TodoTitleController.text = post.title;
                                    TodoUserIdController.text = post.userId.toString();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Update Post'),
                                          content: Column(
                                            children: [
                                              TextField(
                                                controller: updateTodoTitleController,
                                                decoration: InputDecoration(
                                                  labelText: 'Title',
                                                ),
                                              ),
                                              TextField(
                                                controller: updateTodoUserIdController,
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
                                                final updatedPost = Todo(
                                                  id: post.id,
                                                  title: updateTodoTitleController.text,
                                                  userId: int.parse(updateTodoUserIdController.text), completed: false,
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
            Consumer<TodoProvider>(
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
                        controller: TodoTitleController,
                        decoration: InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: TodoUserIdController,
                        decoration: InputDecoration(labelText: 'UserId'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final newPost = Todo(
                              id: 0,
                              title: TodoTitleController.text,
                              userId: int.parse(TodoUserIdController.text), completed: false
                            );
                            await postProvider.createPost(newPost, context);

                            TodoTitleController.clear();
                            TodoUserIdController.clear();
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
