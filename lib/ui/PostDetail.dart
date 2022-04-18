

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpostapi/model/Post.dart';
import 'package:http/http.dart';

/*
       CreatedBy: Ankit Agrahari
       CreatedDate: 15/04/2022
       Description: This class is used to show the details of specific Post.
*/
class PostDetail extends StatelessWidget {
  final Post mPost;
  const PostDetail({required this.mPost, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Post Detail'),
    ), body: MyPostDetailPage(post: mPost));
  }
}

class MyPostDetailPage extends StatefulWidget {
  final Post post;
  const MyPostDetailPage({required this.post ,Key? key}) : super(key: key);

  @override
  PostDetailState createState()  => PostDetailState();
}

class PostDetailState extends State<MyPostDetailPage> {

  @override
  Widget build(BuildContext context) {
      return Scaffold(body: SingleChildScrollView(child:
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child:  Column(children: <Widget> [
            const Text('Post Detail', style:  TextStyle(fontSize: 20, color: Colors.black87,), textAlign: TextAlign.center,),
            const SizedBox(height: 30),

        Row(
          children: [
            const Expanded(flex: 2, child: Text('User Id', style:  TextStyle(fontSize: 17, color: Colors.black87,)),),
            const Padding(padding: EdgeInsets.only(left: 15)),
            Expanded(flex: 8, child: Text('${widget.post.userId}', style: const TextStyle(fontSize: 17, color: Colors.black87,)),),

          ],),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(flex: 2, child: Text('Id', style:  TextStyle(fontSize: 17, color: Colors.black87,)),),
            const Padding(padding: EdgeInsets.only(left: 15)),
            Expanded(flex: 8, child: Text('${widget.post.id}', style: const TextStyle(fontSize: 17, color: Colors.black87)),),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(flex: 2, child: Text('Title', style:  TextStyle(fontSize: 17, color: Colors.black87,)),),
            const Padding(padding: EdgeInsets.only(left: 15)),
            Expanded(flex: 8, child: Text(widget.post.title, style: const TextStyle(fontSize: 17, color: Colors.black87,)),),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const Expanded(flex: 2, child: Text('Body', style:  TextStyle(fontSize: 17, color: Colors.black87,)),),
            const Padding(padding: EdgeInsets.only(left: 15)),
            Expanded(flex: 8, child: Text(widget.post.body, style: const TextStyle(fontSize: 17, color: Colors.black87,)),),
          ],
        ),
        const SizedBox(height: 30),
        ]))));
  }
}