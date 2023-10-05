import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'http demo',
        theme: ThemeData(
            primaryColor: Colors.lightBlue, primarySwatch: Colors.lime),
        home: const HomeWidget(),
      );
}

Future<Post> fetchPost() async {
  final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

Future<Post> createPost(String title, String body) async {
  Map<String, dynamic> request = {
    'userId': "111",
    'title': title,
    'body': body
  };
  final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  final response = await http.post(uri, body: request);

  if (response.statusCode == 201) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

Future<Post> updatePost(String title, String body) async {
  Map<String, dynamic> request = {
    'id': '101',
    'userId': '111',
    'title': title,
    'body': body,
  };
  final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  final response = await http.put(uri, body: request);
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

Future<Post?>? deletePost() async {
  final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  final response = await http.delete(uri);
  if (response.statusCode == 200) {
    return null;
  } else {
    throw Exception('Failed to load post');
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Future<Post?>? post;

  void clickGetButton() {
    setState(() {
      post = fetchPost();
    });
  }

  void clickDeleteButton() {
    setState(() {
      post = deletePost();
    });
  }

  void clickPostButton() {
    setState(() {
      post = createPost("titlecailonmeno", "body cai dau buoi");
    });
  }

  void clickUpdateButton() {
    setState(() {
      post = updatePost('test111999200', "updated");
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Center(
            child: Text('http request demo'),
          ),
        ),
        body: SizedBox(
          height: 500,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<Post?>(
                  future: post,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Container();
                    } else {
                      if (snapshot.hasData) {
                        return buildDataWidget(context, snapshot);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        return Container();
                      }
                    }
                  }),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => clickGetButton(),
                  child: const Text("GET"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => clickPostButton(),
                  child: const Text("POST"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => clickUpdateButton(),
                  child: const Text("UPDATE"),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => clickDeleteButton(),
                  child: const Text("Delete"),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildDataWidget(context, snapshot) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              snapshot.data.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(snapshot.data.description),
          ),
        ],
      );
}
