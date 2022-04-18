

import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpostapi/model/User.dart';
import 'package:flutterpostapi/utility/Utils.dart';
import '/utility/Constant.dart' as constant;
import 'package:http/http.dart' as http;
import '../utility/ApiConstant.dart' as api_constant;

/*
       CreatedBy: Ankit Agrahari
       CreatedDate: 15/04/2022
       Description: This class is used to create new Post on Server.
*/
class PostCreate extends StatelessWidget {
  const PostCreate({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Post Create')),
        body: const PostCreatePage());
  }
}

class PostCreatePage extends StatefulWidget {

  const PostCreatePage({Key? key}) : super(key: key);

  @override
  PostCreateState createState()  => PostCreateState();
}

class PostCreateState extends State<PostCreatePage> {
  final TextEditingController titleEditing = TextEditingController();
  final TextEditingController bodyEditing = TextEditingController();

  List<User> userList = <User>[User(id: 0, name: 'Select User', username:'Select User')];
  late Future<List<User>> userFutureList;

  User? selectedUser;


  @override
  void initState() {
    super.initState();
    //Checking Internet Connection
    Utils.checkInternet().then((value) {
      if (value != null && value) {
        fetchUserList();
      }
      else {
        Utils.showToast(constant.noInternet);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SingleChildScrollView(child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
          const Text('Post Create', style: TextStyle(color: Colors.black87, fontSize: 20),),
            const SizedBox(height: 30),

            DropdownButton<User>(
              isExpanded: true,
              value: selectedUser,
              hint: const Text("Select a user"),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: userList.map<DropdownMenuItem<User>>((User user) {
                return DropdownMenuItem<User>(
                  child: Text(user.name, ),
                  value: user,
                );
              }).toList(),
              onChanged: (User? text) {
                setState(() {
                  selectedUser = text!;
                });
              },
            ),

            const SizedBox(height: 30),

          TextField(decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Title',
          ),
            textInputAction: TextInputAction.next,
            controller: titleEditing,
            minLines: 1,
            maxLines: 5,
          ),
    const SizedBox(height: 30),

      TextField(decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Body',
          ),
          textInputAction: TextInputAction.next,
          textAlignVertical: TextAlignVertical.top,
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
            child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 18),)
            )
          ),
      const SizedBox(width: double.infinity,height: 20)]))));

  }

  /*
        CreatedBy: Ankit Agrahari
        CreatedDate: 15/04/2022
        Description: This method perform validation on fields and create the request to call API.
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
    else if(selectedUser ==  null) {
      Utils.showToast(constant.selectUser);
      isValidate = false;
    }
    if(isValidate) {
      Utils.checkInternet().then((value) {
        if (value != null && value) {
          String request = json.encode(<String, dynamic>{
            'title': titleEditing.text.toString(),
            'body': bodyEditing.text.toString(),
            'userId': selectedUser!= null? selectedUser?.id: 0
          });
          setState(() {
            showLoaderDialog(context);
            createPostApi(request);
            //isLoaderVisible = false;
          });
        }
        else {
          Utils.showToast(constant.noInternet);
        }
      });
    }
  }

  /*
        createdBy: Ankit Agrahari
        createdDate: 15/04/2022
        Description: This method used to upload the post data on server.
  */
  void createPostApi(String request) async {
    print(request);
    http.Response res = await http.post(Uri.parse(api_constant.postApi), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: request);
    print(res.body);
    print("code == ${res.statusCode}");
    if(res.statusCode == 201) {
      Utils.showToast("Post is created successfully");
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    }
    else {
      Utils.showToast("Unable to Create new Post");
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  /*
        createdBy: Ankit Agrahari
        createdDate: 15/04/2022
        Description: This method show the loader while calling API.
  */
  showLoaderDialog(BuildContext mContext) {
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Creating..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

    /*
         CreatedBy: Ankit Agrahari
         CreatedDate: 15/04/2022
         Description: This method fetch User List from server and bind that list in DropDown field.
    */
    fetchUserList() async {
      final response = await http.get(Uri.parse(api_constant.userApi));
      if (response.statusCode == 200) {
        List<dynamic> list = json.decode(response.body) as List<dynamic>;
        List<User> users= List<User>.from(list.map((map) => User.fromJson(map)));
        print(users.toString());
        setState(() {
          userList.clear();
          userList.addAll(users);
        });

        print(userList.toString());
      }
      else {
        Utils.showToast('Failed to load the Post List');
      }
   }

}