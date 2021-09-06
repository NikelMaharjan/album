import 'dart:convert';

import 'package:album_api/src/models/album_response_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluttertoast/fluttertoast.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}


class _AppState extends State<App> {

  List<AlbumResponseModel> albumList = [];
  List<AlbumResponseModel> albumDisplay = [];

  launchURL(url) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("connected");
      if (await canLaunch(url)) {
        await launch(url);
      }
    } else {
      Fluttertoast.showToast(
        msg: "Check Your Internet",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future fetchAlbum() async {
    var uri = Uri.parse("https://api.fresco-meat.com/api/albums/");
    var response = await get(uri);
    var body = response.body;
    var parsedMap = jsonDecode(body);
    for (var parse in parsedMap) {
      var albumModel = AlbumResponseModel.fromJson(parse);
      albumList.add(albumModel);
      albumDisplay = albumList;
    }
    setState(() {});
  }

  @override
  void initState() {
    fetchAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("ALBUM"),
            elevation: 8.0,
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: (){
          //    // checkConnection();
          //   },
          //   child: Icon(Icons.add),
          // ),
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index == 0 ? searchBar() : buildEachItem(index - 1);
            },
            itemCount: albumDisplay.length + 1,
          )),
    );
  }

  Container buildEachItem(int index) {
    return Container(
        height: 500,
        color: Colors.grey[200],
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        //decoration: BoxDecoration(border: Border.all()),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(6.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    albumDisplay[index].thumbnail!,
                    height: 50,
                    width: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          albumDisplay[index].title!,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(albumDisplay[index].artist!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Image.network(
              albumDisplay[index].image!,
              fit: BoxFit.fitHeight,
            )),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    launchURL(albumDisplay[index].url!);
                  },
                  child: Text("Buy Album")),
            )
          ],
        ));
  }
  searchBar() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: 'Search Artist.....'),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            albumDisplay = albumList.where((album) {
              var albumArtist = album.artist!.toLowerCase();
              return albumArtist.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   content: Text("Check Your Internet!"),
  //   duration: Duration(seconds: 3),));
}

// checkConnection() async {
//   var connectivityResult = await(Connectivity().checkConnectivity());
//   if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
//     fetchAlbum();
//   }
//   else{
//     Fluttertoast.showToast(msg: "Check Your Internet",
//       toastLength: Toast.LENGTH_LONG,
//     );
//   }
// }
