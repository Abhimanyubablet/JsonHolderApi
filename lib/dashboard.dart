import 'package:flutter/material.dart';
import 'package:future_provider_with_api/home.dart';
import 'package:future_provider_with_api/photos_jsonholder/photos_home.dart';
import 'package:future_provider_with_api/todos_jsonHolder/todo_home.dart';
import 'package:future_provider_with_api/users_jsonholder/users_home.dart';

import 'albums_jsonplaceholder_api/albums_home.dart';
import 'comments_api_jsonholder/comments_home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Main Page"),
      ),

      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                } ,
                child: Text("Posts Jsonholder api")),


            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentsHomePage()));
                } ,
                child: Text("Comments Jsonholder api")),

            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AlbumsHome()));
                } ,
                child: Text("Albums Jsonholder api")),

            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotosHome()));
                } ,
                child: Text("Photos Jsonholder api")),

            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TodoHome()));
                } ,
                child: Text("Todo Jsonholder api")),

            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome()));
                } ,
                child: Text("Users Jsonholder api")),

          ],
        ),
      ) ,

    );
  }
}
