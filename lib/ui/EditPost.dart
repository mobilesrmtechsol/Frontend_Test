

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpostapi/model/Post.dart';
import 'package:flutterpostapi/utility/Utils.dart';
import '../utility/Constant.dart' as constant;
import 'package:http/http.dart' as http;
import '../utility/ApiConstant.dart' as api_constant;

class EditPost extends StatelessWidget {
  final Post mPost;
  const EditPost({required this.mPost, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Edit Post'),
        ), body:  PostEditPage(post: mPost),
        );
  }
}

class PostEditPage extends StatefulWidget {
  final Post post;
  const PostEditPage({required this.post, Key? key}) : super(key: key);

  @override
  PostEditState createState()  => PostEditState();
}

class PostEditState extends State<PostEditPage> {
  final TextEditingController userIdEditing = TextEditingController();
  final TextEditingController postIdEditing = TextEditingController();
  final TextEditingController titleEditing = TextEditingController();
  final TextEditingController bodyEditing = TextEditingController();


  @override
  void initState() {
      super.initState();
      postIdEditing.text = widget.post.id.toString();
      userIdEditing.text = widget.post.userId.toString();
      titleEditing.text = widget.post.title.toString();
      bodyEditing.text = widget.post.body.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 50),

            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              const Text('Post Edit', style: TextStyle(color: Colors.black87, fontSize: 20),),
              const SizedBox(height: 30),

              TextField(decoration: const InputDecoration(hintText: 'User Id',
                border: OutlineInputBorder(),
                labelText: 'User Id'
              ),
                  textInputAction: TextInputAction.next,
                  controller: userIdEditing,
                enabled: false,
              ),

              const SizedBox(height: 30),

              TextField(decoration: const InputDecoration(hintText: 'Post Id',
                border: OutlineInputBorder(),
                  labelText: 'Post Id'
              ),
                  textInputAction: TextInputAction.next,
                  controller: postIdEditing,
                enabled: false,
              ),

              const SizedBox(height: 30),

              TextField(decoration: const InputDecoration(hintText: 'Title',
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
                textInputAction: TextInputAction.next,
                controller: titleEditing,
                minLines: 1,
                maxLines: 5,
              ),
              const SizedBox(height: 30),
              TextField(decoration: const InputDecoration(hintText: 'Body',
                border: OutlineInputBorder(),
                labelText: 'Body',
              ),
                textInputAction: TextInputAction.next,
                controller: bodyEditing,
                maxLines: 5,
              ),
              const SizedBox(height: 40),
              SizedBox(width: double.infinity,height: 60,
                  child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {
                        onSubmit(context);
                      },
                      child: const Text('Update Post', style: TextStyle(color: Colors.white, fontSize: 18),)
                  )
              ),
              const SizedBox(width: double.infinity,height: 20),

            ],
          )
      ),
    ));
  }

  /*
    This method used to validate the input field and internet connection check.
   */
  Future<void> onSubmit(BuildContext context) async {
    bool isValidate = true;
    if (titleEditing.text.toString() == "") {
      Utils.showToast(constant.emptyTitle);
      isValidate = false;
    }
    else if (bodyEditing.text.toString() == "") {
      Utils.showToast(constant.emptyBody);
      isValidate = false;
    }
    if(isValidate) {
      Utils.checkInternet().then((value) {
        if (value != null && value) {
          String request = json.encode(<String, dynamic>{
            'id': int.parse(postIdEditing.text.toString()),
            'title': titleEditing.text.toString(),
            'body': bodyEditing.text.toString(),
            'userId': int.parse(userIdEditing.text.toString())
          });
          setState(() {
            showLoaderDialog(context);
            updatePostApi(request, postIdEditing.text.toString());
          });
        }
        else {
          Utils.showToast(constant.noInternet);
        }
      });
    }
  }

  /*
      This method used to update the Post in API
  */
    void updatePostApi(String request, String id) async {
    print(request);
    http.Response res = await http.put(Uri.parse('${api_constant.postApi}/$id'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: request);
    print(res.body);

    if(res.statusCode == 200) {
        Map<String, dynamic> map = json.decode(res.body) as Map<String, dynamic>;
        Post p = Post.fromJson(map);
        Utils.showToast("Post is updated successfully");
        Navigator.pop(context);
        Navigator.pop(context);
    }
    else {
      Utils.showToast("Unable to upload the data");
        Navigator.pop(context);
    }
  }

  /*
     This method used to show loader when calling API
  */
  showLoaderDialog(BuildContext mContext) {
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Updating..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}