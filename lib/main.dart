import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'Fullnews.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.black),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> newslist = new List();
  var currentPageValue = 0.0;
  PageController controller = PageController(viewportFraction: 0.8,initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    GetValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text('News App'),
      ),
      body: PageView.builder(
          controller: controller,
          pageSnapping: true,
          itemCount: newslist.length,
          itemBuilder: (context, position) {
            if (position == currentPageValue.floor()) {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateX(currentPageValue - position),
                child: CardWidget(newslist[position]),
              );
            } else if (position == currentPageValue.floor() + 1) {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateX(currentPageValue - position),
                child: CardWidget(newslist[position]),
              );
            } else {
              return CardWidget(newslist[position]);
            }
          }),
    );
  }

  Future<void> GetValues() async {
    String url =
        "http://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=4be30807954d4743b09d7cf228734974";
    Response response = await get(url);
    var rb = response.body;
    var list = json.decode(rb);

    setState(() {
      newslist.addAll(list['articles']);
    });
  }

  Widget CardWidget(item) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Fullnews(item)));
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(20)),
          child: Card(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    item['urlToImage'] != null
                        ? CachedNetworkImage(
                            imageUrl: item['urlToImage'],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )
                        : Icon(Icons.error),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        item['title'],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      item['description'],
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
