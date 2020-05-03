import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Fullnews extends StatefulWidget {
  var item;

  Fullnews(this.item);

  @override
  _FullnewsState createState() => _FullnewsState();
}

class _FullnewsState extends State<Fullnews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(widget.item['title']),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImage(
              height: 250,
              imageUrl: widget.item['urlToImage'],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.item['description'],
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
