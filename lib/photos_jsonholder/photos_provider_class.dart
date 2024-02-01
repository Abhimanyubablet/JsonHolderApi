import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_provider_with_api/photos_jsonholder/photos_datamodel.dart';
import 'package:http/http.dart ' as http;

class PhotosProvider extends ChangeNotifier{
  List<Photos> _posts = [];
  List<Photos> get posts => _posts;

  Future<List<Photos>> fetchPosts(String title,String url, String thumbnailUrl, int albumId) async{

    try{

      var response= await http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"),headers: {});

      if(response.statusCode == 200){
        List<dynamic> jsonData= jsonDecode(response.body);
        List<Photos> posts= jsonData.map((json)=>Photos.fromJson(json)).toList();
        return posts;
      }
      else{
        throw Exception ('Failed to load data');
      }
    }catch(e){
      throw Exception("Failed to load data:$e");
    }

  }


  // Method for POST request
  Future<Photos> createPost(Photos post, BuildContext context ) async {
    try {
      var postResponse = await http.post(
        Uri.parse("https://jsonplaceholder.typicode.com/photos"),
        body: jsonEncode(post.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (postResponse.statusCode == 201) {
        final newPost = Photos.fromJson(jsonDecode(postResponse.body));
        _posts.add(newPost); // Add the new post to the list
        notifyListeners(); // Notify listeners about the change

        // Show a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post created successfully'),
            duration: Duration(seconds: 2), // You can adjust the duration as needed
          ),
        );

        return newPost;
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Method for DELETE request
  Future<void> deletePost(int postId,BuildContext context) async {
    try {
      var deleteResponse = await http.delete(
        Uri.parse("https://jsonplaceholder.typicode.com/photos/$postId"),
        headers: {'Content-Type': 'application/json'},
      );

      if (deleteResponse.statusCode == 200) {
        // Post successfully deleted
        _posts.removeWhere((post) => post.id == postId); // Remove the post from the list
        notifyListeners(); // Notify listeners about the change

        // Show a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post delete successfully'),
            duration: Duration(seconds: 2), // You can adjust the duration as needed
          ),
        );
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  // Method for PUT request
  Future<Photos> updatePost(Photos post,BuildContext context) async {
    try {
      var putResponse = await http.put(
        Uri.parse("https://jsonplaceholder.typicode.com/photos/${post.id}"),
        body: jsonEncode(post.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      print("PUT response status code: ${putResponse.statusCode}");
      print("PUT response body: ${putResponse.body}");

      if (putResponse.statusCode == 200) {
        final replacedPost = Photos.fromJson(jsonDecode(putResponse.body));
        int index = _posts.indexWhere((p) => p.id == replacedPost.id);

        if (index != -1) {
          _posts[index] = replacedPost; // Update the post in the list
          notifyListeners(); // Notify listeners about the change

          // Show a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Post update successfully'),
              duration: Duration(seconds: 2), // You can adjust the duration as needed
            ),
          );

          return replacedPost;
        } else {
          print("Post with id ${replacedPost.id} not found in the list.");
          throw Exception('Failed to replace post: Post not found');
        }
      } else {
        print("PUT request failed with status code ${putResponse.statusCode}");
        throw Exception('Failed to replace post');
      }
    } catch (e) {
      print('Failed to replace post: $e');
      throw Exception('Failed to replace post: $e');
    }
  }
}
