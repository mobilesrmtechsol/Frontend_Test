import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterpostapi/model/Post.dart';
import 'package:flutterpostapi/ui/EditPost.dart';
import 'package:flutterpostapi/ui/PostCreate.dart';
import 'package:flutterpostapi/ui/PostDetail.dart';
import 'package:flutterpostapi/utility/Utils.dart';
import 'package:http/http.dart' as http;
import '../utility/ApiConstant.dart' as api_constant;
import '/utility/Constant.dart' as constant;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Builder(
        builder:  (context) => Scaffold(appBar: AppBar(title: const Text('Post List'),
        ), body: const MyHomePage(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PostCreate()));
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
        )));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Post>> postList;

  @override
  void initState() {
    super.initState();
    postList = fetchPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
        FutureBuilder(future: postList,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                    itemBuilder: (BuildContext itemBuilder, int pos) {
                      return InkWell(child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                          child: Column(children: [
                            Align(alignment: Alignment.topLeft,
                                child: Text(
                                    'User Id: ${snapshot.data[pos].userId
                                        .toString()}',
                                    style: const TextStyle(fontSize: 17))),
                            Align(alignment: Alignment.topLeft,
                                child: Text(snapshot.data[pos].title,
                                    style: const TextStyle(fontSize: 17))),

                            Align(alignment: Alignment.centerLeft,
                                child: Row(children: [
                                  IconButton(onPressed: () {
                                    if (kDebugMode) {
                                      print('deleted Item');
                                    }
                                    showConfirmationDialog(context, snapshot.data[pos].id, pos);
                                  }
                                      , icon: const Icon(Icons.delete_sharp, color: Colors.blueAccent, size:30,)
                                  ),
                                  SizedBox(width: 10,),
                                  IconButton(onPressed: () {
                                    if (kDebugMode) {
                                      print('Edit');
                                    }
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditPost(mPost: snapshot.data[pos])));
                                  }
                                      , icon: const Icon(Icons.edit, color: Colors.blueAccent, size:30,)
                                  )
                                ])
                            )
                          ],
                          )
                      ),
                        onTap: () {
                          _navigateToNextScreen(context, snapshot.data[pos]);
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(color: Colors.black87,);
                    },
                    itemCount: snapshot.data.length);
              }
              else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              else {
                return const CircularProgressIndicator();
              }
            })

    );
  }

  /*
    This method used to navigate to Post Detail screen
  */
  void _navigateToNextScreen(BuildContext context, Post post) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetail(mPost: post)));
  }

  /*
    This method used to fetch Post List from API.
  */
  Future<List<Post>> fetchPostList() async {
    final response = await http.get(Uri.parse(api_constant.postApi));
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body) as List<dynamic>;
      var postList = <Post>[];
      return List<Post>.from(list.map((map) => Post.fromJson(map)));
    }
    else {
      throw Exception('Failed to load the Post List');
    }
  }

  /*
    This method used to show confirmation dialog before deleting the post from Post List
  */
  void showConfirmationDialog(BuildContext context, int id, int pos) {
    AlertDialog alertDialog = AlertDialog(title: const Text('Confirmation'),
      content: const Text('Are you sure to delete this post?'),
      actions: [TextButton(onPressed: () {
        //showToast('Your are successfully logout from app');
        print('Deleting');
        Navigator.of(context).pop();
        showLoaderDialog(context);
        deletePost(id, pos);
      },
        child: const Text('OK'),),
        TextButton(onPressed: () {
          print('Cancelling');
          Navigator.of(context).pop();
        }, child: const Text('Cancel'))
      ],
    );
    showDialog(context: context, builder: (BuildContext builder) {
      return alertDialog;
    });
  }

  /*
      This method used to call the delete API and delete the Post from List.
  */
  void deletePost(int id, int pos) async {
    final response = await http.delete(Uri.parse("${api_constant.postApi}/$id"));
    if (response.statusCode == 200) {
      Utils.showToast('Post deleted successfully');
      print('Deleted successfully');
      setState(() {
        postList.then((value) => value.removeAt(pos));
      });
      Navigator.pop(context);
    }

    else {
      Navigator.pop(context);
      throw Exception('Unable to delete the Post List');
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
          Container(margin: EdgeInsets.only(left: 7),child:Text("Deleting..." )),
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
